//
//  Tests.m
//  Tests
//
//  Created by Hubert SARRET on 30/04/13.
//  Copyright (c) 2013 Katsuma Tanaka. All rights reserved.
//

#import "Tests.h"

#import "Localization.h"
#import "LocalizationItem.h"

@implementation Tests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testLocalization
{
	Localization *localization = [Localization localization];

	NSString *pResourcePath = [[NSBundle bundleForClass:[self class]] resourcePath];

	[localization addLocalizationFromContentsOfFile:[NSString stringWithFormat:@"%@/%@", pResourcePath, @"Tests.strings"] encoding:NSUTF8StringEncoding];

	[[localization localizationItems] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {

		LocalizationItem *item = (LocalizationItem *)obj;

		NSString *test = [NSString stringWithFormat:@"key%ld", (unsigned long)idx];
		STAssertTrue([item.key isEqualToString:test], [NSString stringWithFormat:@"%@ != %@", item.key, test]);
		test = [NSString stringWithFormat:@"value%ld", (unsigned long)idx];
		STAssertTrue([item.stringValue isEqualToString:test], [NSString stringWithFormat:@"%@ != %@", item.value, test]);
	}];
}

@end
