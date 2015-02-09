//
//  LNDetector.m
//  Lin
//
//  Created by Tanaka Katsuma on 2013/08/21.
//  Copyright (c) 2013年 Tanaka Katsuma. All rights reserved.
//

#import "LNDetector.h"

// Models
#import "LNEntity.h"
#import "LNRegularExpressionPattern.h"
#import "LNRegularExpressionPattern+type.h"

@interface LNDetector ()

@property (nonatomic, copy, readwrite) NSArray *regularExpressionPatterns;

@end

@implementation LNDetector

+ (instancetype)detector
{
    return [[self alloc] init];
}

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        self.regularExpressionPatterns = @[
                                           [LNRegularExpressionPattern patternWithType:LNEntityTypeLocalizedString],
                                           [LNRegularExpressionPattern patternWithType:LNEntityTypeLocalizedStringForKey],
                                           [LNRegularExpressionPattern patternWithType:LNEntityTypeLocalizedStringFromTable],
                                           [LNRegularExpressionPattern patternWithType:LNEntityTypeLocalizedStringFromTableInBundle],
                                           [LNRegularExpressionPattern patternWithType:LNEntityTypeLocalizedStringWithDefaultValue]
                                           ];
    }
    
    return self;
}


#pragma mark - Finding Entities

- (NSArray *)entitiesInString:(NSString *)string
{
    NSMutableArray *entities = [NSMutableArray array];
    
    for (LNRegularExpressionPattern *regularExpressionPattern in self.regularExpressionPatterns) {
        NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:regularExpressionPattern.pattern options:0 error:NULL];
        
        __block NSRange entityRange;
        __block NSRange keyRange;
        
        [regularExpression enumerateMatchesInString:string
                                            options:0
                                              range:NSMakeRange(0, string.length)
                                         usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
                                             if (result.numberOfRanges == regularExpressionPattern.numberOfRanges) {
                                                 entityRange = [result rangeAtIndex:regularExpressionPattern.entityRangeIndex];
                                                 keyRange = [result rangeAtIndex:regularExpressionPattern.keyRangeIndex];
                                                 
                                                 LNEntity *entity = [LNEntity entityWithType:regularExpressionPattern.type
                                                                                 entityRange:entityRange
                                                                                    keyRange:keyRange];
                                                 
                                                 [entities addObject:entity];
                                             }
                                         }];
    }
    
    return [entities copy];
}

@end
