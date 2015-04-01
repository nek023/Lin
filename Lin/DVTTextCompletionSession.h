//
//  DVTTextCompletionSession.h
//  Lin
//
//  Created by Katsuma Tanaka on 2015/03/27.
//  Copyright (c) 2015年 Katsuma Tanaka. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DVTTextCompletionSession : NSObject

@property(retain) NSArray *highlyLikelyCompletions;
@property(readonly, nonatomic) NSDictionary *currentCompletionContext;
@property(nonatomic) long long selectedCompletionIndex;
@property(copy) NSString *usefulPrefix;
@property(retain) NSArray *filteredCompletionsAlpha;
@property(retain) NSArray *allCompletions;

@end
