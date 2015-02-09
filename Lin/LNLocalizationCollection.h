//
//  LNLocalizationCollection.h
//  Lin
//
//  Created by Tanaka Katsuma on 2013/08/23.
//  Copyright (c) 2013年 Tanaka Katsuma. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LNLocalization;

@interface LNLocalizationCollection : NSObject

@property (nonatomic, copy, readonly) NSString *filePath;
@property (nonatomic, copy, readonly) NSString *languageDesignation;

@property (nonatomic, strong, readonly) NSMutableSet *localizations;

+ (instancetype)localizationCollectionWithContentsOfFile:(NSString *)filePath;

- (instancetype)initWithContentsOfFile:(NSString *)filePath;

- (NSString *)fileName;

- (void)reloadLocalizations;
- (void)addLocalization:(LNLocalization *)localization;
- (void)deleteLocalization:(LNLocalization *)localization;
- (void)replaceLocalization:(LNLocalization *)localization withLocalization:(LNLocalization *)newLocalization;

@end
