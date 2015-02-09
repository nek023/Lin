//
//  LINLocalizationParser.h
//  Lin
//
//  Created by Katsuma Tanaka on 2015/02/06.
//  Copyright (c) 2015年 Katsuma Tanaka. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LINLocalizationParser : NSObject

- (NSArray *)localizationsFromContentsOfFile:(NSString *)filePath;

@end
