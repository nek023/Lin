//
//  LNLocalization.h
//  Lin
//
//  Created by Tanaka Katsuma on 2013/08/23.
//  Copyright (c) 2013年 Tanaka Katsuma. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LNLocalizationCollection;

@interface LNLocalization : NSObject

@property (nonatomic, copy, readonly) NSString *key;
@property (nonatomic, copy, readonly) NSString *value;

@property (nonatomic, assign, readonly) NSRange entityRange;
@property (nonatomic, assign, readonly) NSRange keyRange;
@property (nonatomic, assign, readonly) NSRange valueRange;

@property (nonatomic, weak, readonly) LNLocalizationCollection *collection;

+ (instancetype)localizationWithKey:(NSString *)key value:(NSString *)value entityRange:(NSRange)entityRange keyRange:(NSRange)keyRange valueRange:(NSRange)valueRange collection:(LNLocalizationCollection *)collection;

- (instancetype)initWithKey:(NSString *)key value:(NSString *)value entityRange:(NSRange)entityRange keyRange:(NSRange)keyRange valueRange:(NSRange)valueRange collection:(LNLocalizationCollection *)collection;

@end
