//
//  TimetableInfoWindowController.m
//  iTimetable
//
//  Created by Evian张 on 2018/11/3.
//  Copyright © 2018 Evian张. All rights reserved.
//

#import "TimetableInfoWindowController.h"

@interface TimetableInfoWindowController ()

@property (weak) IBOutlet TimetableInfoWindow *window;

@end

@implementation TimetableInfoWindowController
@synthesize storeModel = _storeModel;
@synthesize selectedSource = _selectedSource;
@synthesize selectedCalendar = _selectedCalendar;
@synthesize timetable = _timetable;
@synthesize warningText = _warningText;
@synthesize isCreating = _isCreating;

- (void)windowDidLoad {
    [super windowDidLoad];
    [self.window.okBtn setKeyEquivalent:@"\r"];
    self.window.okBtn.target = self;
    self.window.okBtn.action = @selector(okBtnHandler);
    self.window.cancelBtn.target = self;
    self.window.cancelBtn.action = @selector(cancelBtnHandler);
    
    self.window.firstWeekPicker.dateValue = self.timetable.firstWeek;
    self.window.semesterLengthText.intValue = self.timetable.semesterLength;
    self.window.firstClassPicker.dateValue = self.timetable.firstClassTime;
    self.window.lastClassPicker.dateValue = self.timetable.lastClassTime;
    
    if (!self.isCreating) {
        self.window.firstWeekPicker.enabled = NO;
        self.window.semesterLengthText.enabled = NO;
        self.window.sourcePop.enabled = NO;
        self.window.firstClassPicker.enabled = NO;
        self.window.lastClassPicker.enabled = NO;
    }
    
    self.warningText = [NSString string];
}

- (void)okBtnHandler{
    if([self checkValidation]){
        NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
        
        NSDate *firstWeek = self.window.firstWeekPicker.dateValue;
        NSDateComponents *firstWeekComponents = [[NSDateComponents alloc] init];
        firstWeekComponents.year = [calendar component:NSCalendarUnitYear fromDate:firstWeek];
        firstWeekComponents.month = [calendar component:NSCalendarUnitMonth fromDate:firstWeek];
        firstWeekComponents.day = [calendar component:NSCalendarUnitDay fromDate:firstWeek];
        firstWeekComponents.hour = 0;
        firstWeekComponents.minute = 0;
        firstWeekComponents.second = 0;
        self.timetable.firstWeek = [calendar dateFromComponents:firstWeekComponents];
        
        self.timetable.semesterLength = self.window.semesterLengthText.intValue;
        
        NSDate *firstClass = self.window.firstClassPicker.dateValue;
        NSDateComponents *firstClassComponents = [[NSDateComponents alloc] init];
        firstClassComponents.year = firstWeekComponents.year;
        firstClassComponents.month = firstWeekComponents.month;
        firstClassComponents.day = firstWeekComponents.day;
        firstClassComponents.hour = [calendar component:NSCalendarUnitHour fromDate:firstClass];
        firstClassComponents.minute = [calendar component:NSCalendarUnitMinute fromDate:firstClass];
        firstClassComponents.second = [calendar component:NSCalendarUnitSecond fromDate:firstClass];
        self.timetable.firstClassTime = [calendar dateFromComponents:firstClassComponents];
        
        NSDate *lastClass = self.window.lastClassPicker.dateValue;
        NSDateComponents *lastClassComponents = [[NSDateComponents alloc] init];
        lastClassComponents.year = firstWeekComponents.year;
        lastClassComponents.month = firstWeekComponents.month;
        lastClassComponents.day = firstWeekComponents.day;
        lastClassComponents.hour = [calendar component:NSCalendarUnitHour fromDate:lastClass];
        lastClassComponents.minute = [calendar component:NSCalendarUnitMinute fromDate:lastClass];
        lastClassComponents.second = [calendar component:NSCalendarUnitSecond fromDate:lastClass];
        self.timetable.lastClassTime = [calendar dateFromComponents:lastClassComponents];
        NSDictionary *userInfo = @{@"timetable": self.timetable, @"isCreating": [NSNumber numberWithBool:self.isCreating]};
        [[NSNotificationCenter defaultCenter] postNotificationName:@"EZTimetableGetSuccessfully" object:nil userInfo:userInfo];
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

- (BOOL)checkValidation{
    BOOL isValid = YES;
    self.warningText = [NSString string];
    NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *component = [calendar components:NSCalendarUnitWeekday fromDate:self.window.firstWeekPicker.dateValue];
    if(component.weekday != 2){
        isValid = NO;
        NSString *weekDayInvalid = @"输入的第一周周一非周一！\n";
        self.warningText = [self.warningText stringByAppendingString:weekDayInvalid];
    }
    if(self.window.semesterLengthText.intValue <= 0){
        isValid = NO;
        NSString *semesterLengthInvalid = @"请输入正确的周数！\n";
        self.warningText = [self.warningText stringByAppendingString:semesterLengthInvalid];
    }
    if([self.window.firstClassPicker.dateValue compare:self.window.lastClassPicker.dateValue] != NSOrderedAscending){
        isValid = NO;
        NSString *classTimeInvalid = @"请输入正确的课程开始、结束时间！\n";
        self.warningText = [self.warningText stringByAppendingString:classTimeInvalid];
    }
    return isValid;
}

- (void)cancelBtnHandler{
    [NSApp stopModal];
    [self.window close];
}

- (void)windowWillClose:(NSNotification *)notification{
    [NSApp stopModal];
}

@end
