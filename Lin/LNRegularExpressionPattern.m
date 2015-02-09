//
//  LNRegularExpressionPattern.m
//  Lin
//
//  Created by Tanaka Katsuma on 2013/08/21.
//  Copyright (c) 2013年 Tanaka Katsuma. All rights reserved.
//

#import "LNRegularExpressionPattern.h"

@interface LNRegularExpressionPattern ()

@property (nonatomic, copy, readwrite) NSString *pattern;
@property (nonatomic, assign, readwrite) NSUInteger numberOfRanges;
@property (nonatomic, assign, readwrite) NSUInteger entityRangeIndex;
@property (nonatomic, assign, readwrite) NSUInteger keyRangeIndex;

@end

@implementation LNRegularExpressionPattern

+ (instancetype)patternWithString:(NSString *)string numberOfRanges:(NSUInteger)numberOfRanges entityRangeIndex:(NSUInteger)entityRangeIndex keyRangeIndex:(NSUInteger)keyRangeIndex
{
    return [[self alloc] initWithString:string
                         numberOfRanges:numberOfRanges
                       entityRangeIndex:entityRangeIndex
                          keyRangeIndex:keyRangeIndex];
}

- (instancetype)initWithString:(NSString *)string numberOfRanges:(NSUInteger)numberOfRanges entityRangeIndex:(NSUInteger)entityRangeIndex keyRangeIndex:(NSUInteger)keyRangeIndex
{
    self = [super init];
    
    if (self) {
        self.pattern = string;
        self.numberOfRanges = numberOfRanges;
        self.entityRangeIndex = entityRangeIndex;
        self.keyRangeIndex = keyRangeIndex;
    }
    
    return self;
}

@end
