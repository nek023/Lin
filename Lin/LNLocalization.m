//
//  LNLocalization.m
//  Lin
//
//  Created by Tanaka Katsuma on 2013/08/23.
//  Copyright (c) 2013年 Tanaka Katsuma. All rights reserved.
//

#import "LNLocalization.h"

@interface LNLocalization ()

@property (nonatomic, copy, readwrite) NSString *key;
@property (nonatomic, copy, readwrite) NSString *value;

@property (nonatomic, assign, readwrite) NSRange entityRange;
@property (nonatomic, assign, readwrite) NSRange keyRange;
@property (nonatomic, assign, readwrite) NSRange valueRange;

@property (nonatomic, weak, readwrite) LNLocalizationCollection *collection;

@end

@implementation LNLocalization

+ (instancetype)localizationWithKey:(NSString *)key value:(NSString *)value entityRange:(NSRange)entityRange keyRange:(NSRange)keyRange valueRange:(NSRange)valueRange collection:(LNLocalizationCollection *)collection
{
    return [[self alloc] initWithKey:key value:value entityRange:(NSRange)entityRange keyRange:keyRange valueRange:valueRange collection:collection];
}

- (instancetype)initWithKey:(NSString *)key value:(NSString *)value entityRange:(NSRange)entityRange keyRange:(NSRange)keyRange valueRange:(NSRange)valueRange collection:(LNLocalizationCollection *)collection
{
    self = [super init];
    
    if (self) {
        self.key = key;
        self.value = value;
        
        self.entityRange = entityRange;
        self.keyRange = keyRange;
        self.valueRange = valueRange;
        
        self.collection = collection;
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
            @"<%@: %p; key = %@; value = %@; entityRange = %@; keyRange = %@; valueRange = %@; collection = %p>",
            NSStringFromClass([self class]),
            self,
            self.key,
            self.value,
            NSStringFromRange(self.entityRange),
            NSStringFromRange(self.keyRange),
            NSStringFromRange(self.valueRange),
            self.collection
            ];
}

@end
