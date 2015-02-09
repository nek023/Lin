//
//  LNAlertAccessoryView.h
//  Lin
//
//  Created by Tanaka Katsuma on 2013/09/22.
//  Copyright (c) 2013年 Tanaka Katsuma. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class LNLocalizationCollection;

@interface LNAlertAccessoryView : NSView <NSTextFieldDelegate>

@property (nonatomic, copy) NSArray *collections;
@property (nonatomic, weak) NSButton *button;

@property (nonatomic, copy, readonly) LNLocalizationCollection *selectedCollection;
@property (nonatomic, copy, readonly) NSString *inputtedKey;
@property (nonatomic, copy, readonly) NSString *inputtedValue;

@end
