/*
 Copyright (c) 2013 Katsuma Tanaka
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#import <Cocoa/Cocoa.h>

// Views
#import "PopoverContentView.h"

@class IDEIndex;

@interface Lin : NSObject <NSPopoverDelegate, PopoverContentViewDelegate>

@property (assign) IBOutlet NSPopover *popover;

@property (nonatomic, assign) NSResponder *previousFirstResponder;
@property (nonatomic, retain) NSTextView *textView;

@property (nonatomic, copy) NSString *currentWorkspacePath;
@property (nonatomic, retain) NSMutableDictionary *localizationFileSets;
@property (nonatomic, retain) NSMutableDictionary *localizations;
@property (nonatomic, readonly) BOOL enabled;
@property (nonatomic, retain) NSArray *regexs;

+ (instancetype)sharedPlugin;
+ (void)pluginDidLoad:(NSBundle *)plugin;
- (id)initWithBundle:(NSBundle *)bundle;

- (void)indexNeedsUpdate:(IDEIndex *)index;
- (void)removeFilesForIndex:(IDEIndex *)index;

@end
