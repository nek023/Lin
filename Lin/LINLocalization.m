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

@end

@implementation LINLocalization

- (instancetype)initWithKey:(NSString *)key value:(NSString *)value languageDesignation:(NSString *)languageDesignation
{
    self = [super init];
    
    if (self) {
        self.key = key;
        self.value = value;
        
        self.languageDesignation = languageDesignation;
    }
    
    return self;
}

- (BOOL)isEqual:(id)object
{
    if (object == self)
        return YES;
    if (!object || ![[object class] isEqual:[self class]])
        return NO;
    if (![[self key] isEqualToString:[object key]])
        return NO;
    
    return YES;
}

- (NSUInteger)hash
{
    return [self.key hash];
}

- (NSString *)description
{
    return [NSString stringWithFormat:
            @"<%@: %p; key = %@; value = %@; languageDesignation = %@>",
            NSStringFromClass([self class]),
            self,
            self.key,
            self.value,
            self.languageDesignation
            ];
}

@end
