//
//  LNPopoverContentView.h
//  Lin
//
//  Created by Tanaka Katsuma on 2013/09/06.
//  Copyright (c) 2013年 Tanaka Katsuma. All rights reserved.
//

#import <Cocoa/Cocoa.h>

extern NSString * const LNPopoverContentViewLocalizationKey;

extern NSString * const LNPopoverContentViewLocalizationDidSelectNotification;
extern NSString * const LNPopoverContentViewAlertDidDismissNotification;
extern NSString * const LNPopoverContentViewDetachButtonDidClickNotification;

@interface LNPopoverContentView : NSView <NSTableViewDataSource, NSTableViewDelegate>

@property (nonatomic, weak, readonly) NSTableView *tableView;
@property (nonatomic, weak, readonly) NSButton *detachButton;
@property (nonatomic, copy) NSArray *collections;
@property (nonatomic, copy) NSString *searchString;

@end
