/*
 Copyright (c) 2013 Katsuma Tanaka
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#import "Localization.h"

#import "LocalizationItem.h"

@implementation Localization

+ (id)localization
{
    return [[[self alloc] init] autorelease];
}

- (id)init
{
    self = [super init];
    
    if(self) {
        self.localizations = [NSMutableDictionary dictionary];
    }
    
    return self;
}

- (void)dealloc
{
    [_localizations release];
    
    [super dealloc];
}


#pragma mark - Localization Management

- (void)addLocalizationFromContentsOfFile:(NSString *)filePath encoding:(NSStringEncoding)encoding
{
    // Detect language
    NSArray *pathComponents = [filePath pathComponents];
    NSString *directory = [pathComponents objectAtIndex:pathComponents.count - 2];
    NSString *language = [directory stringByDeletingPathExtension];
    
    // Load
    NSString *contents = [NSString stringWithContentsOfFile:filePath encoding:encoding error:NULL];
    
    // Parse
    NSMutableDictionary *localizationPairs = [NSMutableDictionary dictionary];
    
    [contents enumerateLinesUsingBlock:^(NSString *line, BOOL *stop) {
        // Regular expression
        NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:@"\"(.*)\".*=.*\"(.*)\"" options:0 error:NULL];
        
        [regularExpression enumerateMatchesInString:line options:0 range:NSMakeRange(0, line.length) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
            if(result.numberOfRanges == 3) {
                NSRange keyRange = [result rangeAtIndex:1];
                NSRange stringValueRange = [result rangeAtIndex:2];
                
                NSString *key = [line substringWithRange:keyRange];
                NSString *stringValue = [line substringWithRange:stringValueRange];
                
                [localizationPairs setObject:stringValue forKey:key];
            }
            
            *stop = YES;
        }];
    }];
    
    [self.localizations setObject:[NSDictionary dictionaryWithDictionary:localizationPairs] forKey:language];
}

- (NSArray *)languages
{
    return [self.localizations allKeys];
}

- (NSArray *)localizationItems
{
    NSMutableArray *localizationItems = [NSMutableArray array];
    
    NSArray *languages = [self.localizations allKeys];
    for(NSString *language in languages) {
        NSDictionary *localizationPairs = [self.localizations objectForKey:language];
        
        NSArray *keys = [localizationPairs allKeys];
        for(NSString *key in keys) {
            NSString *stringValue = [localizationPairs objectForKey:key];
            
            LocalizationItem *localizationItem = [LocalizationItem localizationItem];
            localizationItem.language = language;
            localizationItem.key = key;
            localizationItem.stringValue = stringValue;
            
            [localizationItems addObject:localizationItem];
        }
    }
    
    return [NSArray arrayWithArray:localizationItems];
}

@end
