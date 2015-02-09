//
//  IDEWorkspace.h
//  Lin
//
//  Created by Tanaka Katsuma on 2013/08/21.
//  Copyright (c) 2013年 Tanaka Katsuma. All rights reserved.
//

#import <Foundation/Foundation.h>

@class IDEIndex;
@class DVTFilePath;

@interface IDEWorkspace : NSObject

@property (retain) IDEIndex *index;
@property (readonly) DVTFilePath *representingFilePath;

- (void)_updateIndexableFiles:(id)arg1;

@end
