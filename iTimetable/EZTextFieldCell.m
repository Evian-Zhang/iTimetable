//
//  EZTextFieldCell.m
//  iTimetable
//
//  Created by Evian张 on 2018/11/19.
//  Copyright © 2018 Evian张. All rights reserved.
//

#import "EZTextFieldCell.h"

@implementation EZTextFieldCell

- (NSRect)titleRectForBounds:(NSRect)frame {
    
    CGFloat stringHeight = self.attributedStringValue.size.height;
    NSRect titleRect = [super titleRectForBounds:frame];
    titleRect.origin.y = frame.origin.y + (frame.size.height - stringHeight) / 2.0;
    return titleRect;
}
- (void)drawInteriorWithFrame:(NSRect)cFrame inView:(NSView*)cView {
    [super drawInteriorWithFrame:[self titleRectForBounds:cFrame] inView:cView];
}

@end
