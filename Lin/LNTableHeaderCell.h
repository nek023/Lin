//
//  LNTableHeaderCell.h
//  Lin
//
//  Created by Tanaka Katsuma on 2013/09/21.
//  Copyright (c) 2013年 Tanaka Katsuma. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface LNTableHeaderCell : NSTableHeaderCell

@property (nonatomic, weak) NSTableView *tableView;

- (void)setSortAscending:(BOOL)ascending priority:(NSInteger)priority;

@end
