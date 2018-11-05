//
//  Timetable.m
//  iTimetable
//
//  Created by Evian张 on 2018/11/4.
//  Copyright © 2018 Evian张. All rights reserved.
//

#import "EZTimetable.h"

@implementation EZTimetable
@synthesize courses = _courses;
@synthesize firstClassTime = _firstClassTime;
@synthesize firstWeek = _firstWeek;
@synthesize lastClassTime = _lastClassTime;
@synthesize semesterLength = _semesterLength;
@synthesize calendarIdentifier = _calendarIdentifier;

- (instancetype)init{
    if(self = [super init]){
        self.courses = [NSMutableArray array];
        NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
        NSDate *today = [NSDate date];
        NSDateComponents *todayComponent = [[NSDateComponents alloc] init];
        todayComponent.year = [calendar component:NSCalendarUnitYear fromDate:today];
        todayComponent.month = [calendar component:NSCalendarUnitMonth fromDate:today];
        todayComponent.day = [calendar component:NSCalendarUnitDay fromDate:today];
        
        todayComponent.hour = 0;
        todayComponent.minute = 0;
        todayComponent.second = 0;
        self.firstWeek = [calendar dateFromComponents:todayComponent];
        
        todayComponent.hour = 8;
        self.firstClassTime = [calendar dateFromComponents:todayComponent];
        
        todayComponent.hour = 22;
        self.lastClassTime = [calendar dateFromComponents:todayComponent];
        
        self.semesterLength = 16;
        
        self.calendarIdentifier = [NSString string];
        
        self.sourceIdentifier = [NSString string];
        
        return self;
    }
    return nil;
}

@end
