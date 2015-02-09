//
//  DVTTextStorage.h
//  Lin
//
//  Created by Katsuma Tanaka on 2015/02/05.
//  Copyright (c) 2015年 Katsuma Tanaka. All rights reserved.
//

#import <AppKit/AppKit.h>

@class DVTSourceLanguageService;
@class DVTSourceModel;
@class DVTSourceCodeLanguage;

@interface DVTTextStorage : NSTextStorage

@property (readonly) DVTSourceModel *sourceModelWithoutParsing;
@property (readonly) DVTSourceModel *sourceModel;
@property (readonly) DVTSourceLanguageService *sourceModelService;
@property (readonly, nonatomic) NSDictionary *sourceLanguageServiceContext;
@property (readonly) DVTSourceLanguageService *languageService;
@property (copy) DVTSourceCodeLanguage *language;

@end
