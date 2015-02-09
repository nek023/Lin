//
//  IDEIndex.h
//  Lin
//
//  Created by Katsuma Tanaka on 2015/02/05.
//  Copyright (c) 2015年 Katsuma Tanaka. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DVTFilePath;

@interface IDEIndex : NSObject

@property (readonly, nonatomic) DVTFilePath *workspaceFile;
@property (readonly, nonatomic) NSString *workspaceName;

- (id)filesContaining:(id)arg1 anchorStart:(BOOL)arg2 anchorEnd:(BOOL)arg3 subsequence:(BOOL)arg4 ignoreCase:(BOOL)arg5 cancelWhen:(id)arg6;

@end
