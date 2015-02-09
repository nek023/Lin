//
//  DVTCompletingTextView.h
//  Lin
//
//  Created by Katsuma Tanaka on 2015/02/05.
//  Copyright (c) 2015年 Katsuma Tanaka. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class DVTTextCompletionDataSource;

@interface DVTCompletingTextView : NSTextView

@property (readonly) DVTTextCompletionDataSource *completionsDataSource;

- (BOOL)shouldAutoCompleteAtLocation:(unsigned long long)arg1;

@end
