//
//  Lin.m
//  Lin
//
//  Created by Tanaka Katsuma on 2013/08/21.
//  Copyright (c) 2013年 Tanaka Katsuma. All rights reserved.
//

#import "Lin.h"

// Xcode
#import "IDEWorkspace.h"
#import "DVTFilePath.h"
#import "IDEIndex.h"
#import "IDEIndexCollection.h"
#import "IDEEditorDocument.h"
#import "IDEWorkspaceWindow.h"
#import "DVTSourceTextView.h"

// Categories
#import "NSBundle+versions.h"

// Shared
#import "LNUserDefaultsManager.h"

// Models
#import "LNDetector.h"
#import "LNEntity.h"
#import "LNLocalizationCollection.h"
#import "LNLocalization.h"

// Views
#import "LNPopoverContentView.h"

// Controllers
#import "LNPopoverWindowController.h"
#import "LNLocalizedStringCollectionOperation.h"

static Lin *_sharedPlugin = nil;

@interface NSPopover ()

- (id)_popoverWindow;

@end

@interface Lin ()

@property (nonatomic, strong) NSPopover *popover;
@property (nonatomic, strong) LNPopoverWindowController *popoverWindowController;

@property (nonatomic, strong) NSTextView *textView;

@property (nonatomic, strong) LNDetector *detector;
@property (nonatomic, strong) NSMutableDictionary *workspaceLocalizations;
@property (nonatomic, copy) NSString *currentWorkspaceFilePath;
@property (nonatomic, unsafe_unretained) NSResponder *previousFirstResponder;
@property (nonatomic, assign, getter = isActivated) BOOL activated;

@property (nonatomic, strong) NSMenuItem *enableMenuItem;
@property (nonatomic, strong) NSMenuItem *showWindowMenuItem;
@property (nonatomic, strong) NSOperationQueue *collectionProcessQueue;

@end

@implementation Lin

+ (void)pluginDidLoad:(NSBundle *)bundle
{
    static dispatch_once_t _onceToken;
    dispatch_once(&_onceToken, ^{
        _sharedPlugin = [[self alloc] init];
    });
}

+ (instancetype)sharedPlugIn
{
    return _sharedPlugin;
}

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        // Initialization
        self.detector = [LNDetector detector];
        self.workspaceLocalizations = [NSMutableDictionary dictionary];
        
        // Create menu
        [self createMenuItem];
        
        // Load views
        [self instantiatePopover];
        [self instantiatePopoverWindowController];
        
        // Register to notification center
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(workspaceWindowDidBecomeMain:)
                                                     name:NSWindowDidBecomeMainNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(indexDidIndexWorkspace:)
                                                     name:@"IDEIndexDidIndexWorkspaceNotification"
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(editorDocumentDidSave:)
                                                     name:@"IDEEditorDocumentDidSaveNotification"
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(popoverWindowControllerWindowWillClose:)
                                                     name:LNPopoverWindowControllerWindowWillCloseNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(popoverContentViewLocalizationDidSelect:)
                                                     name:LNPopoverContentViewLocalizationDidSelectNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(popoverContentViewAlertDidDismiss:)
                                                     name:LNPopoverContentViewAlertDidDismissNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(popoverContentViewDetachButtonDidClick:)
                                                     name:LNPopoverContentViewDetachButtonDidClickNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(menuDidChange:)
                                                     name:NSMenuDidChangeItemNotification
                                                   object:nil];
        
        // Activate if enabled
        if ([[LNUserDefaultsManager sharedManager] isEnabled]) {
            [self activate];
        }
        
        self.collectionProcessQueue = [[NSOperationQueue alloc] init];
        self.collectionProcessQueue.maxConcurrentOperationCount = 1;
    }
    
    return self;
}

- (void)instantiatePopover
{
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSViewController *contentViewController = [[NSViewController alloc] initWithNibName:@"LNPopoverContentView" bundle:bundle];
    
    NSPopover *popover = [[NSPopover alloc] init];
    popover.delegate = self;
    popover.behavior = NSPopoverBehaviorTransient;
    popover.appearance = NSPopoverAppearanceMinimal;
    popover.animates = NO;
    popover.contentViewController = contentViewController;
    
    self.popover = popover;
}

- (void)instantiatePopoverWindowController
{
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSViewController *contentViewController = [[NSViewController alloc] initWithNibName:@"LNPopoverContentView" bundle:bundle];
    LNPopoverContentView *contentView = (LNPopoverContentView *)contentViewController.view;
    [contentView.detachButton setHidden:YES];
    
    LNPopoverWindowController *popoverWindowController = [[LNPopoverWindowController alloc] initWithContentViewController:contentViewController];
    
    self.popoverWindowController = popoverWindowController;
}

- (void)dealloc
{
    // Deactivate
    [self deactivate];
    
    // Remove from notification center
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:NSWindowDidBecomeMainNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"IDEIndexDidIndexWorkspaceNotification"
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"IDEEditorDocumentDidSaveNotification"
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:LNPopoverWindowControllerWindowWillCloseNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:LNPopoverContentViewLocalizationDidSelectNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:LNPopoverContentViewAlertDidDismissNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:LNPopoverContentViewDetachButtonDidClickNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:NSMenuDidChangeItemNotification
                                                  object:nil];
}


#pragma mark - Managing Application State

- (void)activate
{
    if (!self.activated) {
        self.activated = YES;
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(textDidChange:)
                                                     name:NSTextDidChangeNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(textViewDidChangeSelection:)
                                                     name:NSTextViewDidChangeSelectionNotification
                                                   object:nil];
    }
}

- (void)deactivate
{
    if (self.activated) {
        self.activated = NO;
        
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:NSTextDidChangeNotification
                                                      object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:NSTextViewDidChangeSelectionNotification
                                                      object:nil];
    }
}


#pragma mark - Notifications

- (void)textDidChange:(NSNotification *)notification
{
	if ([[notification object] isKindOfClass:[DVTSourceTextView class]]) {
        NSTextView *textView = (NSTextView *)[notification object];
        self.textView = textView;
        
        // Find entity
        LNEntity *entity = [self selectedEntityInTextView:textView];
        
        if (entity) {
            [self presentPopoverInTextView:textView entity:entity];
        } else {
            [self dismissPopover];
        }
	}
}

- (void)textViewDidChangeSelection:(NSNotification *)notification
{
	if ([[notification object] isKindOfClass:[DVTSourceTextView class]]) {
        NSTextView *textView = (NSTextView *)[notification object];
        self.textView = textView;
        
        // Find entity
        LNEntity *entity = [self selectedEntityInTextView:textView];
        
        if (entity) {
            [self presentPopoverInTextView:textView entity:entity];
        } else {
            [self dismissPopover];
        }
	}
}

- (void)workspaceWindowDidBecomeMain:(NSNotification *)notification
{
    if ([[notification object] isKindOfClass:[IDEWorkspaceWindow class]]) {
        NSWindow *workspaceWindow = (NSWindow *)[notification object];
        NSWindowController *workspaceWindowController = (NSWindowController *)workspaceWindow.windowController;
        
        IDEWorkspace *workspace = (IDEWorkspace *)[workspaceWindowController valueForKey:@"_workspace"];
        DVTFilePath *representingFilePath = workspace.representingFilePath;
        NSString *pathString = representingFilePath.pathString;
        
        self.currentWorkspaceFilePath = pathString;
    }
}

- (void)indexDidIndexWorkspace:(NSNotification *)notification
{
    IDEIndex *index = (IDEIndex *)[notification object];
    [self indexNeedsUpdate:index];
}

- (void)editorDocumentDidSave:(NSNotification *)notification
{
    IDEEditorDocument *editorDocument = (IDEEditorDocument *)[notification object];
    DVTFilePath *filePath = editorDocument.filePath;
    NSString *pathString = filePath.pathString;
    
    // Check whether there are any changes to .strings
    NSArray *collections = [self.workspaceLocalizations objectForKey:self.currentWorkspaceFilePath];
    
    for (LNLocalizationCollection *collection in collections) {
        if ([collection.filePath isEqualToString:pathString]) {
            [collection reloadLocalizations];
            
            break;
        }
    }
}

- (void)popoverWindowControllerWindowWillClose:(NSNotification *)notification
{
    // Instantiate popover
    [self instantiatePopover];
}

- (void)popoverContentViewLocalizationDidSelect:(NSNotification *)notification
{
    NSTextView *textView = self.textView;
    LNEntity *entity = [self selectedEntityInTextView:textView];
    
    if (entity) {
        NSArray *selectedRanges = textView.selectedRanges;
        
        if (selectedRanges.count > 0) {
            NSRange selectedRange = [[selectedRanges objectAtIndex:0] rangeValue];
            
            // Locate the key
            NSRange lineRange = [textView.textStorage.string lineRangeForRange:selectedRange];
            NSRange keyRange = NSMakeRange(lineRange.location + entity.keyRange.location, entity.keyRange.length);
            
            // Replace
            LNLocalization *localization = [[notification userInfo] objectForKey:LNPopoverContentViewLocalizationKey];
            [textView insertText:localization.key replacementRange:keyRange];
        }
    }
}

- (void)popoverContentViewAlertDidDismiss:(NSNotification *)notification
{
    // Show popover again
    [self presentPopoverInTextView:self.textView entity:[self selectedEntityInTextView:self.textView]];
}

- (void)popoverContentViewDetachButtonDidClick:(NSNotification *)notification
{
    [self preparePopoverWindow];
    [self detachPopover];
}

- (void)menuDidChange:(NSNotification *)notification
{
    // Create menu item
    [self createMenuItem];
}


#pragma mark - Detachig Popover

- (void)preparePopoverWindow
{
    // Resize popover window
    NSWindow *popoverWindow = [self.popover _popoverWindow];
    
    [self.popoverWindowController.window setFrame:NSMakeRect(popoverWindow.frame.origin.x,
                                                             popoverWindow.frame.origin.y - (80.0 / 2.0),
                                                             self.popover.contentSize.width,
                                                             self.popover.contentSize.height + 80.0)
                                          display:NO];
    
    // Copy popover content
    LNPopoverContentView *popoverContentView = (LNPopoverContentView *)self.popover.contentViewController.view;
    LNPopoverContentView *popoverWindowContentView = (LNPopoverContentView *)self.popoverWindowController.contentViewController.view;
    popoverWindowContentView.tableView.sortDescriptors = popoverContentView.tableView.sortDescriptors;
    popoverWindowContentView.collections = popoverContentView.collections;
    popoverWindowContentView.searchString = popoverContentView.searchString;
}

- (void)detachPopover
{
    [self dismissPopover];
    [self.popoverWindowController showWindow:nil];
}


#pragma mark - Entity

- (LNEntity *)selectedEntityInTextView:(NSTextView *)textView
{
    NSArray *selectedRanges = textView.selectedRanges;
    
    if (selectedRanges.count > 0) {
        NSRange selectedRange = [[selectedRanges objectAtIndex:0] rangeValue];
        
        // Locate the line containing the caret
        NSString *string = textView.textStorage.string;
        NSRange lineRange = [string lineRangeForRange:selectedRange];
        NSString *lineString = [string substringWithRange:lineRange];
        NSRange selectedRangeInLine = NSMakeRange(selectedRange.location - lineRange.location, selectedRange.length);
        
        // Search for the entities
        NSArray *entities = [self.detector entitiesInString:lineString];
        
        for (LNEntity *entity in entities) {
            if (NSLocationInRange(selectedRangeInLine.location, entity.entityRange)) {
                return entity;
            }
        }
    }
    
    return nil;
}


#pragma mark - Menu

- (void)createMenuItem
{
    NSMenuItem *editorMenuItem = [[NSApp mainMenu] itemWithTitle:@"Editor"];
    
    if (editorMenuItem && [[editorMenuItem submenu] itemWithTitle:@"Lin"] == nil) {
        // Load defaults
        BOOL enabled = [[LNUserDefaultsManager sharedManager] isEnabled];
        
        NSMenuItem *menuItem = [[NSMenuItem alloc] initWithTitle:@"Lin" action:NULL keyEquivalent:@""];
        
        NSMenu *submenu = [[NSMenu alloc] initWithTitle:@"Lin"];
        menuItem.submenu = submenu;
        
        // Enable Lin
        NSMenuItem *enableMenuItem = [[NSMenuItem alloc] initWithTitle:@"Enable Lin" action:@selector(toggleEnabled:) keyEquivalent:@""];
        [enableMenuItem setTarget:self];
        enableMenuItem.state = enabled ? NSOnState : NSOffState;
        
        [submenu addItem:enableMenuItem];
        self.enableMenuItem = enableMenuItem;
        
        // Show Window
        NSMenuItem *showWindowMenuItem = [[NSMenuItem alloc] initWithTitle:@"Show Window" action:@selector(showWindow:) keyEquivalent:@""];
        [showWindowMenuItem setTarget:self];
        
        [submenu addItem:showWindowMenuItem];
        self.showWindowMenuItem = showWindowMenuItem;
        
        // Separator
        [submenu addItem:[NSMenuItem separatorItem]];
        
        // Version Info
        NSMenuItem *versionInfoMenuItem = [[NSMenuItem alloc] initWithTitle:@"Version Info" action:@selector(showVersionInfo:) keyEquivalent:@""];
        [versionInfoMenuItem setTarget:self];
        [submenu addItem:versionInfoMenuItem];
        
        [[editorMenuItem submenu] addItem:[NSMenuItem separatorItem]];
        [[editorMenuItem submenu] addItem:menuItem];
    }
}

- (BOOL)validateMenuItem:(NSMenuItem *)menuItem
{
    if (menuItem == self.showWindowMenuItem) {
        return [[LNUserDefaultsManager sharedManager] isEnabled];
    }
    
    return YES;
}

- (void)toggleEnabled:(id)sender
{
    // Save defaults
    LNUserDefaultsManager *userDefaultManager = [LNUserDefaultsManager sharedManager];
    BOOL enabled = ![userDefaultManager isEnabled];
    userDefaultManager.enabled = enabled;
    
    // Update menu item
    self.enableMenuItem.state = enabled ? NSOnState : NSOffState;
    
    // Activate/Deactivate
    if (enabled) {
        [self activate];
    } else {
        [self deactivate];
    }
}

- (void)showWindow:(id)sender
{
    // Prepare window
    NSArray *collections = [self.workspaceLocalizations objectForKey:self.currentWorkspaceFilePath];
    
    LNPopoverContentView *popoverWindowContentView = (LNPopoverContentView *)self.popoverWindowController.contentViewController.view;
    popoverWindowContentView.collections = collections;
    popoverWindowContentView.searchString = @"";
    
    // Show window
    [self.popoverWindowController.window setFrame:NSMakeRect(0, 0, 500, 280) display:NO];
    [self.popoverWindowController.window center];
    [self.popoverWindowController showWindow:nil];
}

- (void)showVersionInfo:(id)sender
{
    // Create alert
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSAlert *alert = [NSAlert alertWithMessageText:@"Lin"
                                     defaultButton:@"OK"
                                   alternateButton:nil
                                       otherButton:@"Open Website"
                         informativeTextWithFormat:@"Version %@\n\nCopyright (c) 2013 Katsuma Tanaka\n\nEmail: questbeat@gmail.com\nTwitter: @questbeat", [bundle shortVersionString]];
    
    // Set icon
    NSString *filePath = [bundle pathForResource:@"icon120" ofType:@"tiff"];
    NSImage *icon = [[NSImage alloc] initWithContentsOfFile:filePath];
    [alert setIcon:icon];
    
    // Show alert
    if ([alert runModal] == NSAlertOtherReturn) {
        [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"http://questbe.at/lin"]];
    }
}


#pragma mark - Index

- (void)indexNeedsUpdate:(IDEIndex *)index
{
    DVTFilePath *workspaceFile = index.workspaceFile;
    NSString *workspaceFilePath = workspaceFile.pathString;
    
    if (workspaceFilePath) {
        [self.collectionProcessQueue cancelAllOperations];
        [self updateLocalizationsForIndex:index];
    }
}

- (void)updateLocalizationsForIndex:(IDEIndex *)index
{
    LNLocalizedStringCollectionOperation *processOperation = [[LNLocalizedStringCollectionOperation alloc] initWithIndex:index];
    processOperation.collectionCompletedBlock = ^(NSString *workspaceFilePath, NSArray *collections) {
        [self.workspaceLocalizations setObject:collections forKey:workspaceFilePath];
        if ([workspaceFilePath isEqualToString:self.currentWorkspaceFilePath]) {
            if ([self.popover isShown]) {
                LNPopoverContentView *contentView = (LNPopoverContentView *)self.popover.contentViewController.view;
                contentView.collections = collections;
            } else if ([self.popoverWindowController.window isVisible]) {
                LNPopoverContentView *contentView = (LNPopoverContentView *)self.popoverWindowController.contentViewController.view;
                contentView.collections = collections;
            }
        }
    };
    
    [self.collectionProcessQueue addOperation:processOperation];
}

- (void)removeLocalizationsForIndex:(IDEIndex *)index
{
    DVTFilePath *workspaceFile = index.workspaceFile;
    NSString *workspaceFilePath = workspaceFile.pathString;
    
    if (workspaceFilePath) {
        [self.workspaceLocalizations removeObjectForKey:workspaceFilePath];
    }
}


#pragma mark - Popover

- (void)presentPopoverInTextView:(NSTextView *)textView entity:(LNEntity *)entity
{
    if (![[LNUserDefaultsManager sharedManager] isEnabled]) {
        return;
    }
    
    NSArray *selectedRanges = textView.selectedRanges;
    
    if (selectedRanges.count > 0) {
        NSRange selectedRange = [[selectedRanges objectAtIndex:0] rangeValue];
        
        // Locate the line containing the caret
        NSRange lineRange = [textView.textStorage.string lineRangeForRange:selectedRange];
        
        // Stick popover at the beginning of the key
        NSRange keyRange = NSMakeRange(lineRange.location + entity.keyRange.location, 1);
        NSRect keyRectOnScreen = [textView firstRectForCharacterRange:keyRange];
        NSRect keyRectOnWindow = [textView.window convertRectFromScreen:keyRectOnScreen];
        NSRect keyRectOnTextView = [textView convertRect:keyRectOnWindow fromView:nil];
        
        // Update or show popover
        NSArray *collections = [self.workspaceLocalizations objectForKey:self.currentWorkspaceFilePath];
        NSString *key = [textView.textStorage.string substringWithRange:NSMakeRange(lineRange.location + entity.keyRange.location, entity.keyRange.length)];
        
        if ([self.popoverWindowController.window isVisible]) {
            // Update popover content
            LNPopoverContentView *contentView = (LNPopoverContentView *)self.popoverWindowController.contentViewController.view;
            contentView.collections = collections;
            contentView.searchString = key;
        } else {
            if ([self.popover isShown]) {
                // Update the position for popover when the cursor moved
                self.popover.positioningRect = keyRectOnTextView;
                
                // Update popover content
                LNPopoverContentView *contentView = (LNPopoverContentView *)self.popover.contentViewController.view;
                contentView.searchString = key;
            } else {
                // Show popover
                [self.popover showRelativeToRect:keyRectOnTextView
                                          ofView:textView
                                   preferredEdge:NSMinYEdge];
                
                // Update popover content
                LNPopoverContentView *contentView = (LNPopoverContentView *)self.popover.contentViewController.view;
                contentView.collections = collections;
                contentView.searchString = key;
            }
        }
    }
}

- (void)dismissPopover
{
    if ([self.popoverWindowController.window isVisible]) {
        // Update popover content
        NSArray *collections = [self.workspaceLocalizations objectForKey:self.currentWorkspaceFilePath];
        
        LNPopoverContentView *contentView = (LNPopoverContentView *)self.popoverWindowController.contentViewController.view;
        contentView.collections = collections;
        contentView.searchString = nil;
    } else {
        // Hide popover
        if (self.popover.shown) {
            [self.popover performClose:self];
        }
    }
}


#pragma mark - NSPopoverDelegate

- (void)popoverWillShow:(NSNotification *)notification
{
    // Save first responder
    self.previousFirstResponder = [self.textView.window firstResponder];
}

- (void)popoverDidShow:(NSNotification *)notification
{
    // Reclaim key window and first responder
    [self.textView.window becomeKeyWindow];
    [self.textView.window makeFirstResponder:self.previousFirstResponder];
}

- (NSWindow *)detachableWindowForPopover:(NSPopover *)popover
{
    // Prepare for detaching
    [self preparePopoverWindow];
    
    return self.popoverWindowController.window;
}

@end
