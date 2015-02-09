//
//  LNTableHeaderCell.m
//  Lin
//
//  Created by Tanaka Katsuma on 2013/09/21.
//  Copyright (c) 2013年 Tanaka Katsuma. All rights reserved.
//

#import "LNTableHeaderCell.h"

static const NSInteger kLNTableHeaderCellSortIndicatorWidth = 8;
static const NSInteger kLNTableHeaderCellSortIndicatorHeight = 7;
static const NSInteger kLNTableHeaderCellSortIndicatorMarginX = 4;
static const NSInteger kLNTableHeaderCellSortIndicatorMarginY = 6;

@interface LNTableHeaderCell ()

@property (nonatomic, assign) BOOL ascending;
@property (nonatomic, assign) NSInteger priority;

- (void)drawContentInRect:(NSRect)rect highlighted:(BOOL)highlighted;

@end

@implementation LNTableHeaderCell

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        self.priority = 1;
    }
    
    return self;
}


#pragma mark - Accessors

- (void)setSortAscending:(BOOL)ascending priority:(NSInteger)priority
{
    self.ascending = ascending;
    self.priority = priority;
}


#pragma mark - Drawing the View

- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
{
    [self drawContentInRect:cellFrame highlighted:NO];
    [self drawSortIndicatorWithFrame:cellFrame inView:controlView ascending:self.ascending priority:self.priority];
}

- (void)highlight:(BOOL)flag withFrame:(NSRect)cellFrame inView:(NSView *)controlView
{
    [self drawContentInRect:cellFrame highlighted:YES];
    [self drawSortIndicatorWithFrame:cellFrame inView:controlView ascending:self.ascending priority:self.priority];
}

- (void)drawContentInRect:(NSRect)rect highlighted:(BOOL)highlighted
{
    // Draw background
    NSRect backgroundRect = rect;
    backgroundRect.size.width -= 1;
    
    if (highlighted) {
        [[NSColor colorWithDeviceWhite:153.0/255.0 alpha:1.0] set];
    } else {
        [[NSColor whiteColor] set];
    }
    
    NSRectFill(backgroundRect);
    
    // Draw separator
    [[NSColor colorWithDeviceWhite:204.0/255.0 alpha:1.0] setStroke];
    [NSBezierPath strokeLineFromPoint:NSMakePoint(rect.origin.x, rect.size.height - 0.5)
                              toPoint:NSMakePoint(rect.origin.x + rect.size.width, rect.size.height - 0.5)];
    
    // Draw title
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:[self attributedStringValue]];
    
    NSDictionary *attributes;
    if (highlighted) {
        attributes = @{
                       NSForegroundColorAttributeName: [NSColor whiteColor],
                       NSFontAttributeName: [NSFont systemFontOfSize:12.0]
                       };
    } else {
        attributes = @{
                       NSForegroundColorAttributeName: [NSColor colorWithDeviceWhite:153.0/255.0 alpha:1.0],
                       NSFontAttributeName: [NSFont systemFontOfSize:12.0]
                       };
    }
    
    [attributedString addAttributes:attributes range:NSMakeRange(0, [attributedString length])];
    
    NSRect titleRect = rect;
    titleRect.origin.x += 3;
    titleRect.origin.y += 0;
    
    [attributedString drawInRect:titleRect];
}

- (void)drawSortIndicatorWithFrame:(NSRect)cellFrame inView:(NSView *)controlView ascending:(BOOL)ascending priority:(NSInteger)priority
{
    NSBezierPath *path = [NSBezierPath bezierPath];
    
    if (ascending) {
        NSPoint p = NSMakePoint(cellFrame.origin.x + cellFrame.size.width - kLNTableHeaderCellSortIndicatorWidth - kLNTableHeaderCellSortIndicatorMarginX,
                                cellFrame.origin.y + cellFrame.size.height - kLNTableHeaderCellSortIndicatorMarginY);
        [path moveToPoint:p];
        
        p.x += kLNTableHeaderCellSortIndicatorWidth / 2.0;
        p.y -= kLNTableHeaderCellSortIndicatorHeight;
        [path lineToPoint:p];
        
        p.x += kLNTableHeaderCellSortIndicatorWidth / 2.0;
        p.y += kLNTableHeaderCellSortIndicatorHeight;
        [path lineToPoint:p];
    } else {
        NSPoint p = NSMakePoint(cellFrame.origin.x + cellFrame.size.width - kLNTableHeaderCellSortIndicatorWidth - kLNTableHeaderCellSortIndicatorMarginX,
                                cellFrame.origin.y + cellFrame.size.height - kLNTableHeaderCellSortIndicatorHeight - kLNTableHeaderCellSortIndicatorMarginY);
        [path moveToPoint:p];
        
        p.x += kLNTableHeaderCellSortIndicatorWidth / 2.0;
        p.y += kLNTableHeaderCellSortIndicatorHeight;
        [path lineToPoint:p];
        
        p.x += kLNTableHeaderCellSortIndicatorWidth / 2.0;
        p.y -= kLNTableHeaderCellSortIndicatorHeight;
        [path lineToPoint:p];
    }
    
    [path closePath];
    
    if (priority == 0) {
        [[NSColor colorWithDeviceWhite:153.0/255.0 alpha:1.0] set];
    } else {
        [[NSColor clearColor] set];
    }
    
    [path fill];
}

@end
