//
//  LNAlertAccessoryView.m
//  Lin
//
//  Created by Tanaka Katsuma on 2013/09/22.
//  Copyright (c) 2013年 Tanaka Katsuma. All rights reserved.
//

#import "LNAlertAccessoryView.h"

// Models
#import "LNLocalizationCollection.h"

@interface LNAlertAccessoryView ()

@property (weak) IBOutlet NSPopUpButton *tableButton;
@property (weak) IBOutlet NSPopUpButton *languageButton;
@property (weak) IBOutlet NSTextField *keyTextField;
@property (weak) IBOutlet NSTextField *valueTextField;

@end

@implementation LNAlertAccessoryView

- (void)awakeFromNib
{
    [super awakeFromNib];
}


#pragma mark - Accessors

- (void)setCollections:(NSArray *)collections
{
    _collections = collections;
    
    // Update
    [self configureView];
}

- (void)setButton:(NSButton *)button
{
    _button = button;
    
    // Update
    [self configureButton];
}

- (LNLocalizationCollection *)selectedCollection
{
    NSString *selectedFileName = [self.tableButton titleOfSelectedItem];
    NSString *selectedLanguageDesignations = [self.languageButton titleOfSelectedItem];
    
    for (LNLocalizationCollection *collection in self.collections) {
        if ([collection.fileName isEqualToString:selectedFileName]
            && [collection.languageDesignation isEqualToString:selectedLanguageDesignations]) {
            return collection;
        }
    }
    
    return nil;
}

- (NSString *)inputtedKey
{
    return self.keyTextField.stringValue;
}

- (NSString *)inputtedValue
{
    return self.valueTextField.stringValue;
}


#pragma mark - Actions

- (IBAction)tableDidChange:(id)sender
{
    // Update
    [self updateLanguages];
}


#pragma mark - Updating the Views

- (void)updateTables
{
    [self.tableButton removeAllItems];
    
    NSMutableSet *tableFileNames = [NSMutableSet set];
    for (LNLocalizationCollection *collection in self.collections) {
        [tableFileNames addObject:collection.fileName];
    }
    
    [self.tableButton addItemsWithTitles:[tableFileNames allObjects]];
}

- (void)updateLanguages
{
    [self.languageButton removeAllItems];
    
    NSString *titleOfSelectedItem = [self.tableButton titleOfSelectedItem];
    
    NSMutableSet *languageDesignations = [NSMutableSet set];
    for (LNLocalizationCollection *collection in self.collections) {
        if ([titleOfSelectedItem isEqualToString:collection.fileName]) {
            [languageDesignations addObject:collection.languageDesignation];
        }
    }
    
    [self.languageButton addItemsWithTitles:[languageDesignations allObjects]];
}

- (void)configureView
{
    [self updateTables];
    [self updateLanguages];
    
    [self configureButton];
}

- (void)configureButton
{
    NSString *key = self.keyTextField.stringValue;
    NSString *value = self.valueTextField.stringValue;
    
    [self.button setEnabled:(self.collections.count > 0 && key.length > 0 && value.length > 0)];
}


#pragma mark - NSTextFieldDelegate

- (void)controlTextDidChange:(NSNotification *)obj
{
    [self configureButton];
}

@end
