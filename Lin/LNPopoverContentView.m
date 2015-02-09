//
//  LNPopoverContentView.m
//  Lin
//
//  Created by Tanaka Katsuma on 2013/09/06.
//  Copyright (c) 2013年 Tanaka Katsuma. All rights reserved.
//

#import "LNPopoverContentView.h"

// Categories
#import "NSTableView+editedColumnIdentifier.h"

// Models
#import "LNLocalizationCollection.h"
#import "LNLocalization.h"

// Views
#import "LNTableHeaderCell.h"
#import "LNAlertAccessoryView.h"

NSString * const LNPopoverContentViewLocalizationKey = @"LNPopoverContentViewLocalizationKey";

NSString * const LNPopoverContentViewLocalizationDidSelectNotification = @"LNPopoverContentViewRowDidDoubleClickNotification";
NSString * const LNPopoverContentViewAlertDidDismissNotification = @"LNPopoverContentViewAlertDidDismissNotification";
NSString * const LNPopoverContentViewDetachButtonDidClickNotification = @"LNPopoverContentViewDetachButtonDidClickNotification";

@interface LNPopoverContentView ()

@property (nonatomic, weak, readwrite) IBOutlet NSTableView *tableView;
@property (nonatomic, weak, readwrite) IBOutlet NSButton *detachButton;

@property (nonatomic, strong) NSMutableArray *localizations;
@property (nonatomic, strong) NSMutableArray *sortedLocalizations;

- (IBAction)addLocalization:(id)sender;
- (IBAction)deleteLocalization:(id)sender;
- (IBAction)detachPopover:(id)sender;

@end

@implementation LNPopoverContentView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    // Set default sort order
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"key"
                                                                     ascending:YES
                                                                      selector:@selector(compare:)];
    [self.tableView setSortDescriptors:@[sortDescriptor]];
    
    // Register to notification center
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textDidEndEditing:)
                                                 name:NSControlTextDidEndEditingNotification
                                               object:nil];
}

- (void)dealloc
{
    // Remove from notification center
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:NSControlTextDidEndEditingNotification
                                                  object:nil];
}


#pragma mark - Accessors

- (void)setTableView:(NSTableView *)tableView
{
    _tableView = tableView;
    
    // Set double click action
    [_tableView setTarget:self];
    [_tableView setDoubleAction:@selector(tableViewDidDoubleClick:)];
}

- (void)setCollections:(NSArray *)collections
{
    _collections = collections;
    
    // Update
    [self configureView];
}

- (void)setSearchString:(NSString *)searchString
{
    _searchString = searchString;
    
    // Update
    [self configureView];
}


#pragma mark - Notifications

- (void)textDidEndEditing:(NSNotification *)notification
{
    NSInteger editedRow = [self.tableView editedRow];
    NSInteger editedColumn = [self.tableView editedColumn];
    
    if (editedRow >= 0 && editedColumn >= 0) {
        NSTextView *textView = (NSTextView *)[notification.userInfo objectForKey:@"NSFieldEditor"];
        
        // Create a new localization
        LNLocalization *localization = [self.sortedLocalizations objectAtIndex:editedRow];
        
        NSString *key = localization.key;
        NSString *value = localization.value;
        
        NSString *columnIdentifier = [self.tableView editedColumnIdentifier];
        
        if ([columnIdentifier isEqualToString:@"key"]) {
            key = textView.textStorage.string;
        } else if ([columnIdentifier isEqualToString:@"value"]) {
            value = textView.textStorage.string;
        }
        
        LNLocalization *newLocalization = [LNLocalization localizationWithKey:key
                                                                        value:value
                                                                  entityRange:localization.entityRange
                                                                     keyRange:localization.keyRange
                                                                   valueRange:localization.valueRange
                                                                   collection:localization.collection];
        
        // Replace in file
        [localization.collection replaceLocalization:localization withLocalization:newLocalization];
        
        // Update
        [self configureView];
    }
}


#pragma mark - Actions

- (void)tableViewDidDoubleClick:(id)sender
{
    NSInteger clickedRow = [self.tableView clickedRow];
    
    if (clickedRow >= 0) {
        LNLocalization *localization = [self.sortedLocalizations objectAtIndex:clickedRow];
        
        // Post notification
        [[NSNotificationCenter defaultCenter] postNotificationName:LNPopoverContentViewLocalizationDidSelectNotification
                                                            object:self
                                                          userInfo:@{LNPopoverContentViewLocalizationKey: localization}];
    }
}

- (IBAction)addLocalization:(id)sender
{
    // Create alert
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSViewController *viewController = [[NSViewController alloc] initWithNibName:@"LNAlertAccessoryView" bundle:bundle];
    LNAlertAccessoryView *accessoryView = (LNAlertAccessoryView *)viewController.view;
    accessoryView.collections = self.collections;
    
    NSAlert *alert = [NSAlert alertWithMessageText:@"Lin"
                                     defaultButton:@"OK"
                                   alternateButton:@"Cancel"
                                       otherButton:nil
                         informativeTextWithFormat:@"Input a key/value for a new localization."];
    alert.accessoryView = accessoryView;
    
    NSButton *button = [[alert buttons] objectAtIndex:0];
    accessoryView.button = button;
    
    // Set icon
    NSString *filePath = [bundle pathForResource:@"icon120" ofType:@"tiff"];
    NSImage *icon = [[NSImage alloc] initWithContentsOfFile:filePath];
    [alert setIcon:icon];
    
    // Show alert
    switch ([alert runModal]) {
        case NSAlertDefaultReturn:
        {
            // Create a new localization
            LNAlertAccessoryView *accessoryView = (LNAlertAccessoryView *)alert.accessoryView;
            
            LNLocalizationCollection *collection = accessoryView.selectedCollection;
            NSString *key = accessoryView.inputtedKey;
            NSString *value = accessoryView.inputtedValue;
            
            LNLocalization *localization = [LNLocalization localizationWithKey:key
                                                                         value:value
                                                                   entityRange:NSMakeRange(NSNotFound, 0)
                                                                      keyRange:NSMakeRange(NSNotFound, 0)
                                                                    valueRange:NSMakeRange(NSNotFound, 0)
                                                                    collection:collection];
            
            // Add localization to file
            [collection addLocalization:localization];
            
            // Update
            [self configureView];
        }
            
        default:
        {
            // Post notification
            [[NSNotificationCenter defaultCenter] postNotificationName:LNPopoverContentViewAlertDidDismissNotification
                                                                object:self
                                                              userInfo:nil];
        }
            break;
    }
}

- (IBAction)deleteLocalization:(id)sender
{
    NSInteger selectedRow = [self.tableView selectedRow];
    
    if (selectedRow >= 0) {
        [self.tableView beginUpdates];
        
        // Delete localization from array
        LNLocalization *localization = [self.sortedLocalizations objectAtIndex:selectedRow];
        NSInteger index = [self.localizations indexOfObject:localization];
        [self.localizations removeObjectAtIndex:index];
        
        // Filter localizations
        [self filterLocalizations];
        
        // Delete localization from file
        LNLocalizationCollection *collection = localization.collection;
        [collection deleteLocalization:localization];
        
        // Delete localization from table view
        [self.tableView removeRowsAtIndexes:[NSIndexSet indexSetWithIndex:selectedRow]
                              withAnimation:NSTableViewAnimationEffectFade];
        
        [self.tableView endUpdates];
    }
}

- (IBAction)detachPopover:(id)sender
{
    // Post notification
    [[NSNotificationCenter defaultCenter] postNotificationName:LNPopoverContentViewDetachButtonDidClickNotification
                                                        object:self
                                                      userInfo:nil];
}


#pragma mark - Updating and Drawing the View

- (void)reloadLocalizations
{
    NSMutableArray *localizations = [NSMutableArray array];
    
    for (LNLocalizationCollection *collection in self.collections) {
        [localizations addObjectsFromArray:[collection.localizations allObjects]];
    }
    
    self.localizations = localizations;
}

- (void)filterLocalizations
{
    // Filter localizations
    NSArray *filteredLocalizations = self.localizations;
    
    if (self.searchString.length > 0) {
        filteredLocalizations = [filteredLocalizations filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"key contains[c] %@", self.searchString]];
    }
    
    // Sort localizations
    self.sortedLocalizations = [[filteredLocalizations sortedArrayUsingDescriptors:self.tableView.sortDescriptors] mutableCopy];
}

- (void)configureView
{
    // Reload localizations
    [self reloadLocalizations];
    
    // Filter localizations
    [self filterLocalizations];
    
    // Update table view
    [self.tableView reloadData];
}


#pragma mark - NSTableViewDataSource

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return self.sortedLocalizations.count;
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    LNLocalization *localization = [self.sortedLocalizations objectAtIndex:row];
    NSString *identifier = tableColumn.identifier;
    
    if([identifier isEqualToString:@"table"]) {
        return [localization.collection.filePath lastPathComponent];
    }
    else if ([identifier isEqualToString:@"language"]) {
        return localization.collection.languageDesignation;
    }
    else if ([identifier isEqualToString:@"key"]) {
        return localization.key;
    }
    else if ([identifier isEqualToString:@"value"]) {
        return localization.value;
    }
    
    return nil;
}

- (void)tableView:(NSTableView *)tableView sortDescriptorsDidChange:(NSArray *)oldDescriptors
{
    // Update
    [self configureView];
}


#pragma mark - NSTableViewDelegate

- (void)tableView:(NSTableView *)tableView didClickTableColumn:(NSTableColumn *)clickedTableColumn
{
    for (NSTableColumn *tableColumn in [tableView tableColumns]) {
        LNTableHeaderCell *headerCell = (LNTableHeaderCell*)[tableColumn headerCell];
        
        if (tableColumn == clickedTableColumn) {
            [headerCell setSortAscending:[[[tableView sortDescriptors] objectAtIndex:0] ascending]
                                priority:0];
        } else {
            [headerCell setSortAscending:NO
                                priority:1];
        }
    }
}

@end
