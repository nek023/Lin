//
//  LNDetectorTestSet.m
//  Lin
//
//  Created by Tanaka Katsuma on 2013/08/21.
//  Copyright (c) 2013年 Tanaka Katsuma. All rights reserved.
//

#import "LNDetectorTestSet.h"

@interface LNDetectorTestSet ()

@property (nonatomic, copy, readwrite) NSString *string;
@property (nonatomic, copy, readwrite) NSArray *keys;

@end

@implementation LNDetectorTestSet

- (instancetype)initWithString:(NSString *)string keys:(NSString *)keyValue, ...
{
    self = [super init];
    
    if (self) {
        self.string = string;
        
        va_list arguments;
        va_start(arguments, keyValue);
        
        NSString *key = keyValue;
        NSMutableArray *keys = [NSMutableArray array];
        
        while (key) {
            [keys addObject:key];
            
            key = va_arg(arguments, typeof(NSString *));
        }
        
        self.keys = [keys copy];
        
        va_end(arguments);
    }
    
    return self;
}

@end
