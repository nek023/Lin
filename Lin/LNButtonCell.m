//
//  LNButtonCell.m
//  Lin
//
//  Created by Tanaka Katsuma on 2013/09/21.
//  Copyright (c) 2013年 Tanaka Katsuma. All rights reserved.
//

#import "LNButtonCell.h"

@implementation LNButtonCell

- (void)drawImage:(NSImage *)image withFrame:(NSRect)frame inView:(NSView *)controlView
{
    // Adjustment
    frame.origin.y += 3;
    
    [super drawImage:image withFrame:frame inView:controlView];
}

@end
