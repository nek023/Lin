//
//  LNImageButtonCell.m
//  Lin
//
//  Created by Tanaka Katsuma on 2014/03/04.
//  Copyright (c) 2014年 Tanaka Katsuma. All rights reserved.
//

#import "LNImageButtonCell.h"

@implementation LNImageButtonCell

- (void)drawImage:(NSImage *)image withFrame:(NSRect)frame inView:(NSView *)controlView
{
    // Adjustment
    frame.origin.y += 2;
    
    [super drawImage:image withFrame:frame inView:controlView];
}

@end
