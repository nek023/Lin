//
//  IDEWorkspace+Lin.m
//  Lin
//
//  Created by Katsuma Tanaka on 2015/02/05.
//  Copyright (c) 2015年 Katsuma Tanaka. All rights reserved.
//

#import "IDEWorkspace+Lin.h"
#import "MethodSwizzle.h"
#import "Lin.h"

@implementation IDEWorkspace (Lin)

+ (void)load
{
    MethodSwizzle(self,
                  @selector(_updateIndexableFiles:),
                  @selector(lin__updateIndexableFiles:));
}

- (void)lin__updateIndexableFiles:(id)arg1
{
    [self lin__updateIndexableFiles:arg1];
    
    [[Lin sharedInstance] indexNeedsUpdate:self.index];
}

@end
