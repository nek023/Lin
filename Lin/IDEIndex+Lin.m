//
//  IDEIndex+Lin.m
//  Lin
//
//  Created by Tanaka Katsuma on 2013/08/24.
//  Copyright (c) 2013年 Tanaka Katsuma. All rights reserved.
//

#import "IDEIndex+Lin.h"

#import "MethodSwizzle.h"
#import "Lin.h"

@implementation IDEIndex (Lin)

+ (void)load
{
    MethodSwizzle(self, @selector(close), @selector(jp_questbeat_lin_close));
}

- (void)jp_questbeat_lin_close
{
    [[Lin sharedPlugIn] removeLocalizationsForIndex:self];
    
    [self jp_questbeat_lin_close];
}

@end
