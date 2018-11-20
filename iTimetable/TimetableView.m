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
@synthesize courseInfos = _courseInfos;
@synthesize dayLength = dayLength;
@synthesize firstClassTime = _firstClassTime;
@synthesize courseInfoViews = _courseInfoViews;

- (BOOL)isFlipped{
    return YES;
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    [self drawTimetableFrame];
    [self drawTimetableCourseInfo];
}

- (void)draw:(NSRect)rect {
    NSBezierPath *path;
    path = [NSBezierPath bezierPathWithRect:rect];
    [[NSColor controlTextColor] set];
    [path fill];
}

- (void)drawTimetableFrame {
    NSRect horizonTopLine = NSMakeRect(origin.x, origin.y, 7 * dayWidth, 1);
    [self draw:horizonTopLine];
    
    NSRect horizonMidLine = NSMakeRect(origin.x, origin.y + titleHeight, 7 * dayWidth, 1);
    [self draw:horizonMidLine];
    
    NSRect horizonBottomLine = NSMakeRect(origin.x, origin.y + titleHeight + dayHeight, 7 * dayWidth, 1);
    [self draw:horizonBottomLine];
    
    NSRect verticalLeftLine = NSMakeRect(origin.x, origin.y, 1, titleHeight + dayHeight);
    [self draw:verticalLeftLine];
    
    for (int column = 1; column <= 7; column++) {
        NSRect verticalColumnLine = NSMakeRect(origin.x + column * dayWidth, origin.y, 1, titleHeight + dayHeight);
        [self draw:verticalColumnLine];
    }
    
    NSTextField *mondayTextField = [[NSTextField alloc] initWithFrame:NSMakeRect(origin.x, origin.y, dayWidth, titleHeight)];
    mondayTextField.cell = [[EZTextFieldCell alloc] initTextCell:@"星期一"];
    mondayTextField.drawsBackground = NO;
    mondayTextField.editable = NO;
    mondayTextField.selectable = NO;
    mondayTextField.bordered = NO;
    mondayTextField.alignment = NSTextAlignmentCenter;
    [self addSubview:mondayTextField];
    
    NSTextField *tuesdayTextField = [[NSTextField alloc] initWithFrame:NSMakeRect(origin.x + dayWidth, origin.y, dayWidth, titleHeight)];
    tuesdayTextField.cell = [[EZTextFieldCell alloc] initTextCell:@"星期二"];
    tuesdayTextField.drawsBackground = NO;
    tuesdayTextField.editable = NO;
    tuesdayTextField.selectable = NO;
    tuesdayTextField.bordered = NO;
    tuesdayTextField.alignment = NSTextAlignmentCenter;
    [self addSubview:tuesdayTextField];
    
    NSTextField *wensdayTextField = [[NSTextField alloc] initWithFrame:NSMakeRect(origin.x + 2 * dayWidth, origin.y, dayWidth, titleHeight)];
    wensdayTextField.cell = [[EZTextFieldCell alloc] initTextCell:@"星期三"];
    wensdayTextField.drawsBackground = NO;
    wensdayTextField.editable = NO;
    wensdayTextField.selectable = NO;
    wensdayTextField.bordered = NO;
    wensdayTextField.alignment = NSTextAlignmentCenter;
    [self addSubview:wensdayTextField];
    
    NSTextField *thursdayTextField = [[NSTextField alloc] initWithFrame:NSMakeRect(origin.x + 3 * dayWidth, origin.y, dayWidth, titleHeight)];
    thursdayTextField.cell = [[EZTextFieldCell alloc] initTextCell:@"星期四"];
    thursdayTextField.drawsBackground = NO;
    thursdayTextField.editable = NO;
    thursdayTextField.selectable = NO;
    thursdayTextField.bordered = NO;
    thursdayTextField.alignment = NSTextAlignmentCenter;
    [self addSubview:thursdayTextField];
    
    NSTextField *fridayTextField = [[NSTextField alloc] initWithFrame:NSMakeRect(origin.x + 4 * dayWidth, origin.y, dayWidth, titleHeight)];
    fridayTextField.cell = [[EZTextFieldCell alloc] initTextCell:@"星期五"];
    fridayTextField.drawsBackground = NO;
    fridayTextField.editable = NO;
    fridayTextField.selectable = NO;
    fridayTextField.bordered = NO;
    fridayTextField.alignment = NSTextAlignmentCenter;
    [self addSubview:fridayTextField];
    
    NSTextField *saturdayTextField = [[NSTextField alloc] initWithFrame:NSMakeRect(origin.x + 5 * dayWidth, origin.y, dayWidth, titleHeight)];
    saturdayTextField.cell = [[EZTextFieldCell alloc] initTextCell:@"星期六"];
    saturdayTextField.drawsBackground = NO;
    saturdayTextField.editable = NO;
    saturdayTextField.selectable = NO;
    saturdayTextField.bordered = NO;
    saturdayTextField.alignment = NSTextAlignmentCenter;
    [self addSubview:saturdayTextField];
    
    NSTextField *sundayTextField = [[NSTextField alloc] initWithFrame:NSMakeRect(origin.x + 6 * dayWidth, origin.y, dayWidth, titleHeight)];
    sundayTextField.cell = [[EZTextFieldCell alloc] initTextCell:@"星期日"];
    sundayTextField.drawsBackground = NO;
    sundayTextField.editable = NO;
    sundayTextField.selectable = NO;
    sundayTextField.bordered = NO;
    sundayTextField.alignment = NSTextAlignmentCenter;
    [self addSubview:sundayTextField];
}

- (void)drawTimetableCourseInfo {
    for (int day = 0; day < 7; day++) {
        for (CourseInfo *courseInfo in self.courseInfos[day]) {
            double startTime = [self computerHourForDate:courseInfo.startTime] - [self computerHourForDate:self.firstClassTime];
            double endTime = [self computerHourForDate:courseInfo.endTime] - [self computerHourForDate:self.firstClassTime];
            double courseTime = endTime - startTime;
            if (self.dayLength != 0) {
                NSRect courseTopLine = NSMakeRect(origin.x + day * dayWidth, origin.y + titleHeight + dayHeight * startTime / self.dayLength, dayWidth, 1);
                [self draw:courseTopLine];
                
                NSRect courseBottomLine = NSMakeRect(origin.x + day * dayWidth, origin.y + titleHeight + dayHeight * endTime / self.dayLength, dayWidth, 1);
                [self draw:courseBottomLine];
                
                NSTextField *courseTextField = [[NSTextField alloc] initWithFrame:NSMakeRect(origin.x + day * dayWidth, origin.y + titleHeight + dayHeight * startTime / self.dayLength, dayWidth, dayHeight * courseTime / self.dayLength)];
                courseTextField.cell = [[EZTextFieldCell alloc] initTextCell:courseInfo.courseName];
                courseTextField.drawsBackground = NO;
                courseTextField.editable = NO;
                courseTextField.selectable = NO;
                courseTextField.bordered = NO;
                courseTextField.alignment = NSTextAlignmentCenter;
                [self addSubview:courseTextField];
                [self.courseInfoViews addObject:courseTextField];
            }
        }
    }
}

- (double)computerHourForDate:(NSDate*)date {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    int hour = [calendar component:NSCalendarUnitHour fromDate:date];
    int minute = [calendar component:NSCalendarUnitMinute fromDate:date];
    int second = [calendar component:NSCalendarUnitSecond fromDate:date];
    return hour + minute / (double)60 + second / (double)3600;
}


@end
