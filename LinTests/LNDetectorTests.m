//
//  LNDetectorTests.m
//  Lin
//
//  Created by Tanaka Katsuma on 2013/08/21.
//  Copyright (c) 2013年 Tanaka Katsuma. All rights reserved.
//

#import <XCTest/XCTest.h>

// Models
#import "LNDetector.h"
#import "LNEntity.h"
#import "LNDetectorTestSet.h"

@interface LNDetectorTests : XCTestCase

@property (nonatomic, strong) LNDetector *detector;

- (void)performTests:(LNDetectorTestSet *)testSetValue, ... NS_REQUIRES_NIL_TERMINATION;

@end

@implementation LNDetectorTests

- (void)setUp
{
    [super setUp];
    
    LNDetector *detector = [LNDetector detector];
    self.detector = detector;
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testLocalizedString
{
    [self performTests:
     [[LNDetectorTestSet alloc] initWithString:@"NSLocalizedString(@\"key\", nil);"
                                          keys:@"key", nil],
     
     [[LNDetectorTestSet alloc] initWithString:@"NSLocalizedString ( @\"key\" , nil );"
                                          keys:@"key", nil],
     [[LNDetectorTestSet alloc] initWithString:@"NSString *value = NSLocalizedString(@\"key\", nil);"
                                          keys:@"key", nil],
     [[LNDetectorTestSet alloc] initWithString:@"NSLog(@\"value1 = %@, value2 = %@\", NSLocalizedString(@\"key1\", nil), NSLocalizedString(@\"key2\", nil));"
                                          keys:@"key1", @"key2", nil],
     nil];
}

- (void)testLocalizedStringForKey
{
    [self performTests:
     [[LNDetectorTestSet alloc] initWithString:@"[[NSBundle mainBundle] localizedStringForKey:@\"key\" value:@\"default_value\" table:@\"table_name\"];"
                                          keys:@"key", nil],
     nil];
}

- (void)testLocalizedStringFromTable
{
    [self performTests:
     [[LNDetectorTestSet alloc] initWithString:@"NSLocalizedStringFromTable(@\"key\", @\"table_name\", @\"comment\");"
                                          keys:@"key", nil],
     nil];
}

- (void)testLocalizedStringFromTableInBundle
{
    [self performTests:
     [[LNDetectorTestSet alloc] initWithString:@"NSLocalizedStringFromTableInBundle(@\"key\", @\"table_name\", [NSBundle mainBundle], @\"comment\");"
                                          keys:@"key", nil],
     nil];
}

- (void)testLocalizedStringWithDefaultValue
{
    [self performTests:
     [[LNDetectorTestSet alloc] initWithString:@"NSLocalizedStringWithDefaultValue(@\"key\", @\"table_name\", [NSBundle mainBundle], @\"default_value\", @\"comment\");"
                                          keys:@"key", nil],
     nil];
}

- (void)performTests:(LNDetectorTestSet *)testSetValue, ...
{
    // Parse arguments
    va_list arguments;
    va_start(arguments, testSetValue);
    
    LNDetectorTestSet *testSet = testSetValue;
    NSMutableArray *testSets = [NSMutableArray array];
    
    while (testSet) {
        [testSets addObject:testSet];
        
        testSet = va_arg(arguments, typeof(LNDetectorTestSet *));
    }
    
    va_end(arguments);
    
    // Do tests
    for (LNDetectorTestSet *testSet in testSets) {
        NSArray *entities = [self.detector entitiesInString:testSet.string];
        XCTAssertTrue(entities.count == testSet.keys.count); // Number of detected entities and expected keys are equal.
        
        for (LNEntity *entity in entities) {
            NSUInteger indexOfEntity = [entities indexOfObject:entity];
            NSString *keyString = [testSet.string substringWithRange:entity.keyRange];
            XCTAssertEqualObjects(keyString, testSet.keys[indexOfEntity]); // Extracted key is equal to expected key.
        }
    }
}

@end
