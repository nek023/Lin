//
//  LINLocalization.h
//  Lin
//
//  Created by Katsuma Tanaka on 2015/02/05.
//  Copyright (c) 2015年 Katsuma Tanaka. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LINLocalization : NSObject

@property (nonatomic, copy, readonly) NSString *key;
@property (nonatomic, copy, readonly) NSString *value;
@property (nonatomic, copy, readonly) NSString *languageDesignation;
@property (nonatomic, copy, readonly) NSString *tableName;

- (instancetype)initWithKey:(NSString *)key value:(NSString *)value languageDesignation:(NSString *)languageDesignation tableName:(NSString *)tableName;

@end
