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

@implementation DVTTextCompletionController (Lin)

+ (void)load
{
    MethodSwizzle(self,
                  @selector(acceptCurrentCompletion),
                  @selector(lin_acceptCurrentCompletion));
}

- (BOOL)lin_acceptCurrentCompletion
{
    BOOL acceptCurrentCompletion = [self lin_acceptCurrentCompletion]; // Original method must be called at first
    
    DVTSourceTextView *textView = (DVTSourceTextView *)self.textView;
    DVTTextStorage *textStorage = (DVTTextStorage *)textView.textStorage;
    NSString *string = textStorage.string;
    NSUInteger location = textView.selectedRange.location;
    
    BOOL shouldAutoComplete = [[Lin sharedInstance] shouldAutoCompleteInTextView:textView location:location];
    
    if (shouldAutoComplete) {
        // Find the first completion placeholder
        NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:@"<#.*?#>" options:0 error:nil];
        NSTextCheckingResult *match = [regularExpression firstMatchInString:string options:0 range:NSMakeRange(location, string.length - location)];
        
        if (match) {
            [textView insertText:@"" replacementRange:match.range];
            [self _showCompletionsAtCursorLocationExplicitly:YES];
        }
    }
    
    return acceptCurrentCompletion;
}

@end
