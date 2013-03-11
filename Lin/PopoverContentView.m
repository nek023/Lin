/*
 Copyright (c) 2013 Katsuma Tanaka
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#import "PopoverContentView.h"

#import "LocalizationItem.h"

@implementation PopoverContentView

- (void)setTableView:(NSTableView *)tableView
{
    _tableView = tableView;
    
    // Set double click action
    [_tableView setTarget:self];
    [_tableView setDoubleAction:@selector(doubleClicked:)];
    
    // Register observer
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidEndEditing:) name:NSControlTextDidEndEditingNotification object:nil];
}

- (void)setLocalizationItems:(NSArray *)localizationItems
{
    _localizationItems = [localizationItems copy];
    
    // Update filtered items
    [self updateFilteredItems];
    
    // Reload table view
    [self.tableView reloadData];
}

- (void)setKeyFilter:(NSString *)keyFilter
{
    _keyFilter = [keyFilter copy];
    
    // Update filtered items
    [self updateFilteredItems];
    
    // Reload table view
    [self.tableView reloadData];
}

- (void)dealloc
{
    [_localizationItems release];
    [_filteredLocalizationItems release];
    
    [_keyFilter release];
    
    [super dealloc];
}


#pragma mark - Filtering

- (void)updateFilteredItems
{
    if(self.keyFilter.length > 0) {
        NSMutableArray *filteredLocalizationItems = [NSMutableArray array];
        
        for(LocalizationItem *localizationItem in self.localizationItems) {
            NSRange range = [localizationItem.key rangeOfString:self.keyFilter];
            
            if(range.location == 0) {
                [filteredLocalizationItems addObject:localizationItem];
            }
        }
        
        self.filteredLocalizationItems = [NSArray arrayWithArray:filteredLocalizationItems];
    } else {
        self.filteredLocalizationItems = self.localizationItems;
    }
}


#pragma mark - Actions

- (void)doubleClicked:(id)sender
{
    NSInteger clickedRow = [self.tableView clickedRow];
    
    if(clickedRow >= 0 && [self.delegate respondsToSelector:@selector(popoverContentView:didSelectLocalizationItem:)]) {
        LocalizationItem *localizationItem = [self.filteredLocalizationItems objectAtIndex:clickedRow];
        
        [self.delegate popoverContentView:self didSelectLocalizationItem:localizationItem];
    }
}


#pragma mark - Notification

- (void)textDidEndEditing:(NSNotification *)notification
{
    NSInteger editedRow = [self.tableView editedRow];
    NSInteger editedColumn = [self.tableView editedColumn];
    
    if(editedRow >= 0 && editedColumn >= 0 && [self.delegate respondsToSelector:@selector(popoverContentView:didChangeLocalizationItem:newLocalizationItem:)]) {
        NSTextView *textView = (NSTextView *)[notification.userInfo objectForKey:@"NSFieldEditor"];
        
        LocalizationItem *localizationItem = [self.filteredLocalizationItems objectAtIndex:editedRow];
        
        // Create a new localization item
        LocalizationItem *newLocalizationItem = [LocalizationItem localizationItem];
        newLocalizationItem.language = localizationItem.language;
        newLocalizationItem.key = localizationItem.key;
        newLocalizationItem.stringValue = localizationItem.stringValue;
        
        switch(editedColumn) {
            case 0:
                newLocalizationItem.language = textView.textStorage.string;
                break;
            case 1:
                newLocalizationItem.key = textView.textStorage.string;
                break;
            case 2:
                newLocalizationItem.stringValue = textView.textStorage.string;
                break;
            default:
                break;
        }
        
        [self.delegate popoverContentView:self didChangeLocalizationItem:localizationItem newLocalizationItem:newLocalizationItem];
    }
}


#pragma mark - NSTableViewDataSource

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return self.filteredLocalizationItems.count;
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    LocalizationItem *localizationItem = [self.filteredLocalizationItems objectAtIndex:row];
    
    NSString *identifier = tableColumn.identifier;
    
    if([identifier isEqualToString:@"language"]) {
        return localizationItem.language;
    }
    else if([identifier isEqualToString:@"key"]) {
        return localizationItem.key;
    }
    else if([identifier isEqualToString:@"stringValue"]) {
        return localizationItem.stringValue;
    }
    
    return nil;
}

- (void)tableView:(NSTableView *)tableView sortDescriptorsDidChange:(NSArray *)oldDescriptors
{
    // Sort array
    self.filteredLocalizationItems = [self.filteredLocalizationItems sortedArrayUsingDescriptors:tableView.sortDescriptors];
    
    // Reload table view
    [self.tableView reloadData];
}


#pragma mark - NSTableViewDelegate

@end
