//
//  EZCourseInfo.m
//  iTimetable
//
//  Created by Evian张 on 2018/11/7.
//  Copyright © 2018 Evian张. All rights reserved.
//

#import "EZCourseInfo.h"

@implementation EZCourseInfo
@synthesize startTime = _startTime;
@synthesize endTime = _endTime;
@synthesize weeks = _weeks;
@synthesize room = _room;
@synthesize teacher = _teacher;
@synthesize eventIdentifier = _eventIdentifier;
@synthesize firstWeek = _firstWeek;
@synthesize semesterLength = _semesterLength;
@synthesize isChanged = _isChanged;
@synthesize hasAlarm = _hasAlarm;
@synthesize relativeOffset = _relativeOffset;
@synthesize day = _day;
@synthesize status = _status;

- (instancetype)initWithFirstWeek:(NSDate*)firstWeek semesterLength:(int)semesterLength{
    if(self = [super init]){
        self.firstWeek = firstWeek;
        self.semesterLength = semesterLength;
        
        NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents *firstWeekComponent = [[NSDateComponents alloc] init];
        firstWeekComponent.year = [calendar component:NSCalendarUnitYear fromDate:self.firstWeek];
        firstWeekComponent.month = [calendar component:NSCalendarUnitMonth fromDate:self.firstWeek];
        firstWeekComponent.day = [calendar component:NSCalendarUnitDay fromDate:self.firstWeek];
        
        firstWeekComponent.hour = 8;
        firstWeekComponent.minute = 0;
        firstWeekComponent.second = 0;
        self.startTime = [calendar dateFromComponents:firstWeekComponent];
        
        firstWeekComponent.minute = 40;
        self.endTime = [calendar dateFromComponents:firstWeekComponent];
        
        self.weeks = [NSMutableArray array];
        for(int week = 1; week <= self.semesterLength; week++){
            [self.weeks addObject:[NSNumber numberWithInt:week]];
        }
        
        self.room = [NSString string];
        
        self.teacher = [NSString string];
        
        self.eventIdentifier = [NSString string];
        
        self.isChanged = YES;
        
        self.hasAlarm = YES;
        
        self.relativeOffset = -1200;
        
        self.status = EZCourseStatusWillCreate;
        return self;
    }
    return nil;
}
/*
- (instancetype)init{
    if(self = [super init]){
        self.firstWeek = [NSDate date];
        
        self.startTime = [NSDate date];
        
        self.endTime = [NSDate date];
        
        self.semesterLength = 0;
        
        self.weeks = [NSMutableArray array];
        
        self.room = [NSString string];
        
        self.teacher = [NSString string];
        
        self.eventIdentifier = [NSString string];
        
        self.isChanged = NO;
        
        self.hasAlarm = YES;
        
        self.day = 0;
        
        self.status = EZCourseStatusWillCreate;
        return self;
    }
    return nil;
}
*/
@end
