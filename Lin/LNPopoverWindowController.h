//
//  LNPopoverWindowController.h
//  Lin
//
//  Created by Tanaka Katsuma on 2013/09/20.
//  Copyright (c) 2013年 Tanaka Katsuma. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class LNPopoverContentViewController;

extern NSString * const LNPopoverWindowControllerWindowWillCloseNotification;

@interface LNPopoverWindowController : NSWindowController <NSWindowDelegate, NSToolbarDelegate, NSTextFieldDelegate>

@property (nonatomic, strong) NSViewController *contentViewController;

- (instancetype)initWithContentViewController:(NSViewController *)contentViewController;

@end
