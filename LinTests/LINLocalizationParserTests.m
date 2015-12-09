//
//  LINLocalizationTests.m
//  Lin
//
//  Created by Katsuma Tanaka on 2015/02/05.
//  Copyright (c) 2015年 Katsuma Tanaka. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <XCTest/XCTest.h>
#import "LINLocalizationParser.h"
#import "LINLocalization.h"

@interface LINLocalizationParserTests : XCTestCase

@end

@implementation LINLocalizationParserTests

- (void)testParsingLocalizations
{
    // Create test set
    struct LINLocalizationTestSet {
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
    }, *testSetsPtr;
    testSetsPtr = testSets; // This avoids the compiler error 'cannot refer to declaration with an array type inside block'
    
    // Parse localizations
    LINLocalizationParser *parser = [LINLocalizationParser new];
    NSString *filePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"Localizations" ofType:@"strings"];
    NSArray *localizations = [parser localizationsFromContentsOfFile:filePath];
    
    // Test results
    NSUInteger numberOfTestSets = sizeof(testSets) / sizeof(struct LINLocalizationTestSet);
    XCTAssertEqual(localizations.count, numberOfTestSets);
    
    [localizations enumerateObjectsUsingBlock:^(LINLocalization *localization, NSUInteger index, BOOL *stop) {
        XCTAssertTrue([localization.key isEqualToString:testSetsPtr[index].key]);
        XCTAssertTrue([localization.value isEqualToString:testSetsPtr[index].value]);
    }];
}

@end
