//
//  LNPopoverWindow.m
//  Lin
//
//  Created by Tanaka Katsuma on 2013/09/21.
//  Copyright (c) 2013年 Tanaka Katsuma. All rights reserved.
//

#import "LNPopoverWindow.h"

// Views
#import "LNPopoverContentView.h"

// Controllers
#import "LNPopoverWindowController.h"

static NSString * const kLNPopoverWindowToolbarSearchFieldIdentifier = @"Search";

@interface LNPopoverWindow ()

@property (nonatomic, strong) NSSearchField *searchField;

@end

@implementation LNPopoverWindow

+ (instancetype)popoverWindow
{
    LNPopoverWindow *popoverWindow = [[LNPopoverWindow alloc] initWithContentRect:NSZeroRect
                                                                        styleMask:(NSTitledWindowMask | NSClosableWindowMask | NSResizableWindowMask)
                                                                          backing:NSBackingStoreBuffered
                                                                            defer:NO];
    popoverWindow.title = @"Lin";
    popoverWindow.level = NSFloatingWindowLevel;
    popoverWindow.backgroundColor = [NSColor whiteColor];
    [popoverWindow.contentView setAutoresizesSubviews:YES];
    
    return popoverWindow;
}

- (instancetype)initWithContentRect:(NSRect)contentRect styleMask:(NSUInteger)aStyle backing:(NSBackingStoreType)bufferingType defer:(BOOL)flag
{
    self = [super initWithContentRect:contentRect styleMask:aStyle backing:bufferingType defer:flag];
    
    if (self) {
        // Create toolbar
        NSToolbar *toolbar = [[NSToolbar alloc] initWithIdentifier:@"Toolbar"];
        toolbar.delegate = self;
        toolbar.displayMode = NSToolbarDisplayModeIconOnly;
        
        [self setToolbar:toolbar];
    }
    
    return self;
}


#pragma mark - Actions

- (void)textFieldDidReturn:(id)sender
{
    [self controlTextDidChange:nil];
}


#pragma mark - NSToolbarDelegate

- (NSArray *)toolbarDefaultItemIdentifiers:(NSToolbar *)toolbar
{
    return @[NSToolbarFlexibleSpaceItemIdentifier, kLNPopoverWindowToolbarSearchFieldIdentifier];
}

- (NSArray *)toolbarAllowedItemIdentifiers:(NSToolbar *)toolbar
{
    return @[NSToolbarFlexibleSpaceItemIdentifier, kLNPopoverWindowToolbarSearchFieldIdentifier];
}

- (NSToolbarItem *)toolbar:(NSToolbar *)toolbar itemForItemIdentifier:(NSString *)itemIdentifier willBeInsertedIntoToolbar:(BOOL)flag
{
    NSToolbarItem *toolbarItem = nil;
    
    if ([itemIdentifier isEqualToString:kLNPopoverWindowToolbarSearchFieldIdentifier]) {
        toolbarItem = [[NSToolbarItem alloc] initWithItemIdentifier:itemIdentifier];
        
        NSSearchField *searchField = [[NSSearchField alloc] init];
        [searchField setDelegate:self];
        [searchField setTarget:self];
        [searchField setAction:@selector(textFieldDidReturn:)];
        
        [toolbarItem setView:searchField];
        self.searchField = searchField;
    }
    
    return toolbarItem;
}


#pragma mark - NSTextFieldDelegate

- (void)controlTextDidChange:(NSNotification *)obj
{
    LNPopoverWindowController *popoverWindowController = (LNPopoverWindowController *)self.windowController;
    LNPopoverContentView *contentView = (LNPopoverContentView *)popoverWindowController.contentViewController.view;
    
    contentView.searchString = self.searchField.stringValue;
}

@end
