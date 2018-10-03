//
//  Three_Times__in_Blue_and_Yellow_View.m
//  Three Times (in Blue and Yellow)
//
//  Created by reinfurt on 10/19/16.
//  Copyright © 2016 O-R-G. All rights reserved.
//

#import "Three_Times__in_Blue_and_Yellow_View.h"

@implementation Three_Times__in_Blue_and_Yellow_View

- (instancetype)initWithFrame:(NSRect)frame isPreview:(BOOL)isPreview
{
    self = [super initWithFrame:frame isPreview:isPreview];
    if (self) {
        [self setAnimationTimeInterval:1/30.0];
    }
    return self;
}

- (void)startAnimation
{
    [super startAnimation];
}

- (void)stopAnimation
{
    [super stopAnimation];
}

- (void)drawRect:(NSRect)rect
{
    [super drawRect:rect];
    
    // get Core Graphics (CG) graphics context (Quartz 2D)
    
    CGContextRef context = [[NSGraphicsContext currentContext] graphicsPort];
    CGContextSetShouldAntialias(context, 1);
    
    // set global dims
    // move this out of local scope?
    
    xCenter = ( [self bounds].size.width / 2 );
    yCenter = ( [self bounds].size.height / 2 );
    radius = ( [self bounds].size.width / 5 );
    
    // set colors
    
    CGColorRef blue = CGColorCreateGenericRGB(0.0, 0.75, 0.95, 1.0);
    CGColorRef yellow = CGColorCreateGenericRGB(1.0, 0.87, 0.18, 1.0);
    
    // get time
    
    [self checkTime_nsdate];        // system time milliseconds (CGFloat) sweep
    
    // bg
    
    CGRect bg = CGRectMake(0, 0, [self bounds].size.width, [self bounds].size.height);
    CGContextSetRGBFillColor (context, 1, 1, 1, 1);
    CGContextFillRect(context, bg);
    
    // hours
    
    CGContextSetFillColorWithColor(context, blue);
    CGContextAddArc(context, xCenter-radius, yCenter, radius, radians(hourtodegree(sweephour) + 90), radians(hourtodegree(sweephour) - 90), 0);
    CGContextFillPath(context);
    CGContextSetFillColorWithColor(context, yellow);
    CGContextAddArc(context, xCenter-radius, yCenter, radius, radians(hourtodegree(sweephour) + 90), radians(hourtodegree(sweephour) - 90), 1);
    CGContextFillPath(context);
    
    // minutes
    
    CGContextSetFillColorWithColor(context, blue);
    CGContextAddArc(context, xCenter, yCenter, radius, radians(minutetodegree(sweepminute) + 90), radians(minutetodegree(sweepminute) - 90), 0);
    CGContextFillPath(context);
    CGContextSetFillColorWithColor(context, yellow);
    CGContextAddArc(context, xCenter, yCenter, radius, radians(minutetodegree(sweepminute) + 90), radians(minutetodegree(sweepminute) - 90), 1);
    CGContextFillPath(context);
    
    // seconds
    
    CGContextSetFillColorWithColor(context, blue);
    CGContextAddArc(context, xCenter+radius, yCenter, radius, radians(secondtodegree(sweepsecond) + 90), radians(secondtodegree(sweepsecond) - 90), 0);
    CGContextFillPath(context);
    CGContextSetFillColorWithColor(context, yellow);
    CGContextAddArc(context, xCenter+radius, yCenter, radius, radians(secondtodegree(sweepsecond) + 90), radians(secondtodegree(sweepsecond) - 90), 1);
    CGContextFillPath(context);
    
    // [self debugText:xCenter/15 yPosition:yCenter/15 canvasWidth:200 canvasHeight:100];        // debug
    
    CGContextFlush(context);
}

- (void)animateOneFrame
{
    [self setNeedsDisplay:YES];
    return;
}

- (void) checkTime_nsdate
{
    // get current time in milliseconds
    
    NSDate *now = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"hh:mm:ss.SSS";
    NSString *string = [formatter stringFromDate: now];
    NSArray *timeComponents = [string componentsSeparatedByString:@":"];
    
    NSInteger hr = [timeComponents[0] integerValue];
    NSInteger min = [timeComponents[1] integerValue];
    sweepsecond = [timeComponents[2] floatValue];
    sweepminute = min + (sweepsecond / 60.0);
    sweephour = hr + (sweepminute / 60.0);
    
    return;
}

- (void)debugText:(CGFloat)xPosition yPosition:(CGFloat)yPosition canvasWidth:(CGFloat)canvasWidth canvasHeight:(CGFloat)canvasHeight
{
    //Draw Text
    CGRect textRect0 = CGRectMake(xPosition, yPosition, canvasWidth, canvasHeight);
    CGRect textRect1 = CGRectMake(xPosition, yPosition-12, canvasWidth, canvasHeight);
    CGRect textRect2 = CGRectMake(xPosition, yPosition-24, canvasWidth, canvasHeight);
    NSMutableParagraphStyle* textStyle = NSMutableParagraphStyle.defaultParagraphStyle.mutableCopy;
    textStyle.alignment = NSTextAlignmentLeft;
    NSDictionary* textFontAttributes = @{NSFontAttributeName: [NSFont fontWithName: @"Courier New" size: 12], NSForegroundColorAttributeName: NSColor.redColor, NSParagraphStyleAttributeName: textStyle};

    NSString *debug0 = [NSString stringWithFormat: @"0 :  %f", sweephour];
    NSString *debug1 = [NSString stringWithFormat: @"1 :  %f", sweepminute];
    NSString *debug2 = [NSString stringWithFormat: @"2 :  %f", sweepsecond];
    
    /*
    // output to log
    
    NSLog(@"====================================================================");
    NSLog(@"h: %f", sweephour);
    NSLog(@"m: %f", sweepminute);
    NSLog(@"s %f", sweepsecond);
    NSLog(@"====================================================================");
    */
     
    [debug0 drawInRect: textRect0 withAttributes: textFontAttributes];
    [debug1 drawInRect: textRect1 withAttributes: textFontAttributes];
    [debug2 drawInRect: textRect2 withAttributes: textFontAttributes];
}

- (BOOL)hasConfigureSheet
{
    return NO;
}

- (NSWindow*)configureSheet
{
    return nil;
}

@end
