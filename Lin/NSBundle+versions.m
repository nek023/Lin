//
//  NSBundle+versions.m
//  Lin
//
//  Created by Tanaka Katsuma on 2013/08/21.
//  Copyright (c) 2013年 Tanaka Katsuma. All rights reserved.
//

#import "NSBundle+versions.h"

@implementation NSBundle (versions)

- (NSString *)shortVersionString
{
    return [self objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
}

- (NSNumber *)buildNumber
{
    return [self objectForInfoDictionaryKey:@"CFBundleVersion"];
}

@end
