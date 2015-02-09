//
//  LNLocalizedStringCollectionOperation.h
//  Lin
//
//  Created by Wenbin Zhang on 3/7/14.
//  Copyright (c) 2014 Tanaka Katsuma. All rights reserved.
//

#import <Foundation/Foundation.h>

@class IDEIndex;

typedef void(^LNLocalizedStringCollectionCompletionBlock)(NSString *workspacePath, NSArray *collections);

@interface LNLocalizedStringCollectionOperation : NSOperation

@property (nonatomic, strong) IDEIndex *index;
@property (nonatomic, copy) LNLocalizedStringCollectionCompletionBlock collectionCompletedBlock;

- (instancetype)initWithIndex:(IDEIndex *)index;
@end
