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
    NSLog(@"*** lin_acceptCurrentCompletion");
    
    DVTTextCompletionSession *session = self.currentSession;
    id selectedCompletion = session.allCompletions[session.selectedCompletionIndex];
    BOOL completedLocalization = [selectedCompletion isKindOfClass:[LINTextCompletionItem class]];
    
    // Original method must be called after referencing selected completion
    BOOL acceptCurrentCompletion = [self lin_acceptCurrentCompletion];
    
    DVTSourceTextView *textView = (DVTSourceTextView *)self.textView;
    DVTTextStorage *textStorage = (DVTTextStorage *)textView.textStorage;
    NSString *string = textStorage.string;
    NSUInteger location = textView.selectedRange.location;
    
    if (completedLocalization) {
        NSLog(@"location: %lu", location);
        NSLog(@"%@", [string substringWithRange:NSMakeRange(location, 10)]);
        
        // Find the table name placeholder
        NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:@"<#tbl#>" options:0 error:nil];
        NSTextCheckingResult *match = [regularExpression firstMatchInString:string options:0 range:NSMakeRange(location, string.length - location)];
        
        if (match) {
            [textView insertText:@"hoge" replacementRange:match.range];
        }
    } else {
        BOOL shouldAutoComplete = [[Lin sharedInstance] shouldAutoCompleteInTextView:textView];
        
        if (shouldAutoComplete) {
            // Find the first completion placeholder
            NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:@"<#.*?#>" options:0 error:nil];
            NSTextCheckingResult *match = [regularExpression firstMatchInString:string options:0 range:NSMakeRange(location, string.length - location)];
            
            if (match) {
                [textView insertText:@"" replacementRange:match.range];
                [self _showCompletionsAtCursorLocationExplicitly:YES];
            }
        }
    }
    
    return acceptCurrentCompletion;
}

@end
