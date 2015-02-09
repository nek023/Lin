//
//  MethodSwizzle.m
//  Lin
//
//  Created by Katsuma Tanaka on 2015/02/05.
//  Copyright (c) 2015年 Katsuma Tanaka. All rights reserved.
//

#import "MethodSwizzle.h"

void MethodSwizzle(Class cls, SEL org_sel, SEL alt_sel)
{
    Method org_method = nil, alt_method = nil;
    
    org_method = class_getInstanceMethod(cls, org_sel);
    alt_method = class_getInstanceMethod(cls, alt_sel);
    
    if (org_method != nil && alt_method != nil) {
        method_exchangeImplementations(org_method, alt_method);
    }
}
