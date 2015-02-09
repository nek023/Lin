//
//  LNTableView.m
//  Lin
//
//  Created by Tanaka Katsuma on 2013/09/21.
//  Copyright (c) 2013年 Tanaka Katsuma. All rights reserved.
//

#import "LNTableView.h"

// Views
#import "LNTableCornerView.h"
#import "LNTableHeaderCell.h"

@implementation LNTableView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    // Set corner view
    NSView *cornerView = [self cornerView];
    LNTableCornerView *newCornerView = [[LNTableCornerView alloc] initWithFrame:cornerView.frame];
    [self setCornerView:newCornerView];
    
    // Change header cell
    for (NSTableColumn *tableColumn in [self tableColumns]) {
        NSTableHeaderCell *headerCell = [tableColumn headerCell];
        
        LNTableHeaderCell *newHeaderCell = [[LNTableHeaderCell alloc] init];
        newHeaderCell.tableView = self;
        [newHeaderCell setAttributedStringValue:[headerCell attributedStringValue]];
        
        [tableColumn setHeaderCell:newHeaderCell];
    }
}

@end
