//
//  DVTTextCompletionDataSource.h
//  Lin
//
//  Created by Katsuma Tanaka on 2015/02/05.
//  Copyright (c) 2015年 Katsuma Tanaka. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DVTSourceCodeLanguage;

@interface DVTTextCompletionDataSource : NSObject

@property (retain, nonatomic) DVTSourceCodeLanguage *language;

- (void)generateCompletionsForDocumentLocation:(id)arg1 context:(id)arg2 completionBlock:(id)arg3;

@end
