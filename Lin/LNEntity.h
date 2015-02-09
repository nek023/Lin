//
//  LNEntity.h
//  Lin
//
//  Created by Tanaka Katsuma on 2013/08/21.
//  Copyright (c) 2013年 Tanaka Katsuma. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, LNEntityType) {
    LNEntityTypeLocalizedString = 0,
    LNEntityTypeLocalizedStringForKey,
    LNEntityTypeLocalizedStringFromTable,
    LNEntityTypeLocalizedStringFromTableInBundle,
    LNEntityTypeLocalizedStringWithDefaultValue
};

NS_INLINE NSString * NSStringFromEntityType(LNEntityType type) {
    NSString *string = nil;
    
    switch (type) {
        case LNEntityTypeLocalizedString:
            string = @"LNEntityTypeLocalizedString";
            break;
        case LNEntityTypeLocalizedStringForKey:
            string = @"LNEntityTypeLocalizedStringForKey";
            break;
        case LNEntityTypeLocalizedStringFromTable:
            string = @"LNEntityTypeLocalizedStringFromTable";
            break;
        case LNEntityTypeLocalizedStringFromTableInBundle:
            string = @"LNEntityTypeLocalizedStringFromTableInBundle";
            break;
        case LNEntityTypeLocalizedStringWithDefaultValue:
            string = @"LNEntityTypeLocalizedStringWithDefaultValue";
            break;
    }
    
    return string;
}

@interface LNEntity : NSObject

@property (nonatomic, assign, readonly) LNEntityType type;
@property (nonatomic, assign, readonly) NSRange entityRange;
@property (nonatomic, assign, readonly) NSRange keyRange;

+ (instancetype)entityWithType:(LNEntityType)type entityRange:(NSRange)entityRange keyRange:(NSRange)keyRange;

- (instancetype)initWithType:(LNEntityType)type entityRange:(NSRange)entityRange keyRange:(NSRange)keyRange;

@end
