//
//  IDEIndexCompletionItem.h
//  Lin
//
//  Created by Katsuma Tanaka on 2015/02/05.
//  Copyright (c) 2015年 Katsuma Tanaka. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DVTSourceCodeSymbolKind;

@interface IDEIndexCompletionItem : NSObject

@property double priority;
@property (readonly) NSString *name;
@property (readonly) BOOL notRecommended;
@property (readonly) DVTSourceCodeSymbolKind *symbolKind;
@property (readonly) NSAttributedString *descriptionText;
@property (readonly, copy) NSString *parentText;
@property (readonly) NSString *completionText;
@property (readonly) NSString *displayType;
@property (readonly) NSString *displayText;

- (id)initWithCompletionResult:(void *)arg1;
- (void)_fillInTheRest;

@end
