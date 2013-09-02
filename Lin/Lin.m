/*
 Copyright (c) 2013 Katsuma Tanaka

 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#import "Lin.h"

// Xcode Classes
#import "DVTFilePath.h"
#import "IDEIndex.h"
#import "IDEIndexCollection.h"
#import "IDEWorkspace.h"
#import "IDEEditorDocument.h"

// Localization
#import "Localization.h"
#import "LocalizationItem.h"

@interface RegEx : NSObject

@property (nonatomic, retain) NSString *expression;
@property NSUInteger numberOfRanges;
@property NSUInteger entityRangeInLineIndex;
@property NSUInteger keyRangeInLineIndex;

@end

@implementation RegEx

-(id) initWithExpression: ( NSString *) expression numberOfRanges: ( NSUInteger ) numberOfRanges entityRangeInLineIndex: ( NSUInteger ) entityRangeInLineIndex keyRangeInLineIndex: ( NSUInteger ) keyRangeInLineIndex
{
    if (self = [super init]) {
        _expression = [NSString stringWithString: expression];
        _numberOfRanges = numberOfRanges;
        _entityRangeInLineIndex = entityRangeInLineIndex;
        _keyRangeInLineIndex = keyRangeInLineIndex;
    }
    return self;
}

@end

@implementation Lin

static Lin *sharedPlugin = nil;
static NSString *kLinUserDefaultsEnableKey = @"LINEnabled";
static NSString *kLinUserDefaultsParseStringsOutsideProjectKey = @"LINParseStringsOutsideProject";
static NSString *regexs[] = {
    @"NSLocalizedString\\s*\\(\\s*@\"(.*)\"\\s*,\\s*(.*)\\s*\\)",
    @"localizedStringForKey:\\s*@\"(.*)\"\\s*value:\\s*(.*)\\s*table:\\s*(.*)",
    @"NSLocalizedStringFromTable\\s*\\(\\s*@\"(.*)\"\\s*,\\s*(.*)\\s*,\\s*(.*)\\s*\\)",
    @"NSLocalizedStringFromTableInBundle\\s*\\(\\s*@\"(.*)\"\\s*,\\s*(.*)\\s*,\\s*(.*)\\s*,\\s*(.*)\\s*\\)",
    @"NSLocalizedStringWithDefaultValue\\s*\\(\\s*@\"(.*)\"\\s*,\\s*(.*)\\s*,\\s*(.*)\\s*,\\s*(.*)\\s*,\\s*(.*)\\s*\\)" };
static NSUInteger numberOfRanges[] = { 3, 4, 4, 5, 6 };
static NSUInteger entityRangeInLineIndices[] = { 0, 0, 0, 0, 0 };
static NSUInteger keyRangeInLineIndices[] = { 1, 1, 1, 1, 1 };

+ (instancetype)sharedPlugin
{
    return sharedPlugin;
}

+ (void)pluginDidLoad:(NSBundle *)plugin
{
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        sharedPlugin = [[self alloc] initWithBundle:plugin];
    });
}

- (id)init
{
    return [self initWithBundle:nil];
}

- (id)initWithBundle:(NSBundle *)bundle
{
    self = [super init];

    if(self) {
        // Initialization
        self.localizationFileSets = [NSMutableDictionary dictionary];
        self.localizations = [NSMutableDictionary dictionary];

        // Register defaults
        NSDictionary *defaults = [NSDictionary dictionaryWithObjectsAndKeys:
                                  [NSNumber numberWithBool:YES], kLinUserDefaultsEnableKey,
                                  [NSNumber numberWithBool:NO], kLinUserDefaultsParseStringsOutsideProjectKey,
                                  nil];
        [[NSUserDefaults standardUserDefaults] registerDefaults:defaults];

        // Load Nib
        NSNib *nib = [[NSNib alloc] initWithNibNamed:@"Popover" bundle:bundle];
        [nib instantiateNibWithOwner:self topLevelObjects:nil];
        [nib release];

        // Popover settings
        self.popover.delegate = self;
        self.popover.behavior = NSPopoverBehaviorTransient;
        self.popover.animates = NO;

        // Set delegate
        PopoverContentView *popoverContentView = (PopoverContentView *)self.popover.contentViewController.view;
        popoverContentView.delegate = self;

        // Register observer
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidFinishLaunching:) name:NSApplicationDidFinishLaunchingNotification object:nil];

        // Create regexs array
        NSAssert( sizeof(numberOfRanges)/sizeof(NSUInteger) == sizeof(regexs)/sizeof(NSString *), @"Regexs definitions arrays should all have same size" );
        NSAssert( sizeof(entityRangeInLineIndices)/sizeof(NSUInteger) == sizeof(regexs)/sizeof(NSString *), @"Regexs definitions arrays should all have same size" );
        NSAssert( sizeof(keyRangeInLineIndices)/sizeof(NSUInteger) == sizeof(regexs)/sizeof(NSString *), @"Regexs definitions arrays should all have same size" );

        NSMutableArray *pTempRegexs = [NSMutableArray array];

        for(NSUInteger i=0;i<sizeof(regexs)/sizeof(NSString *);i++) {
            [pTempRegexs addObject: [[RegEx alloc] initWithExpression: regexs[i] numberOfRanges:numberOfRanges[i] entityRangeInLineIndex:entityRangeInLineIndices[i] keyRangeInLineIndex:keyRangeInLineIndices[i]]];
        }
        _regexs = [NSArray arrayWithArray: pTempRegexs];
        [pTempRegexs release];
    }

    return self;
}

- (void)setEnabled:(BOOL)enabled
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:enabled forKey:kLinUserDefaultsEnableKey];
    [userDefaults synchronize];
}

- (BOOL)enabled
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:kLinUserDefaultsEnableKey];
}

- (void)setParseStringsOutsideProject:(BOOL)value
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:value forKey:kLinUserDefaultsParseStringsOutsideProjectKey];
    [userDefaults synchronize];
}

- (BOOL)parseStringsOutsideProject
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:kLinUserDefaultsParseStringsOutsideProjectKey];
}

- (void)dealloc
{
    [_textView release];

    [_currentWorkspacePath release];
    [_localizationFileSets release];
    [_localizations release];

    [super dealloc];
}


#pragma mark - Setup

- (void)applicationDidFinishLaunching:(NSNotification *)notification
{
    // Remove observer
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSApplicationDidFinishLaunchingNotification object:nil];

    // Set menu items
    [self createMenuItem];

    if(self.enabled) {
        // Activate
        [self activate];
    }
}


#pragma mark - Index

- (void)indexNeedsUpdate:(IDEIndex *)index
{
    DVTFilePath *workspaceFile = index.workspaceFile;
    NSString *workspaceFilePath = workspaceFile.pathString;

    if(workspaceFilePath) {
        [self updateLocalizationFilesWithIndex:index];
        [self updateLocalizationsForWorkspace:workspaceFilePath];
    }
}

- (void)removeFilesForIndex:(IDEIndex *)index
{
    DVTFilePath *workspaceFile = index.workspaceFile;
    NSString *workspaceFilePath = workspaceFile.pathString;

    if(workspaceFilePath) {
        [self.localizationFileSets removeObjectForKey:workspaceFilePath];
        [self.localizations removeObjectForKey:workspaceFilePath];
    }
}


#pragma mark - Localization

- (void)updateLocalizationFilesWithIndex:(IDEIndex *)index
{
    DVTFilePath *workspaceFile = index.workspaceFile;
    NSString *workspaceFilePath = workspaceFile.pathString;

    if(workspaceFilePath) {
        // Remove previous localization
        [self.localizations removeObjectForKey:workspaceFilePath];

        // Find .strings files
        IDEIndexCollection *indexCollection = [index filesContaining:@".strings" anchorStart:NO anchorEnd:NO subsequence:NO ignoreCase:YES cancelWhen:nil];

        NSMutableSet *localizationFileSet = [NSMutableSet set];

        NSArray *pathComponents = [workspaceFilePath pathComponents];
        NSMutableString *projectRoot = [NSMutableString string];
        for (int i=0; i<pathComponents.count - 2; i++)
            [projectRoot appendFormat:@"%@%@", [pathComponents objectAtIndex:i], i == 0 ? @"" : @"/"];

        for(DVTFilePath *filePath in indexCollection) {
            NSString *pathString = filePath.pathString;

            if(self.parseStringsOutsideProject ||  (!self.parseStringsOutsideProject  &&  [pathString rangeOfString:projectRoot].location != NSNotFound))
            {
                NSLog(@"Adding %@ to localization file set", pathString);
                [localizationFileSet addObject:pathString];
            }
        }

        [self.localizationFileSets setObject:localizationFileSet forKey:workspaceFilePath];
    }
}

- (void)updateLocalizationsForWorkspace:(NSString *)workspaceFilePath
{
    // Update localization data
    NSMutableSet *localizationFileSet = [self.localizationFileSets objectForKey:workspaceFilePath];

    Localization *localization = [Localization localization];

    for(NSString *localizationFilePath in localizationFileSet) {
        [localization addLocalizationFromContentsOfFile:localizationFilePath encoding:NSUTF8StringEncoding];
    }

    [self.localizations setObject:localization forKey:workspaceFilePath];
}


#pragma mark - Menu

- (void)createMenuItem
{
    NSMenuItem *editMenuItem = [[NSApp mainMenu] itemWithTitle:@"Edit"];

    if(editMenuItem) {
        // Load defaults
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        BOOL enabled = [userDefaults boolForKey:kLinUserDefaultsEnableKey];
        BOOL parseStringsOutsideProject = [userDefaults boolForKey:kLinUserDefaultsParseStringsOutsideProjectKey];

        // Separator
        [[editMenuItem submenu] addItem:[NSMenuItem separatorItem]];

        // Enable Lin
        NSMenuItem *menuItem = [[NSMenuItem alloc] initWithTitle:@"Enable Lin" action:@selector(toggle:) keyEquivalent:@""];
        menuItem.target = self;
        menuItem.state = enabled ? NSOnState : NSOffState;

        [[editMenuItem submenu] addItem:menuItem];
        [menuItem release];

        // Parse .strings outside project's path
        menuItem = [[NSMenuItem alloc] initWithTitle:@"Parse .strings outside project's path" action:@selector(toggleParse:) keyEquivalent:@""];
        menuItem.target = self;
        menuItem.state = parseStringsOutsideProject ? NSOnState : NSOffState;

        [[editMenuItem submenu] addItem:menuItem];
        [menuItem release];
    }
}

- (void)toggle:(id)sender
{
    // Save defaults
    self.enabled = !self.enabled;

    // Update menu item
    NSMenuItem *menuItem = (NSMenuItem *)sender;
    menuItem.state = self.enabled ? NSOnState : NSOffState;

    if(self.enabled) {
        [self activate];
    } else {
        [self deactivate];
    }
}

- (void)toggleParse:(id)sender
{
    // Save defaults
    self.parseStringsOutsideProject = !self.parseStringsOutsideProject;

    // Update menu item
    NSMenuItem *menuItem = (NSMenuItem *)sender;
    menuItem.state = self.parseStringsOutsideProject ? NSOnState : NSOffState;
}


#pragma mark - Notification

- (void)activate
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(workspaceWindowDidBecomeMain:) name:NSWindowDidBecomeMainNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewDidChangeSelection:) name:NSTextViewDidChangeSelectionNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange:) name:NSTextDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(editorDocumentDidSave:) name:@"IDEEditorDocumentDidSaveNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(indexDidChange:) name:@"IDEIndexDidChangeNotification" object:nil];
}

- (void)deactivate
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSWindowDidBecomeMainNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSTextViewDidChangeSelectionNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSTextDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"IDEEditorDocumentDidSaveNotification" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"IDEIndexDidChangeNotification" object:nil];
}

- (void)workspaceWindowDidBecomeMain:(NSNotification *)notification
{
    // Update currentWorkspacePath property
    if([[notification object] isKindOfClass:NSClassFromString(@"IDEWorkspaceWindow")]) {
        NSWindow *workspaceWindow = (NSWindow *)[notification object];
        NSWindowController *workspaceWindowController = (NSWindowController *)workspaceWindow.windowController;

        IDEWorkspace *workspace = (IDEWorkspace *)[workspaceWindowController valueForKey:@"_workspace"];
        DVTFilePath *filePath = workspace.filePath;
        NSString *pathString = filePath.pathString;

        self.currentWorkspacePath = pathString;
    }
}

- (void)editorDocumentDidSave:(NSNotification *)notification
{
    IDEEditorDocument *editorDocument = (IDEEditorDocument *)[notification object];
    DVTFilePath *filePath = editorDocument.filePath;
    NSString *pathString = filePath.pathString;

    // Check whether there are any changes to .strings
    NSMutableSet *localizationFileSet = [self.localizationFileSets objectForKey:self.currentWorkspacePath];

    for(NSString *localizationFilePath in localizationFileSet) {
        if([localizationFilePath isEqualToString:pathString]) {
            [self updateLocalizationsForWorkspace:self.currentWorkspacePath];

            break;
        }
    }
}

- (void)indexDidChange:(NSNotification *)notification
{
    // Update index
    IDEIndex *index = (IDEIndex *)[notification object];
    [self indexNeedsUpdate:index];
}


#pragma mark - Text View

- (void)textDidChange:(NSNotification *)notification
{
    if([[notification object] isKindOfClass:NSClassFromString(@"DVTSourceTextView")]) {
        NSTextView *textView = (NSTextView *)[notification object];
        self.textView = textView;

        [self showPopoverWithTextView:textView];
    }
}

- (void)textViewDidChangeSelection:(NSNotification *)notification
{
    if([[notification object] isKindOfClass:NSClassFromString(@"DVTSourceTextView")]) {
        NSTextView *textView = (NSTextView *)[notification object];
        self.textView = textView;

        [self showPopoverWithTextView:textView];
    }
}

- (void)showPopoverWithTextView:(NSTextView *)textView;
{
    if(!self.enabled) return;

    NSArray *selectedRanges = textView.selectedRanges;

    if(selectedRanges.count > 0) {
        NSRange selectedRange = [[selectedRanges objectAtIndex:0] rangeValue];

        NSString *text = textView.textStorage.string;
        NSRange lineRange = [text lineRangeForRange:selectedRange];
        NSString *lineText = [text substringWithRange:lineRange];

        __block BOOL matched = NO;

        __block NSRange entityRangeInLine;
        __block NSRange keyRangeInLine;

        for( RegEx *regEx in _regexs) {
            // Regular expression
            NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:regEx.expression options:0 error:NULL];

            [regularExpression enumerateMatchesInString:lineText options:0 range:NSMakeRange(0, lineText.length) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
                if(result.numberOfRanges == regEx.numberOfRanges) {
                    matched = YES;

                    entityRangeInLine = [result rangeAtIndex:regEx.entityRangeInLineIndex];
                    keyRangeInLine = [result rangeAtIndex:regEx.keyRangeInLineIndex];
                }

                *stop = YES;
            }];

            if(matched)
                break;
        }

        if(matched) {
            NSRange entityRange = NSMakeRange(lineRange.location + entityRangeInLine.location, entityRangeInLine.length);
            NSRange keyRange = NSMakeRange(lineRange.location + keyRangeInLine.location, keyRangeInLine.length);

            if(entityRange.location <= selectedRange.location && selectedRange.location <= (entityRange.location + entityRange.length)) {
                NSRect selectionRectOnScreen = [textView firstRectForCharacterRange:NSMakeRange(keyRange.location, 1)];
                NSRect selectionRectInWindow = [textView.window convertRectFromScreen:selectionRectOnScreen];
                NSRect selectionRectInView = [textView convertRect:selectionRectInWindow fromView:nil];

                // Show popover
                Localization *localization = [self.localizations objectForKey:self.currentWorkspacePath];
                NSArray *localizationItems = [localization localizationItems];

                PopoverContentView *contentView = (PopoverContentView *)self.popover.contentViewController.view;
                contentView.localizationItems = localizationItems;
                contentView.keyFilter = [lineText substringWithRange:keyRangeInLine];

                [self.popover showRelativeToRect:selectionRectInView ofView:textView preferredEdge:NSMinYEdge];

                return;
            }
        }
    }

    if(self.popover.shown) {
        [self.popover close];
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


#pragma mark - PopoverContentViewDelegate

- (void)popoverContentView:(PopoverContentView *)popoverContentView didSelectLocalizationItem:(LocalizationItem *)localizationItem
{
    NSArray *selectedRanges = self.textView.selectedRanges;

    if(selectedRanges.count > 0) {
        NSRange selectedRange = [[selectedRanges objectAtIndex:0] rangeValue];

        NSString *text = self.textView.textStorage.string;
        NSRange lineRange = [text lineRangeForRange:selectedRange];
        NSString *lineText = [text substringWithRange:lineRange];

        __block BOOL matched = NO;

        __block NSRange entityRangeInLine;
        __block NSRange keyRangeInLine;

        for( RegEx *regEx in _regexs) {
            // Regular expression
            NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:regEx.expression options:0 error:NULL];

            [regularExpression enumerateMatchesInString:lineText options:0 range:NSMakeRange(0, lineText.length) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
                if(result.numberOfRanges == regEx.numberOfRanges) {
                    matched = YES;

                    entityRangeInLine = [result rangeAtIndex:regEx.entityRangeInLineIndex];
                    keyRangeInLine = [result rangeAtIndex:regEx.keyRangeInLineIndex];
                }

                *stop = YES;
            }];

            if(matched)
                break;
        }

        if(matched) {
            // Make a new entity
            NSRange keyRangeInEntity = NSMakeRange(keyRangeInLine.location - entityRangeInLine.location, keyRangeInLine.length);
            NSString *entity = [lineText substringWithRange:entityRangeInLine];
            NSString *newEntity = [entity stringByReplacingCharactersInRange:keyRangeInEntity withString:localizationItem.key];

            // Insert entity
            NSRange entityRange = NSMakeRange(lineRange.location + entityRangeInLine.location, entityRangeInLine.length);
            [self.textView insertText:newEntity replacementRange:entityRange];
        }
    }
}

- (void)popoverContentView:(PopoverContentView *)popoverContentView didChangeLocalizationItem:(LocalizationItem *)localizationItem newLocalizationItem:(LocalizationItem *)newLocalizationItem
{
    NSString* filePath = [ NSString stringWithString: localizationItem.stringsFilename ];
    NSStringEncoding encoding = NSUTF8StringEncoding;

    if(filePath) {
        NSError *error = nil;
        NSString *text = [NSString stringWithContentsOfFile:filePath encoding:encoding error:&error];

        if(error) {
            error = nil;
            encoding = NSUTF16StringEncoding;
            text = [NSString stringWithContentsOfFile:filePath encoding:encoding error:&error];

            if(error) {
                NSLog(@"Error: %@", [error localizedDescription]);
                return;
            }
        }

        [text enumerateLinesUsingBlock:^(NSString *line, BOOL *stop) {
            NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:@"(\"(.*)\"|(.*))\\s*=\\s*\"(.*)\";$" options:0 error:NULL];

            __block BOOL matched = NO;

            __block NSRange entityRangeInLine;
            __block NSRange keyRangeInLine;
            __block NSRange stringValueRangeInLine;

            [regularExpression enumerateMatchesInString:line options:0 range:NSMakeRange(0, line.length) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
                if(result.numberOfRanges == 5) {
                    entityRangeInLine = [result rangeAtIndex:0];
                    
                    keyRangeInLine = [result rangeAtIndex:2];
                    if(keyRangeInLine.location == NSNotFound) keyRangeInLine = [result rangeAtIndex:3];
                    
                    stringValueRangeInLine = [result rangeAtIndex:4];

                    NSString *key = [line substringWithRange:keyRangeInLine];
                    matched = [key isEqualToString:localizationItem.key];
                }

                *stop = YES;
            }];

            if(matched) {
                NSRange lineRange = [text rangeOfString:line];
                NSRange keyRange = NSMakeRange(lineRange.location + keyRangeInLine.location, keyRangeInLine.length);
                NSRange stringValueRange = NSMakeRange(lineRange.location + stringValueRangeInLine.location, stringValueRangeInLine.length);

                NSString *newText = [text stringByReplacingCharactersInRange:keyRange withString:newLocalizationItem.key];
                newText = [newText stringByReplacingCharactersInRange:NSMakeRange(stringValueRange.location - (keyRange.length - newLocalizationItem.key.length), stringValueRange.length) withString:newLocalizationItem.stringValue];

                // Save
                NSError *error = nil;
                [newText writeToFile:filePath atomically:YES encoding:encoding error:&error];

                if(error) {
                    NSLog(@"Error: %@", [error localizedDescription]);
                    return;
                }

                // Update
                [self updateLocalizationsForWorkspace:self.currentWorkspacePath];

                // Update popover
                Localization *localization = [self.localizations objectForKey:self.currentWorkspacePath];
                NSArray *localizationItems = [localization localizationItems];

                if(localizationItems.count > 0) {
                    PopoverContentView *contentView = (PopoverContentView *)self.popover.contentViewController.view;
                    contentView.localizationItems = localizationItems;

                    return;
                }

                *stop = YES;
            }
        }];
    }
}

@end
