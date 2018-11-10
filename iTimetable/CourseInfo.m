//
//  CourseInfo.m
//  iTimetable
//
//  Created by Evian张 on 2018/11/2.
//  Copyright © 2018 Evian张. All rights reserved.
//

#import "CourseInfo.h"

@implementation CourseInfo
@synthesize startTime = _startTime;
@synthesize endTime = _endTime;
@synthesize weeks = _weeks;
@synthesize room = _room;
@synthesize teacher = _teacher;
@synthesize eventIdentifier = _eventIdentifier;

- (int)dayWithFirstWeek:(NSDate *)firstWeek{
    NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    if(self.weeks.count > 0){
        NSNumber *tmpCourseFirstWeek = self.weeks[0];
        NSDateComponents *tmpDateComponents = [[NSDateComponents alloc] init];
        tmpDateComponents.day = 7 * tmpCourseFirstWeek.intValue;

        NSDate *courseFirstDate = [calendar nextDateAfterDate:firstWeek matchingComponents:tmpDateComponents options:NSCalendarMatchFirst];
        dateComponents = [calendar components:NSCalendarUnitDay fromDate:courseFirstDate toDate:self.startTime options:NSCalendarMatchFirst];
        return dateComponents.day;
    }
    return 0;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    
    [aCoder encodeObject:self.startTime forKey:@"startTime"];
    [aCoder encodeObject:self.endTime forKey:@"endTime"];
    [aCoder encodeObject:self.weeks forKey:@"weeks"];
    [aCoder encodeObject:self.room forKey:@"room"];
    [aCoder encodeObject:self.teacher forKey:@"teacher"];
    [aCoder encodeObject:self.eventIdentifier forKey:@"eventIdentifier"];
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [[self class] new];
    if (self = [super init])
    {
        self.startTime = [aDecoder decodeObjectForKey:@"startTime"];
        self.endTime = [aDecoder decodeObjectForKey:@"endTime"];
        self.weeks = [aDecoder decodeObjectForKey:@"weeks"];
        self.room = [aDecoder decodeObjectForKey:@"room"];
        self.teacher = [aDecoder decodeObjectForKey:@"teacher"];
        self.eventIdentifier = [aDecoder decodeObjectForKey:@"eventIdentifier"];
    }
    
    return self;
}

+ (BOOL)supportsSecureCoding{
    return YES;
}

@end
