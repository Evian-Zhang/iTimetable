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
@synthesize warningText = _warningText;

- (void)windowDidLoad {
    [super windowDidLoad];
    for(int week = 0; week < self.courseInfo.semesterLength; week++){
        [self.window.startWeekPop addItemWithTitle:[NSString stringWithFormat:@"第%d周", week + 1]];
        [self.window.endWeekPop addItemWithTitle:[NSString stringWithFormat:@"第%d周", week + 1]];
    }
    
    [self.window.weekPop addItemsWithTitles:@[@"周一", @"周二", @"周三", @"周四", @"周五", @"周六", @"周日"]];
    
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
    self.warningText = [NSString string];
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
    if([self checkValidation]){
        if([self.window.singleDoublePicker.selectedItem.title isEqualToString:@"每周"]){
            for(int week = self.window.startWeekPop.indexOfSelectedItem; week <= self.window.endWeekPop.indexOfSelectedItem; week++){
                [self.courseInfo.weeks addObject:[NSNumber numberWithInt:week + 1]];
            }
        } else if([self.window.singleDoublePicker.selectedItem.title isEqualToString:@"双周"]){
            for(int week = self.window.startWeekPop.indexOfSelectedItem; week <= self.window.endWeekPop.indexOfSelectedItem; week++){
                if((week + 1) % 2 == 0){
                    [self.courseInfo.weeks addObject:[NSNumber numberWithInt:week + 1]];
                }
            }
        } else {
            for(int week = self.window.startWeekPop.indexOfSelectedItem; week <= self.window.endWeekPop.indexOfSelectedItem; week++){
                if((week + 1) % 2 == 1){
                    [self.courseInfo.weeks addObject:[NSNumber numberWithInt:week + 1]];
                }
            }
        }
        
        NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
        
        NSDateComponents *tmpDateComponents = [[NSDateComponents alloc] init];
        NSNumber *tmpCourseFirstWeek = self.courseInfo.weeks[0];
        self.courseInfo.day = self.window.weekPop.indexOfSelectedItem;
        tmpDateComponents.day = 7 * tmpCourseFirstWeek.intValue + self.courseInfo.day;
        
        NSDate *courseFirstDate = [calendar nextDateAfterDate:self.courseInfo.firstWeek matchingComponents:tmpDateComponents options:NSCalendarMatchFirst];
        
        NSDate *startTime = self.window.startTimePicker.dateValue;
        NSDateComponents *startTimeComponents = [[NSDateComponents alloc] init];
        startTimeComponents.year = [calendar component:NSCalendarUnitYear fromDate:courseFirstDate];
        startTimeComponents.month = [calendar component:NSCalendarUnitMonth fromDate:courseFirstDate];
        startTimeComponents.day = [calendar component:NSCalendarUnitDay fromDate:courseFirstDate];
        startTimeComponents.hour = [calendar component:NSCalendarUnitHour fromDate:startTime];
        startTimeComponents.minute = [calendar component:NSCalendarUnitMinute fromDate:startTime];
        startTimeComponents.second = [calendar component:NSCalendarUnitSecond fromDate:startTime];
        self.courseInfo.startTime = [calendar dateFromComponents:startTimeComponents];
        
        NSDate *endTime = self.window.endTimePicker.dateValue;
        NSDateComponents *endTimeComponents = [[NSDateComponents alloc] init];
        endTimeComponents.year = [calendar component:NSCalendarUnitYear fromDate:courseFirstDate];
        endTimeComponents.month = [calendar component:NSCalendarUnitMonth fromDate:courseFirstDate];
        endTimeComponents.day = [calendar component:NSCalendarUnitDay fromDate:courseFirstDate];
        endTimeComponents.hour = [calendar component:NSCalendarUnitHour fromDate:endTime];
        endTimeComponents.minute = [calendar component:NSCalendarUnitMinute fromDate:endTime];
        endTimeComponents.second = [calendar component:NSCalendarUnitSecond fromDate:endTime];
        self.courseInfo.endTime = [calendar dateFromComponents:endTimeComponents];
        self.courseInfo.room = self.window.roomText.stringValue;
        self.courseInfo.teacher = self.window.teacherText.stringValue;
        [self.courseInfo.weeks removeAllObjects];
        if(self.window.alarmBtn.state == NSControlStateValueOn){
            self.courseInfo.hasAlarm = YES;
            if([self.window.alarmTypePop.selectedItem.title isEqualToString:@"日程发生时"]){
                self.courseInfo.relativeOffset = 0;
            } else if([self.window.alarmTypePop.selectedItem.title isEqualToString:@"分钟前"]){
                self.courseInfo.relativeOffset = -self.window.alarmTimeText.doubleValue * 60;
            } else {
                self.courseInfo.relativeOffset = -self.window.alarmTimeText.doubleValue * 3600;
            }
        } else {
            self.courseInfo.hasAlarm = NO;
        }
        NSDictionary *userInfo = @{@"courseInfo": self.courseInfo};
        [[NSNotificationCenter defaultCenter] postNotificationName:@"EZCourseInfoGetSuccessfully" object:nil userInfo:userInfo];
        [self cancelBtnHandler];
    } else {
        NSAlert *alert = [NSAlert new];
        [alert addButtonWithTitle:@"确定"];
        [alert setMessageText:@"错误"];
        [alert setInformativeText:self.warningText];
        [alert setAlertStyle:NSAlertStyleWarning];
        [alert beginSheetModalForWindow:self.window completionHandler:^(NSModalResponse returnCode) {}];
    }
}

- (void)cancelBtnHandler{
    [NSApp stopModal];
    [self.window close];
}

- (void)windowWillClose:(NSNotification *)notification{
    [NSApp stopModal];
}

- (BOOL)checkValidation{
    BOOL isValid = YES;
    if([self.window.startTimePicker.dateValue compare:self.window.endTimePicker.dateValue] != NSOrderedAscending){
        isValid = NO;
        self.warningText = [self.warningText stringByAppendingString:@"上课时间需早于下课时间。\n"];
    }
    if(self.window.startWeekPop.indexOfSelectedItem >= self.window.endWeekPop.indexOfSelectedItem){
        isValid = NO;
        self.warningText = [self.warningText stringByAppendingString:@"开始周需早于结束周。\n"];
    }
    return isValid;
}

@end
