//
//  MethodSwizzle.h
//  Lin
//
//  Created by Tanaka Katsuma on 2013/08/24.
//  Copyright (c) 2013年 Tanaka Katsuma. All rights reserved.
//

#import <Foundation/Foundation.h>

void MethodSwizzle(Class cls, SEL org_sel, SEL alt_sel);
