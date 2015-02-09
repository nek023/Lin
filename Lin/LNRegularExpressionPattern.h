//
//  LNRegularExpressionPattern.h
//  Lin
//
//  Created by Tanaka Katsuma on 2013/08/21.
//  Copyright (c) 2013年 Tanaka Katsuma. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LNRegularExpressionPattern : NSObject

@property (nonatomic, copy, readonly) NSString *pattern;
@property (nonatomic, assign, readonly) NSUInteger numberOfRanges;
@property (nonatomic, assign, readonly) NSUInteger entityRangeIndex;
@property (nonatomic, assign, readonly) NSUInteger keyRangeIndex;

+ (instancetype)patternWithString:(NSString *)string numberOfRanges:(NSUInteger)numberOfRanges entityRangeIndex:(NSUInteger)entityRangeIndex keyRangeIndex:(NSUInteger)keyRangeIndex;

- (instancetype)initWithString:(NSString *)string numberOfRanges:(NSUInteger)numberOfRanges entityRangeIndex:(NSUInteger)entityRangeIndex keyRangeIndex:(NSUInteger)keyRangeIndex;

@end
