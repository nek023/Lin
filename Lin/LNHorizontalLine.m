//
//  LNHorizontalLine.m
//  Lin
//
//  Created by Tanaka Katsuma on 2013/09/21.
//  Copyright (c) 2013年 Tanaka Katsuma. All rights reserved.
//

#import "LNHorizontalLine.h"

@implementation LNHorizontalLine

- (void)drawRect:(NSRect)dirtyRect
{
    [[NSColor colorWithDeviceWhite:204.0/255.0 alpha:1.0] set];
    [NSBezierPath strokeLineFromPoint:NSMakePoint(dirtyRect.origin.x, 2.5)
                              toPoint:NSMakePoint(dirtyRect.origin.x + dirtyRect.size.width, 2.5)];
}

@end
