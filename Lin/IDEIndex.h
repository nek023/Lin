//
//  IDEIndex.h
//  Lin
//
//  Created by Tanaka Katsuma on 2013/08/23.
//  Copyright (c) 2013年 Tanaka Katsuma. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DVTFilePath;

@interface IDEIndex : NSObject

@property (readonly, nonatomic) DVTFilePath *workspaceFile;
@property (readonly, nonatomic) NSString *workspaceName;

- (void)close;
- (id)filesContaining:(id)arg1 anchorStart:(BOOL)arg2 anchorEnd:(BOOL)arg3 subsequence:(BOOL)arg4 ignoreCase:(BOOL)arg5 cancelWhen:(id)arg6;

@end
