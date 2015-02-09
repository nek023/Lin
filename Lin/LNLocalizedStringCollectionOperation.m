//
//  LNLocalizedStringCollectionOperation.m
//  Lin
//
//  Created by Wenbin Zhang on 3/7/14.
//  Copyright (c) 2014 Tanaka Katsuma. All rights reserved.
//

#import "LNLocalizedStringCollectionOperation.h"
#import "IDEIndex.h"
#import "IDEWorkspace.h"
#import "IDEIndexCollection.h"
#import "DVTFilePath.h"
#import "LNLocalizationCollection.h"

@interface LNLocalizedStringCollectionOperation ()

@property (nonatomic, strong) NSArray *collections;
@property (nonatomic, strong) NSString *workspaceFilePath;
@end

@implementation LNLocalizedStringCollectionOperation

- (instancetype)initWithIndex:(IDEIndex *)index
{
    self = [super init];
    if (self) {
        self.index = index;
    }
    return self;
}

- (void)main
{
    @autoreleasepool {
        if (self.isCancelled) {
            return;
        }
        
        if (!self.index) {
            return;
        }
        [self processLocalizedString];
        
        if (self.isCancelled) {
            return;
        }
        
        if (self.collectionCompletedBlock) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.collectionCompletedBlock(self.workspaceFilePath, self.collections);
            });
        }
        
        [self cleanup];
    }
}

- (void)processLocalizedString
{
    IDEWorkspace *workspace = [self.index valueForKey:@"_workspace"];
    DVTFilePath *representingFilePath = workspace.representingFilePath;
    self.workspaceFilePath = representingFilePath.pathString;
    NSMutableArray *mutableCollections = [[NSMutableArray alloc] init];
    
    if (self.workspaceFilePath) {
        NSString *projectRootPath = [[self.workspaceFilePath stringByDeletingLastPathComponent] stringByDeletingLastPathComponent];
        
        // Find .strings files
        IDEIndexCollection *indexCollection = [self.index filesContaining:@".strings" anchorStart:NO anchorEnd:NO subsequence:NO ignoreCase:YES cancelWhen:nil];
        
        for (DVTFilePath *filePath in indexCollection) {
            if (self.isCancelled) {
                return;
            }
            NSString *pathString = filePath.pathString;
            
            BOOL parseStringsFilesOutsideWorkspaceProject = YES;
            if (parseStringsFilesOutsideWorkspaceProject ||
                (!parseStringsFilesOutsideWorkspaceProject && [pathString rangeOfString:projectRootPath].location != NSNotFound)) {
                // Create localization collection
                LNLocalizationCollection *collection = [LNLocalizationCollection localizationCollectionWithContentsOfFile:pathString];
                [mutableCollections addObject:collection];
            }
        }
        self.collections = [mutableCollections copy];
    }
}

- (void)cleanup
{
    self.index = nil;
}

@end
