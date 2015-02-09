//
//  DVTSourceCodeLanguage.h
//  Lin
//
//  Created by Katsuma Tanaka on 2015/02/05.
//  Copyright (c) 2015年 Katsuma Tanaka. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DVTSourceCodeLanguage : NSObject <NSCopying>

@property (readonly) BOOL isHidden;
@property (readonly) BOOL supportsIndentation;
@property (readonly) Class nativeSourceModelParserClass;
@property (readonly, copy) NSString *documentationAbbreviation;
@property (readonly, copy) NSString *languageName;
@property (readonly, copy) NSString *identifier;

@property (readonly, copy) NSArray *conformedToLanguages;
@property (readonly, copy) NSArray *fileDataTypes;

+ (id)sourceCodeLanguageForFileDataType:(id)arg1;
+ (id)sourceCodeLanguageWithIdentifier:(id)arg1;
+ (id)sourceCodeLanguages;
+ (id)_sourceCodeLanguageForExtension:(id)arg1;

- (BOOL)conformsToLanguage:(id)arg1;

@end
