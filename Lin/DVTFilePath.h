//
//  DVTFilePath.h
//  Lin
//
//  Created by Katsuma Tanaka on 2015/02/05.
//  Copyright (c) 2015年 Katsuma Tanaka. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DVTFilePath : NSObject

@property (readonly) NSString *fileName;
@property (readonly) NSURL *fileURL;
@property (readonly) NSArray *pathComponents;
@property (readonly) NSString *pathString;

@end
