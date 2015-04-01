//
//  DVTTextCompletionDataSource+Lin.m
//  Lin
//
//  Created by Katsuma Tanaka on 2015/02/08.
//  Copyright (c) 2015年 Katsuma Tanaka. All rights reserved.
//

#import "DVTTextCompletionDataSource+Lin.h"
#import "MethodSwizzle.h"
#import "Xcode.h"
#import "Lin.h"
#import "LINTextCompletionItem.h"

@implementation DVTTextCompletionDataSource (Lin)

+ (void)load
{
    MethodSwizzle(self,
                  @selector(generateCompletionsForDocumentLocation:context:completionBlock:),
                  @selector(lin_generateCompletionsForDocumentLocation:context:completionBlock:));
}

- (void)lin_generateCompletionsForDocumentLocation:(id)arg1 context:(id)arg2 completionBlock:(void (^)(id, id))arg3
{
    DVTSourceTextView *textView = [arg2 objectForKey:@"DVTTextCompletionContextTextView"];
    DVTTextStorage *textStorage = (DVTTextStorage *)textView.textStorage;
    DVTSourceCodeLanguage *language = textStorage.language;
    
    BOOL shouldAutoComplete = [[Lin sharedInstance] shouldAutoCompleteInTextView:textView];
    
    if (shouldAutoComplete) {
        IDEWorkspace *workspace = [arg2 objectForKey:@"IDETextCompletionContextWorkspaceKey"];
        NSArray *items = [[Lin sharedInstance] completionItemsForWorkspace:workspace];
        
        LINSourceCodeLanguage sourceCodeLanguage = [language lin_isObjectiveC] ? LINSourceCodeLanguageObjectiveC : LINSourceCodeLanguageSwift;
        for (LINTextCompletionItem *item in items) {
            item.sourceCodeLanguage = sourceCodeLanguage;
        }
        
        void (^completionBlock)(id, id) = ^(id obj1, id obj2) {
            if (arg3) arg3(items, obj2);
        };
        
        [self lin_generateCompletionsForDocumentLocation:arg1 context:arg2 completionBlock:completionBlock];
    } else {
        [self lin_generateCompletionsForDocumentLocation:arg1 context:arg2 completionBlock:arg3];
    }
}

@end
