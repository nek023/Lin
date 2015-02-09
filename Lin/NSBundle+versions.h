//
//  NSBundle+versions.h
//  Lin
//
//  Created by Tanaka Katsuma on 2013/08/21.
//  Copyright (c) 2013年 Tanaka Katsuma. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSBundle (versions)

- (NSString *)shortVersionString;
- (NSNumber *)buildNumber;

@end
