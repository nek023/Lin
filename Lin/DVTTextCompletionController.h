//
//  DVTTextCompletionController.h
//  Lin
//
//  Created by Katsuma Tanaka on 2015/02/05.
//  Copyright (c) 2015年 Katsuma Tanaka. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DVTCompletingTextView;

@interface DVTTextCompletionController : NSObject

@property (readonly) DVTCompletingTextView *textView;

- (BOOL)acceptCurrentCompletion;
- (BOOL)_showCompletionsAtCursorLocationExplicitly:(BOOL)arg1;

@end
