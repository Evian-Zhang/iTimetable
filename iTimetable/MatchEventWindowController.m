//
//  MatchEventWindowController.m
//  iTimetable
//
//  Created by Evian张 on 2018/11/16.
//  Copyright © 2018 Evian张. All rights reserved.
//

#import "MatchEventWindowController.h"

@interface MatchEventWindowController ()

@end

@implementation MatchEventWindowController
@synthesize eventStore = _eventStore;
@synthesize events = _events;
@synthesize calendar = _calendar;
@synthesize firstWeek = _firstWeek;
@synthesize courseName = _courseName;
@synthesize row = _row;

- (void)windowDidLoad {
    [super windowDidLoad];
    
    self.window.displayButton.target = self;
    self.window.displayButton.action = @selector(displayButtonHandler);
    
    self.window.okButton.target = self;
    self.window.okButton.action = @selector(okButtonHandler);
    self.window.okButton.keyEquivalent = @"\r";
    
    self.window.cancelButton.target = self;
    self.window.cancelButton.action = @selector(cancelButtonHandler);
    
    self.window.eventTable.delegate = self;
    self.window.eventTable.dataSource = self;
    
    self.window.datePicker.dateValue = [NSDate date];
    
    self.events = [NSArray array];
}

- (void)displayButtonHandler{
    NSDate *startDate = self.window.datePicker.dateValue;
    NSDateComponents *tmpDateComponents = [[NSDateComponents alloc] init];
    tmpDateComponents.day = 1;
    NSDate *endDate = [[NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian] dateByAddingComponents:tmpDateComponents toDate:startDate options:0];
    NSArray *calendars = @[self.calendar];
    NSPredicate *predicate = [self.eventStore predicateForEventsWithStartDate:startDate endDate:endDate calendars:calendars];
    self.events = [[self.eventStore eventsMatchingPredicate:predicate] sortedArrayUsingSelector:@selector(compareStartDateWithEvent:)];
    [self.window.eventTable reloadData];
}

- (void)okButtonHandler{
    BOOL isValid = YES;
    NSString *warningText = [NSString string];
    EZCourseInfo *eventCourseInfo = [[EZCourseInfo alloc] init];
    if (self.window.eventTable.selectedRow < 0) {
        isValid = NO;
        warningText = [warningText stringByAppendingString:@"请选择一起事件！\n"];
    } else {
        EKEvent *event = self.events[self.window.eventTable.selectedRow];
        if (event.recurrenceRules.count == 0) {
            isValid = NO;
            warningText = [warningText stringByAppendingString:@"请选择一起重复事件！\n"];
        } else {
            EKRecurrenceRule *recurrenceRule = event.recurrenceRules[0];
            int occurrenceCount = recurrenceRule.recurrenceEnd.occurrenceCount;
            if (recurrenceRule.frequency != EKRecurrenceFrequencyWeekly) {
                isValid = NO;
                warningText = [warningText stringByAppendingString:@"重复事件的重复形式不符合！\n"];
            } else {
                NSDateComponents *tmpComponents = [[NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian] components:NSCalendarUnitDay fromDate:self.firstWeek toDate:event.occurrenceDate options:0];
                int weeksFirst = (tmpComponents.day) / 7 + 1;
                //NSNumber *tmpCourseFirstWeek = self.weeks[0];
                NSDateComponents *tmpDateComponents = [[NSDateComponents alloc] init];
                tmpDateComponents.day = 7 * (weeksFirst - 1);
                NSCalendar *gregorian = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
                NSDate *courseFirstDate = [gregorian dateByAddingComponents:tmpDateComponents toDate:self.firstWeek options:0];
                NSDateComponents *dateComponents = [gregorian components:NSCalendarUnitDay fromDate:courseFirstDate toDate:event.occurrenceDate options:0];
                eventCourseInfo.day = dateComponents.day;
                if (recurrenceRule.interval == 1) {
                    NSMutableArray *tmpArray = [NSMutableArray array];
                    for (int count = 0; count < occurrenceCount; count++) {
                        [tmpArray addObject:[NSNumber numberWithInt:weeksFirst + count]];
                    }
                    eventCourseInfo.weeks = [NSMutableArray arrayWithArray:tmpArray];
                } else if (recurrenceRule.interval == 2) {
                    NSMutableArray *tmpArray = [NSMutableArray array];
                    for (int count = 0; count < occurrenceCount; count++) {
                        [tmpArray addObject:[NSNumber numberWithInt:weeksFirst + 2 * count]];
                    }
                    eventCourseInfo.weeks = [NSMutableArray arrayWithArray:tmpArray];
                } else {
                    isValid = NO;
                    warningText = [warningText stringByAppendingString:@"重复事件的重复形式不符合！\n"];
                }
            }
        }
        eventCourseInfo.firstWeek = self.firstWeek;
        eventCourseInfo.startTime = event.occurrenceDate;
        NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
        NSCalendar *gregorian = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
        dateComponents.year = [gregorian component:NSCalendarUnitYear fromDate:eventCourseInfo.startTime];
        dateComponents.month = [gregorian component:NSCalendarUnitMonth fromDate:eventCourseInfo.startTime];
        dateComponents.day = [gregorian component:NSCalendarUnitDay fromDate:eventCourseInfo.startTime];
        dateComponents.hour = [gregorian component:NSCalendarUnitHour fromDate:event.endDate];
        dateComponents.minute = [gregorian component:NSCalendarUnitMinute fromDate:event.endDate];
        dateComponents.second = [gregorian component:NSCalendarUnitSecond fromDate:event.endDate];
        eventCourseInfo.endTime = [gregorian dateFromComponents:dateComponents];
        
        NSString *room = event.structuredLocation.title;
        if (room.length > 0) {
            eventCourseInfo.room = room;
        } else {
            eventCourseInfo.room = [NSString string];
        }
        
        NSString *title = event.title;
        if (![title hasPrefix:self.courseName]){
            isValid = NO;
            warningText = [warningText stringByAppendingString:@"事件名和课程名不符！\n"];
        }
        if ([title containsString:@"（教师："]) {
            NSArray *titles = [title componentsSeparatedByString:@"（教师："];
            if (titles.count < 2) {
                isValid = NO;
                warningText = [warningText stringByAppendingString:@"事件名中教师括号不匹配！\n"];
                eventCourseInfo.teacher = [NSString string];
            } else {
                NSString *teacher = titles[1];
                if ([teacher hasSuffix:@"）"]) {
                    teacher = [teacher substringWithRange:NSMakeRange(0, teacher.length - 1)];
                } else {
                    isValid = NO;
                    warningText = [warningText stringByAppendingString:@"事件名中教师括号不匹配！\n"];
                    eventCourseInfo.teacher = [NSString string];
                }
            }
        } else {
            eventCourseInfo.teacher = [NSString string];
        }
        
        if ([event hasAlarms]) {
            eventCourseInfo.hasAlarm = YES;
            eventCourseInfo.relativeOffset = event.alarms[0].relativeOffset;
        }
        
        eventCourseInfo.eventIdentifier = event.eventIdentifier;
        
    }
    if (isValid) {
        NSDictionary *userInfo = @{@"courseInfo": eventCourseInfo, @"row": [NSNumber numberWithInt:self.row]};
        [[NSNotificationCenter defaultCenter] postNotificationName:@"EZCourseInfoMatchSuccessfully" object:nil userInfo:userInfo];
        [self cancelButtonHandler];
    } else {
        NSAlert *alert = [NSAlert new];
        [alert addButtonWithTitle:@"确定"];
        [alert setMessageText:@"错误"];
        [alert setInformativeText:warningText];
        [alert setAlertStyle:NSAlertStyleWarning];
        [alert beginSheetModalForWindow:self.window completionHandler:^(NSModalResponse returnCode) {}];
    }
}

- (void)cancelButtonHandler{
    [NSApp stopModal];
    [self.window close];
}

- (void)windowWillClose:(NSNotification *)notification{
    [NSApp stopModal];
}

#pragma mark - conform <NSTableViewDelegate>, <NSTableViewDataSource>
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView{
    return self.events.count;
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
    EKEvent *event = self.events[row];
    NSString *cellIdentifier;
    NSString *cellText;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"HH:mm:ss";
    if (tableColumn == tableView.tableColumns[0]) {
        cellIdentifier = @"EZMatchEventTableTitleID";
        cellText = event.title;
    } else if (tableColumn == tableView.tableColumns[1]) {
        cellIdentifier = @"EZMatchEventTableStartTimeID";
        cellText = [dateFormatter stringFromDate:event.startDate];
    } else {
        cellIdentifier = @"EZMatchEventTableEndTimeID";
        cellText = [dateFormatter stringFromDate:event.endDate];
    }
    NSTableCellView *tableCellView = [tableView makeViewWithIdentifier:cellIdentifier owner:nil];
    if(cellText.length > 0){
        tableCellView.textField.stringValue = cellText;
    }
    return tableCellView;
}

@end
