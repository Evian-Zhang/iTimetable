//
//  CoreseInfoWindowController.m
//  iTimetable
//
//  Created by Evian张 on 2018/11/8.
//  Copyright © 2018 Evian张. All rights reserved.
//

#import "CourseInfoWindowController.h"

@interface CourseInfoWindowController ()

@end

@implementation CourseInfoWindowController
@synthesize courseInfo = _courseInfo;
@synthesize hasAlarm = _hasAlarm;

- (void)windowDidLoad {
    [super windowDidLoad];
    for(int week = 0; week < self.courseInfo.semesterLength; week++){
        [self.window.startWeekPop addItemWithTitle:[NSString stringWithFormat:@"第%d周", week + 1]];
        [self.window.endWeekPop addItemWithTitle:[NSString stringWithFormat:@"第%d周", week + 1]];
    }
    NSNumber *startWeek = self.courseInfo.weeks[0];
    [self.window.startWeekPop selectItemWithTitle:[NSString stringWithFormat:@"第%d周", startWeek.intValue]];
    NSNumber *endWeek = [self.courseInfo.weeks lastObject];
    [self.window.endWeekPop selectItemWithTitle:[NSString stringWithFormat:@"第%d周", endWeek.intValue]];
    
    [self.window.singleDoublePicker addItemsWithTitles:@[@"每周", @"单周", @"双周"]];
    
    if(self.courseInfo.weeks.count == 1){
        [self.window.singleDoublePicker selectItemWithTitle:@"每周"];
    } else if([self.courseInfo.weeks containsObject:[NSNumber numberWithInt:startWeek.intValue + 1]]){
        [self.window.singleDoublePicker selectItemWithTitle:@"每周"];
    } else if(startWeek.intValue % 2 == 0){
        [self.window.singleDoublePicker selectItemWithTitle:@"双周"];
    } else {
        [self.window.singleDoublePicker selectItemWithTitle:@"单周"];
    }
    
    [self.window.alarmTypePop addItemsWithTitles:@[@"日程发生时", @"分钟前", @"小时前"]];
    self.window.alarmTypePop.target = self;
    self.window.alarmTypePop.action = @selector(alarmTypePopHandler);
    
    self.window.alarmBtn.target = self;
    self.window.alarmBtn.action = @selector(alarmBtnHandler);
    
    self.window.okBtn.target = self;
    self.window.okBtn.action = @selector(okBtnHandler);
    
    self.window.cancelBtn.target = self;
    self.window.cancelBtn.action = @selector(cancelBtnHandler);
    
    self.window.roomText.stringValue = self.courseInfo.room;
    self.window.teacherText.stringValue = self.courseInfo.teacher;
    self.window.startTimePicker.dateValue = self.courseInfo.startTime;
    self.window.endTimePicker.dateValue = self.courseInfo.endTime;
    
    if(self.courseInfo.hasAlarm){
        self.window.alarmBtn.state = NSControlStateValueOn;
        self.window.alarmTimeText.enabled = YES;
        self.window.alarmTypePop.enabled = YES;
        if(self.courseInfo.relativeOffset == 0){
            self.window.alarmTimeText.hidden = YES;
            [self.window.alarmTypePop selectItemWithTitle:@"日程发生时"];
        } else if(-self.courseInfo.relativeOffset < 3600){
            self.window.alarmTimeText.hidden = NO;
            self.window.alarmTimeText.doubleValue = -self.courseInfo.relativeOffset / 60;
            [self.window.alarmTypePop selectItemWithTitle:@"分钟前"];
        } else {
            self.window.alarmTimeText.hidden = NO;
            self.window.alarmTimeText.doubleValue = -self.courseInfo.relativeOffset / 3600;
            [self.window.alarmTypePop selectItemWithTitle:@"小时前"];
        }
    } else {
        self.window.alarmBtn.state = NSControlStateValueOff;
        self.window.alarmTimeText.enabled = NO;
        self.window.alarmTypePop.enabled = NO;
    }
}

- (void)alarmBtnHandler{
    self.hasAlarm = self.window.alarmBtn.state;
    if(self.hasAlarm){
        self.window.alarmTimeText.enabled = YES;
        self.window.alarmTypePop.enabled = YES;
    } else {
        self.window.alarmTimeText.enabled = NO;
        self.window.alarmTypePop.enabled = NO;
    }
}

- (void)alarmTypePopHandler{
    if([self.window.alarmTypePop.selectedItem.title isEqualToString:@"日程发生时"]){
        self.window.alarmTimeText.hidden = YES;
    } else {
        self.window.alarmTimeText.hidden = NO;
    }
}

- (void)okBtnHandler{
    
}

- (void)cancelBtnHandler{
    
}

@end
