//
//  TimetableView.m
//  iTimetable
//
//  Created by Evian张 on 2018/11/18.
//  Copyright © 2018 Evian张. All rights reserved.
//

#import "TimetableView.h"
#define origin NSMakePoint(50, 50)
#define dayWidth 100
#define titleHeight 30
#define dayHeight 500

@implementation TimetableView

- (BOOL)isFlipped{
    return YES;
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    NSColor *color = [NSColor controlTextColor];
    NSRect horizonTopLine = NSMakeRect(origin.x, origin.y, 7 * dayWidth, 1);
    NSRect horizonMidLine = NSMakeRect(origin.x, origin.y + titleHeight, 7 * dayWidth, 1);
    NSRect horizonBottomLine = NSMakeRect(origin.x, origin.y + titleHeight + dayHeight, 7 * dayWidth, 1);
    NSRect verticalLeftLine = NSMakeRect(origin.x, origin.y, 1, titleHeight + dayHeight);
    
    NSBezierPath *path;
    path = [NSBezierPath bezierPathWithRect:horizonTopLine];
    [color set];
    [path fill];
    path = [NSBezierPath bezierPathWithRect:horizonMidLine];
    [color set];
    [path fill];
    path = [NSBezierPath bezierPathWithRect:horizonBottomLine];
    [color set];
    [path fill];
    path = [NSBezierPath bezierPathWithRect:verticalLeftLine];
    [color set];
    [path fill];
    for (int column = 1; column <= 7; column++) {
        NSRect verticalColumnLine = NSMakeRect(origin.x + column * dayWidth, origin.y, 1, titleHeight + dayHeight);
        path = [NSBezierPath bezierPathWithRect:verticalColumnLine];
        [color set];
        [path fill];
    }
}


@end
