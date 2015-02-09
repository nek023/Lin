//
//  NSPopoverFrame+Lin.m
//  Lin
//
//  Created by Tanaka Katsuma on 2013/09/21.
//  Copyright (c) 2013年 Tanaka Katsuma. All rights reserved.
//

#import "NSPopoverFrame+Lin.h"
#import <CoreServices/CoreServices.h>

#import "MethodSwizzle.h"

@implementation NSPopoverFrame (Lin)

+ (void)load
{
    MethodSwizzle(self, @selector(_drawMinimalPopoverAppearanceInRect:anchorEdge:anchorPoint:), @selector(jp_questbeat_lin_drawMinimalPopoverAppearanceInRect:anchorEdge:anchorPoint:));
}

- (void)jp_questbeat_lin_drawMinimalPopoverAppearanceInRect:(struct CGRect)arg1 anchorEdge:(unsigned long long)arg2 anchorPoint:(struct CGPoint)arg3
{
    [self jp_questbeat_lin_drawMinimalPopoverAppearanceInRect:arg1 anchorEdge:arg2 anchorPoint:arg3];
    
    // Check OS version
    SInt32 major = 0;
    SInt32 minor = 0;
    Gestalt(gestaltSystemVersionMajor, &major);
    Gestalt(gestaltSystemVersionMinor, &minor);
    
    if ((major == 10 && minor <= 8) || major <= 9) {
        // Mac OS X Mountain Lion or older
        // This code will cause a problem on Max OS X 10.9 Mavericks (or maybe later)
        [[NSColor whiteColor] setFill];
        NSRectFill(arg1);
    } else {
        // Mac OS X Mavericks or later
        CGPathRef path = [self _newMinimalAppearancePathInBounds:arg1
                                                      anchorEdge:arg2
                                                     anchorPoint:arg3
                                                      topCapOnly:NO
                                                     arrowOffset:0];
        CGImageRef maskImage = [self _imageMaskForPath:(struct CGPath *)path
                                            anchorEdge:arg2
                                           anchorPoint:arg3];
        
        NSBitmapImageRep *backgroundImageRep = [self backgroundImageRepWithSize:self.bounds.size maskImage:maskImage];
        
        CGContextRef context = [[NSGraphicsContext currentContext] graphicsPort];
        CGImageRef backgroundImageRef = [backgroundImageRep CGImage];
        CGContextDrawImage(context, self.bounds, backgroundImageRef);
    }
}

- (NSBitmapImageRep *)backgroundImageRepWithSize:(NSSize)size maskImage:(CGImageRef)maskImage
{
    CGContextRef currentContext = [[NSGraphicsContext currentContext] graphicsPort];
    CGContextSaveGState(currentContext);
    
    CGFloat scale = [self convertSizeToBacking:CGSizeMake(1, 1)].width;
    size.width *= scale;
    size.height *= scale;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL,
                                                 size.width,
                                                 size.height,
                                                 8,
                                                 4 * size.width,
                                                 colorSpace,
                                                 (CGBitmapInfo)kCGImageAlphaPremultipliedLast);
    
    CGContextClipToMask(context, CGRectMake(0, 0, size.width, size.height), maskImage);
    
    CGContextSetFillColorWithColor(context, [[NSColor whiteColor] CGColor]);
    CGContextFillRect(context, CGRectMake(0, 0, size.width, size.height));
    
    CGImageRef backgroundImageRef = CGBitmapContextCreateImage(context);
    NSBitmapImageRep *backgroundImageRep = [[NSBitmapImageRep alloc] initWithCGImage:backgroundImageRef];
    CGImageRelease(backgroundImageRef);
    
    CGContextRelease(context);
    
    CGContextRestoreGState(currentContext);
    
    return backgroundImageRep;
}

@end
