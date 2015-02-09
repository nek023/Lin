//
//  Lin.m
//  Lin
//
//  Created by Katsuma Tanaka on 2015/02/05.
//  Copyright (c) 2015年 Katsuma Tanaka. All rights reserved.
//

#import "Lin.h"

// Xcode
#import "Xcode.h"

// Models
#import "LINLocalizationParser.h"
#import "LINLocalization.h"
#import "LINTextCompletionItem.h"

static id _sharedInstance = nil;

@interface Lin ()

@property (nonatomic, copy) NSArray *configurations;
@property (nonatomic, strong) LINLocalizationParser *parser;
@property (nonatomic, strong) NSMutableDictionary *completionItems;
@property (nonatomic, strong) NSOperationQueue *indexingQueue;

@end

@implementation Lin

+ (void)pluginDidLoad:(NSBundle *)bundle
{
    static dispatch_once_t _onceToken;
    dispatch_once(&_onceToken, ^{
        _sharedInstance = [self new];
    });
}

+ (instancetype)sharedInstance
{
    return _sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        // Load configurations
        NSString *filePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"Completions" ofType:@"plist"];
        self.configurations = [NSArray arrayWithContentsOfFile:filePath];
        
        self.parser = [LINLocalizationParser new];
        self.completionItems = [NSMutableDictionary dictionary];
        
        // Create indexing queue
        NSOperationQueue *indexingQueue = [NSOperationQueue new];
        indexingQueue.maxConcurrentOperationCount = 1;
        self.indexingQueue = indexingQueue;
    }
    
    return self;
}


#pragma mark - Indexing Localizations

- (void)indexNeedsUpdate:(IDEIndex *)index
{
    IDEWorkspace *workspace = [index valueForKey:@"_workspace"];
    NSString *workspaceFilePath = workspace.representingFilePath.pathString;
    if (workspaceFilePath == nil) return;
    
    // Add indexing operation
    NSBlockOperation *operation = [NSBlockOperation new];
    
    __weak __typeof(self) weakSelf = self;
    __weak NSBlockOperation *weakOperation = operation;
    
    [operation addExecutionBlock:^{
        // Find strings files
        IDEIndexCollection *indexCollection = [index filesContaining:@".strings" anchorStart:NO anchorEnd:NO subsequence:NO ignoreCase:YES cancelWhen:nil];
        
        if ([weakOperation isCancelled]) return;
        
        // Classify localizations by key
        NSMutableDictionary *localizationsByKey = [NSMutableDictionary dictionary];
        
        for (DVTFilePath *filePath in indexCollection) {
            if ([weakOperation isCancelled]) return;
            
            NSArray *parsedLocalizations = [self.parser localizationsFromContentsOfFile:filePath.pathString];
            
            for (LINLocalization *localization in parsedLocalizations) {
                NSMutableArray *localizations = localizationsByKey[localization.key];
                
                if (localizations) {
                    [localizations addObject:localization];
                } else {
                    localizations = [NSMutableArray array];
                    [localizations addObject:localization];
                    localizationsByKey[localization.key] = localizations;
                }
            }
        }
        
        if ([weakOperation isCancelled]) return;
        
        // Convert localizations to completions
        NSMutableArray *completionItems = [NSMutableArray array];
        
        for (NSString *key in [localizationsByKey allKeys]) {
            if ([weakOperation isCancelled]) return;
            
            NSMutableArray *localizations = localizationsByKey[key];
            
            // Sort localizations
            [localizations sortUsingComparator:^NSComparisonResult(LINLocalization *lhs, LINLocalization *rhs) {
                return [[lhs languageDesignation] caseInsensitiveCompare:[rhs languageDesignation]];
            }];
            
            // Create completion item
            LINTextCompletionItem *completionItem = [[LINTextCompletionItem alloc] initWithLocalizations:localizations];
            [completionItems addObject:completionItem];
        }
        
        if ([weakOperation isCancelled]) return;
        
        // Sort completions
        [completionItems sortUsingComparator:^NSComparisonResult(LINTextCompletionItem *lhs, LINTextCompletionItem *rhs) {
            return [[lhs key] caseInsensitiveCompare:[rhs key]];
        }];
        
        if ([weakOperation isCancelled]) return;
        
        weakSelf.completionItems[workspaceFilePath] = completionItems;
    }];
    
    [self.indexingQueue cancelAllOperations];
    [self.indexingQueue addOperation:operation];
}


#pragma mark - Auto Completion

- (BOOL)isAutoCompletableFunction:(NSString *)name
{
    return [[self.configurations valueForKey:@"LINFunctionName"] containsObject:name];
}

- (BOOL)shouldAutoCompleteInTextView:(DVTCompletingTextView *)textView location:(NSUInteger)location
{
    if (textView == nil) return NO;
    
    DVTTextStorage *textStorage = (DVTTextStorage *)textView.textStorage;
    DVTSourceCodeLanguage *language = textStorage.language;
    NSString *string = [textStorage.string substringToIndex:location];
    
    for (NSDictionary *configuration in self.configurations) {
        for (NSDictionary *patterns in configuration[@"LINCompletionPatterns"]) {
            NSString *pattern = patterns[language.languageName];
            
            if (pattern) {
                NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:nil];
                NSTextCheckingResult *match = [[regularExpression matchesInString:string options:0 range:NSMakeRange(0, string.length)] lastObject];
                
                if (match && NSMaxRange(match.range) == location) {
                    return YES;
                }
            }
        }
    }
    
    return NO;
}

- (NSArray *)completionItemsForWorkspace:(IDEWorkspace *)workspace
{
    NSString *workspaceFilePath = workspace.representingFilePath.pathString;
    if (workspaceFilePath == nil) return nil;
    
    return self.completionItems[workspaceFilePath];
}

@end
