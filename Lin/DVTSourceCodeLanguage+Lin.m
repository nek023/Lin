//
//  DVTSourceCodeLanguage+Lin.m
//  Lin
//
//  Created by Katsuma Tanaka on 2015/02/08.
//  Copyright (c) 2015年 Katsuma Tanaka. All rights reserved.
//

#import "DVTSourceCodeLanguage+Lin.h"

@implementation DVTSourceCodeLanguage (Lin)

- (BOOL)lin_isObjectiveC
{
    return [self.languageName isEqualToString:@"Objective-C"];
}

- (BOOL)lin_isSwift
{
    return [self.languageName isEqualToString:@"Swift"];
}

@end
