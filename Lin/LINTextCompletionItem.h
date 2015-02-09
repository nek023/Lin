//
//  LINTextCompletionItem.h
//  Lin
//
//  Created by Katsuma Tanaka on 2015/02/05.
//  Copyright (c) 2015年 Katsuma Tanaka. All rights reserved.
//

#import "IDEIndexCompletionItem.h"

typedef NS_ENUM(NSUInteger, LINSourceCodeLanguage) {
    LINSourceCodeLanguageObjectiveC,
    LINSourceCodeLanguageSwift
};

@interface LINTextCompletionItem : IDEIndexCompletionItem

@property (nonatomic, copy, readonly) NSArray *localizations;
@property (nonatomic, assign) LINSourceCodeLanguage sourceCodeLanguage;

- (instancetype)initWithLocalizations:(NSArray *)localizations;

@end
