//
//  IDEEditorDocument.h
//  Lin
//
//  Created by Tanaka Katsuma on 2013/08/24.
//  Copyright (c) 2013年 Tanaka Katsuma. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DVTFilePath;

@interface IDEEditorDocument : NSDocument

@property (retain) DVTFilePath *filePath;

@end
