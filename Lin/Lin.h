//
//  Lin.h
//  Lin
//
//  Created by Tanaka Katsuma on 2013/08/21.
//  Copyright (c) 2013年 Tanaka Katsuma. All rights reserved.
//

#import <Foundation/Foundation.h>

@class IDEIndex;

@interface Lin : NSObject <NSPopoverDelegate>

+ (void)pluginDidLoad:(NSBundle *)bundle;
+ (instancetype)sharedPlugIn;

- (void)indexNeedsUpdate:(IDEIndex *)index;
- (void)removeLocalizationsForIndex:(IDEIndex *)index;

@end
