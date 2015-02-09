//
//  DVTFilePath.h
//  Lin
//
//  Created by Tanaka Katsuma on 2013/08/23.
//  Copyright (c) 2013年 Tanaka Katsuma. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DVTFilePath : NSObject

@property (readonly) NSString *fileName;
@property (readonly) NSURL *fileURL;
@property (readonly) NSArray *pathComponents;
@property (readonly) NSString *pathString;

@end
