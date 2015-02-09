//
//  LNLocalizationTests.m
//  Lin
//
//  Created by Tanaka Katsuma on 2013/08/24.
//  Copyright (c) 2013年 Tanaka Katsuma. All rights reserved.
//

#import <XCTest/XCTest.h>

// Models
#import "LNLocalizationCollection.h"
#import "LNLocalization.h"

@interface LNLocalizationTests : XCTestCase

@end

@implementation LNLocalizationTests

- (NSBundle *)testBundle
{
    for (NSBundle *bundle in [NSBundle allBundles]) {
        if ([[bundle bundleIdentifier] isEqualToString:@"jp.questbeat.LinTests"]) {
            return bundle;
        }
    }
    
    return nil;
}

- (void)testParsingPatterns
{
    NSString *filePath = [[self testBundle] pathForResource:@"Localizable" ofType:@"strings"];
    LNLocalizationCollection *collection = [LNLocalizationCollection localizationCollectionWithContentsOfFile:filePath];
    
    struct LNLocalizationTestSet {
        __unsafe_unretained NSString *key;
        __unsafe_unretained NSString *value;
    } testSets[] = {
        {@"key0",   @"value0"},
        {@"key1",   @"value1"},
        {@"key2",   @"value2"},
        {@"key3",   @"value3"},
        {@"key4",   @"value4"},
        {@"key5",   @"value5"},
        {@"key6",   @"value6"},
        {@"key7",   @"value7"},
        {@"key8",   @"value8"},
        {@"key 9",  @"value9"},
        {@"key 10", @"value10"},
        {@"key 11", @"value11"},
        {@"key 12", @"value12"},
        {@"key 13", @"value13"},
        {@"key 14", @"value14"},
        {@"key 15", @"value15"},
        {@"key 16", @"value16"},
        {@"key.17", @"value17"},
        {@"key.18", @"value18"},
        {@"key.19", @"value19"},
        {@"key.20", @"value20"},
        {@"key.21", @"value21"}
    };
    
    NSInteger numberOfTestSets = sizeof(testSets) / sizeof(struct LNLocalizationTestSet);
    
    for (NSInteger i = 0; i < numberOfTestSets; i++) {
        LNLocalization *localization = [LNLocalization localizationWithKey:testSets[i].key
                                                                     value:testSets[i].value
                                                               entityRange:NSMakeRange(0, 0)
                                                                  keyRange:NSMakeRange(0, 0)
                                                                valueRange:NSMakeRange(0, 0)
                                                                collection:nil];
        
        XCTAssertTrue([collection.localizations containsObject:localization]);
    }
}

@end
