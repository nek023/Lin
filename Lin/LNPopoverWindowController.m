//
//  LNPopoverWindowController.m
//  Lin
//
//  Created by Tanaka Katsuma on 2013/09/20.
//  Copyright (c) 2013年 Tanaka Katsuma. All rights reserved.
//

#import "LNPopoverWindowController.h"

// Views
#import "LNPopoverWindow.h"

NSString * const LNPopoverWindowControllerWindowWillCloseNotification = @"LNPopoverWindowControllerWindowWillCloseNotification";

@implementation LNPopoverWindowController

- (instancetype)initWithContentViewController:(NSViewController *)contentViewController
{
    LNPopoverWindow *popoverWindow = [LNPopoverWindow popoverWindow];
    popoverWindow.delegate = self;
    
    self = [super initWithWindow:popoverWindow];
    
    if (self) {
        self.contentViewController = contentViewController;
    }
    
    return self;
}


#pragma mark - Accessors

- (void)setContentViewController:(NSViewController *)contentViewController
{
    // Remove previous content view
    if (self.contentViewController) {
        [self.contentViewController.view removeFromSuperview];
    }
    
    _contentViewController = contentViewController;
    
    // Set content view of the window
    self.contentViewController.view.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
    [self.window.contentView setFrame:self.contentViewController.view.bounds];
    [self.window.contentView addSubview:self.contentViewController.view];
}


#pragma mark - NSWindowDelegate

- (void)windowWillClose:(NSNotification *)notification
{
    // Post notification
    [[NSNotificationCenter defaultCenter] postNotificationName:LNPopoverWindowControllerWindowWillCloseNotification
                                                        object:self
                                                      userInfo:nil];
}

@end
