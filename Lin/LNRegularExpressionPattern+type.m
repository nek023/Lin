//
//  LNRegularExpressionPattern+type.m
//  Lin
//
//  Created by Tanaka Katsuma on 2013/08/21.
//  Copyright (c) 2013年 Tanaka Katsuma. All rights reserved.
//

#import "LNRegularExpressionPattern+type.h"
#import <objc/runtime.h>

static NSString * const LNRegularExpressionPatternTypePropertyKey = @"type";

@implementation LNRegularExpressionPattern (type)

- (LNEntityType)type
{
    return [objc_getAssociatedObject(self, (__bridge const void *)(LNRegularExpressionPatternTypePropertyKey)) unsignedIntegerValue];
}

- (void)setType:(LNEntityType)type
{
    objc_setAssociatedObject(self, (__bridge const void *)(LNRegularExpressionPatternTypePropertyKey), @(type), OBJC_ASSOCIATION_ASSIGN);
}

+ (instancetype)patternWithType:(LNEntityType)type
{
    LNRegularExpressionPattern *regularExpression = nil;
    
    NSString *pettern = nil;
    NSUInteger numberOfRanges = 0;
    NSUInteger entityRangeIndex = 0;
    NSUInteger keyRangeIndex = 1;
    
    switch (type) {
        case LNEntityTypeLocalizedString:
        {
            pettern = @"NSLocalizedString\\s*\\(\\s*@\"(.*?)\"\\s*,\\s*(.*?)\\s*\\)";
            numberOfRanges = 3;
        }
            break;
        case LNEntityTypeLocalizedStringForKey:
        {
            pettern = @"localizedStringForKey:\\s*@\"(.*?)\"\\s*value:\\s*(.*?)\\s*table:\\s*(.*?)";
            numberOfRanges = 4;
        }
            break;
        case LNEntityTypeLocalizedStringFromTable:
        {
            pettern = @"NSLocalizedStringFromTable\\s*\\(\\s*@\"(.*?)\"\\s*,\\s*(.*?)\\s*,\\s*(.*?)\\s*\\)";
            numberOfRanges = 4;
        }
            break;
        case LNEntityTypeLocalizedStringFromTableInBundle:
        {
            pettern = @"NSLocalizedStringFromTableInBundle\\s*\\(\\s*@\"(.*?)\"\\s*,\\s*(.*?)\\s*,\\s*(.*?)\\s*,\\s*(.*?)\\s*\\)";
            numberOfRanges = 5;
        }
            break;
        case LNEntityTypeLocalizedStringWithDefaultValue:
        {
            pettern = @"NSLocalizedStringWithDefaultValue\\s*\\(\\s*@\"(.*?)\"\\s*,\\s*(.*?)\\s*,\\s*(.*?)\\s*,\\s*(.*?)\\s*,\\s*(.*?)\\s*\\)";
            numberOfRanges = 6;
        }
            break;
    }
    
    if (pettern) {
        regularExpression = [LNRegularExpressionPattern patternWithString:pettern
                                                           numberOfRanges:numberOfRanges
                                                         entityRangeIndex:entityRangeIndex
                                                            keyRangeIndex:keyRangeIndex];
        regularExpression.type = type;
    }
    
    return regularExpression;
}

@end
