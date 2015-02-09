//
//  LNUserDefaultsManager.h
//  Lin
//
//  Created by Tanaka Katsuma on 2013/09/22.
//  Copyright (c) 2013年 Tanaka Katsuma. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LNUserDefaultsManager : NSObject

@property (nonatomic, assign, getter = isEnabled) BOOL enabled;

+ (instancetype)sharedManager;

@end
