//
//  IDEWorkspace.h
//  Lin
//
//  Created by Katsuma Tanaka on 2015/02/05.
//  Copyright (c) 2015年 Katsuma Tanaka. All rights reserved.
//

#import <Foundation/Foundation.h>

@class IDEIndex;
@class DVTFilePath;

@interface IDEWorkspace : NSObject

@property (retain) IDEIndex *index;
@property (readonly) DVTFilePath *representingFilePath;

- (void)_updateIndexableFiles:(id)arg1;

@end
