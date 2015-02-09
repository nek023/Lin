//
//  LNTableCornerView.m
//  Lin
//
//  Created by Tanaka Katsuma on 2013/09/21.
//  Copyright (c) 2013年 Tanaka Katsuma. All rights reserved.
//

#import "LNTableCornerView.h"

@implementation LNTableCornerView

- (void)drawRect:(NSRect)dirtyRect
{
	[super drawRect:dirtyRect];
	
    // Background
    [[NSColor whiteColor] setFill];
    NSRectFill(dirtyRect);
    
    // Draw separator
    [[NSColor colorWithDeviceWhite:204.0/255.0 alpha:1.0] setStroke];
    [NSBezierPath strokeLineFromPoint:NSMakePoint(dirtyRect.origin.x, 0.5)
                              toPoint:NSMakePoint(dirtyRect.origin.x + dirtyRect.size.width, 0.5)];
}

@end
