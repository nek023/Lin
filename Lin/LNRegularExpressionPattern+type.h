//
//  LNRegularExpressionPattern+type.h
//  Lin
//
//  Created by Tanaka Katsuma on 2013/08/21.
//  Copyright (c) 2013年 Tanaka Katsuma. All rights reserved.
//

#import "LNRegularExpressionPattern.h"

// Models
#import "LNEntity.h"

@interface LNRegularExpressionPattern (type)

@property (nonatomic, assign, readonly) LNEntityType type;

+ (instancetype)patternWithType:(LNEntityType)type;

@end
