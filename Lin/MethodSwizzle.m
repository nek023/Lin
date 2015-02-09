//
//  MethodSwizzle.m
//  Lin
//
//  Created by Tanaka Katsuma on 2013/08/24.
//  Copyright (c) 2013年 Tanaka Katsuma. All rights reserved.
//

#import "MethodSwizzle.h"
#import <objc/objc-class.h>

void MethodSwizzle(Class cls, SEL org_sel, SEL alt_sel)
{
    Method org_method = nil, alt_method = nil;
	
    org_method = class_getInstanceMethod(cls, org_sel);
    alt_method = class_getInstanceMethod(cls, alt_sel);
	
    if (org_method != nil && alt_method != nil) {
        method_exchangeImplementations(org_method, alt_method);
	}
}

