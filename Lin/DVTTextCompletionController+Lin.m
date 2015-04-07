//
//  DVTTextCompletionController+Lin.m
//  Lin
//
//  Created by Katsuma Tanaka on 2015/02/05.
//  Copyright (c) 2015年 Katsuma Tanaka. All rights reserved.
//

#import "DVTTextCompletionController+Lin.h"
#import "MethodSwizzle.h"
#import "Xcode.h"
#import "Lin.h"
#import "LINLocalization.h"
#import "LINTextCompletionItem.h"

@implementation DVTTextCompletionController (Lin)

+ (void)load
{
    MethodSwizzle(self,
                  @selector(acceptCurrentCompletion),
                  @selector(lin_acceptCurrentCompletion));
}

- (BOOL)lin_acceptCurrentCompletion
{
  
    // Get selected completion
    DVTTextCompletionSession *session = self.currentSession;
    id selectedCompletion = nil;
  
    if (session.selectedCompletionIndex < session.filteredCompletionsAlpha.count) {
      selectedCompletion = session.filteredCompletionsAlpha[session.selectedCompletionIndex];
    }
  
    // Original method must be called after referencing selected completion
    BOOL acceptCurrentCompletion = [self lin_acceptCurrentCompletion];
    
    DVTSourceTextView *textView = (DVTSourceTextView *)self.textView;
    DVTTextStorage *textStorage = (DVTTextStorage *)textView.textStorage;
    DVTSourceCodeLanguage *language = textStorage.language;
    
    if ([selectedCompletion isKindOfClass:[LINTextCompletionItem class]]) {
        // Replace table name
        NSRange tableNameRange = [[Lin sharedInstance] replacableTableNameRangeInTextView:textView];
        
        if (tableNameRange.location != NSNotFound) {
            LINLocalization *localization = [[(LINTextCompletionItem *)selectedCompletion localizations] lastObject];
            
            NSString *text;
            if ([language lin_isObjectiveC]) {
                text = [NSString stringWithFormat:@"@\"%@\"", localization.tableName];
            } else {
                text = [NSString stringWithFormat:@"\"%@\"", localization.tableName];
            }
            
            [textView insertText:text replacementRange:tableNameRange];
        }
    } else {
        // Replace key
        NSRange keyRange = [[Lin sharedInstance] replacableKeyRangeInTextView:textView];
        
        if (keyRange.location != NSNotFound) {
            [textView insertText:@"" replacementRange:keyRange];
            [self _showCompletionsAtCursorLocationExplicitly:YES];
        }
    }
    
    return acceptCurrentCompletion;
}

@end
