//
//  LINLocalization.m
//  Lin
//
//  Created by Katsuma Tanaka on 2015/02/05.
//  Copyright (c) 2015年 Katsuma Tanaka. All rights reserved.
//

#import "LINLocalization.h"

@interface LINLocalization ()

@property (nonatomic, copy, readwrite) NSString *key;
@property (nonatomic, copy, readwrite) NSString *value;
@property (nonatomic, copy, readwrite) NSString *languageDesignation;
@property (nonatomic, copy, readwrite) NSString *tableName;

@end

@implementation LINLocalization

- (instancetype)initWithKey:(NSString *)key value:(NSString *)value languageDesignation:(NSString *)languageDesignation tableName:(NSString *)tableName
{
    self = [super init];
    
    if (self) {
        self.key = key;
        self.value = value;
        self.languageDesignation = languageDesignation;
        self.tableName = tableName;
    }
    
    return self;
}

- (BOOL)isEqual:(id)object
{
    if (object == self)
        return YES;
    if (!object || ![[object class] isEqual:[self class]])
        return NO;
    
    return ([[self key] isEqualToString:[object key]]
            && [[self value] isEqualToString:[object value]]
            && [[self languageDesignation] isEqualToString:[object languageDesignation]]
            && [[self tableName] isEqualToString:[object tableName]]);
}

- (NSUInteger)hash
{
    return [self.key hash];
}

- (NSString *)description
{
    return [NSString stringWithFormat:
            @"<%@: %p; key = %@; value = %@; languageDesignation = %@; tableName = %@>",
            NSStringFromClass([self class]),
            self,
            self.key,
            self.value,
            self.languageDesignation,
            self.tableName
            ];
}

@end
