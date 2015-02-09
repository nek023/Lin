//
//  DVTCompletingTextView+Lin.m
//  Lin
//
//  Created by Katsuma Tanaka on 2015/02/05.
//  Copyright (c) 2015年 Katsuma Tanaka. All rights reserved.
//

#import "DVTSourceTextView+Lin.h"
#import "MethodSwizzle.h"
#import "Lin.h"

@implementation DVTSourceTextView (Lin)

+ (void)load
{
    MethodSwizzle(self,
                  @selector(shouldAutoCompleteAtLocation:),
                  @selector(lin_shouldAutoCompleteAtLocation:));
}

- (BOOL)lin_shouldAutoCompleteAtLocation:(unsigned long long)arg1
{
    BOOL shouldAutoComplete = [self lin_shouldAutoCompleteAtLocation:arg1];
    
    if (!shouldAutoComplete) {
        shouldAutoComplete = [[Lin sharedInstance] shouldAutoCompleteInTextView:self location:arg1];
    }
    
    return shouldAutoComplete;
}

@end
