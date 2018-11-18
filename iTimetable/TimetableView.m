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
#define titleHeight 60
#define dayHeight 1000

@implementation TimetableView

- (BOOL)isFlipped{
    return YES;
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    NSRect horizonLine = NSMakeRect(origin.x, origin.y, 7 * dayWidth, 1);
    
    
    NSBezierPath *path;
    
    path=[NSBezierPath bezierPathWithRect:horizonLine];
    
    
    
    //bezierPathWithOvalInRect 画椭圆
    
    //用颜色填充矩形
    
    //NSColor *theColor=[NSColor grayColor];
    
    //[theColor set];
    
    [path fill];
}


@end
