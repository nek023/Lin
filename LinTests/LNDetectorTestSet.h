//
//  LNDetectorTestSet.h
//  Lin
//
//  Created by Tanaka Katsuma on 2013/08/21.
//  Copyright (c) 2013年 Tanaka Katsuma. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LNDetectorTestSet : NSObject

@property (nonatomic, copy, readonly) NSString *string;
@property (nonatomic, copy, readonly) NSArray *keys;

- (instancetype)initWithString:(NSString *)string keys:(NSString *)keyValue, ... NS_REQUIRES_NIL_TERMINATION;

@end
