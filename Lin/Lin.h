//
//  Lin.h
//  Lin
//
//  Created by Katsuma Tanaka on 2015/02/05.
//  Copyright (c) 2015年 Katsuma Tanaka. All rights reserved.
//

#import <Foundation/Foundation.h>

@class IDEIndex;
@class DVTCompletingTextView;
@class IDEWorkspace;

@interface Lin : NSObject

+ (void)pluginDidLoad:(NSBundle *)bundle;
+ (instancetype)sharedInstance;

- (void)indexNeedsUpdate:(IDEIndex *)index;

- (BOOL)isAutoCompletableFunction:(NSString *)name;
- (BOOL)shouldAutoCompleteInTextView:(DVTCompletingTextView *)textView;
- (NSArray *)completionItemsForWorkspace:(IDEWorkspace *)workspace;

@end
