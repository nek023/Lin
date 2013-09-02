//
//  LocalizationTests.m
//  Lin
//
//  Created by Katsuma Tanaka on 2013/06/03.
//  Copyright (c) 2013年 Katsuma Tanaka. All rights reserved.
//

#import "LocalizationTests.h"


#import "Localization.h"
#import "LocalizationItem.h"

@interface Localization (Tests)

+ (BOOL)searchKeyValueWithRegex:(NSRegularExpression *)regularExpression inLine:(NSString *)line key:(NSString **)key value:(NSString **)value;

@end

@implementation LocalizationTests

- (void)testKeyValueDetection
{
    struct TestRegex {
        NSString *regex;
        NSString *key;
        NSString *value;
    } testData[] = {
        {@"key0 = \"value0\";",            @"key0",  @"value0"},
        {@" key1 = \"value1\";",           @"key1",  @"value1"},
        {@"key2= \"value2\";",             @"key2",  @"value2"},
        {@"key3=\"value3\";",              @"key3",  @"value3"},
        {@"\"key4\" = \"value4\";",        @"key4",  @"value4"},
        {@" \"key5\" = \"value5\";",       @"key5",  @"value5"},
        {@"\"key6\"= \"value6\";",         @"key6",  @"value6"},
        {@"\"key7\"=\"value7\";",          @"key7",  @"value7"},
        {@"key8	=	\"value8\";",          @"key8",  @"value8"},
        {@"\"key 0\"=\"value9\";",         @"key 0", @"value9"},
        {@"\"key 0\"	=\"value10\";",    @"key 0", @"value10"},
        {@" \"key 0\"=\"value11\";",       @"key 0", @"value11"},
        {@" \"key 0\" =\"value12\";",      @"key 0", @"value12"},
        {@"\"key 0\" = \"value13\";",      @"key 0", @"value13"},
        {@"\"key 0\" =	\"value14\";",     @"key 0", @"value14"},
        {@"	\"key 0\"	=\"value15\";",    @"key 0", @"value15"},
        {@"	\"key 0\"	=	\"value16\";", @"key 0", @"value16"},
        {@"\"key.0\"	=	\"value17\";", @"key.0", @"value17"},
        {@"key.0	=	\"value18\";",     @"key.0", @"value18"},
        {@" key.0	=	\"value19\";",     @"key.0", @"value19"},
        {@" key.0=\"value20\";",           @"key.0", @"value20"},
        {@"key.0=\"value21\";",            @"key.0", @"value21"}
    };
    
    NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:parseKeyValueRegex options:0 error:NULL];
    NSString *key = nil;
    NSString *value = nil;
    
    for (NSInteger i = 0; i < (sizeof(testData) / sizeof(struct TestRegex)); i++) {
        STAssertTrue([Localization searchKeyValueWithRegex:regularExpression inLine:testData[i].regex key:&key value:&value], nil);
        STAssertTrue([key isEqualToString:testData[i].key], [NSString stringWithFormat:@"%@ != %@", key, testData[i].key]);
        STAssertTrue([value isEqualToString:testData[i].value], [NSString stringWithFormat:@"%@ != %@", key, testData[i].value]);
    }
}

@end
