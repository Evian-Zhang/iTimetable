//
//  EZCourseInfo.h
//  iTimetable
//
//  Created by Evian张 on 2018/11/7.
//  Copyright © 2018 Evian张. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum
{
    EZCourseStatusHasMatched,
    EZCourseStatusWillMatched,
    EZCourseStatusWillCreate,
    EZCourseStatusNotMatched,
    EZCourseStatusWillDelete,
    EZCourseStatusWillChange
} EZCourseStatus;

@interface EZCourseInfo : NSObject

@property (nonatomic) NSDate *startTime;
@property (nonatomic) NSDate *endTime;
@property (nonatomic) NSMutableArray *weeks;
@property (nonatomic) NSString *room;
@property (nonatomic) NSString *teacher;
@property (nonatomic) NSString *eventIdentifier;
@property (nullable, nonatomic, copy) NSDate *firstWeek;
@property (nonatomic) int semesterLength;
@property (nonatomic) BOOL isChanged;
@property (nonatomic) BOOL hasAlarm;
@property (nonatomic) NSTimeInterval relativeOffset;
@property (nonatomic) int day;
@property (nonatomic) EZCourseStatus status;

- (instancetype)initWithFirstWeek:(NSDate*)firstWeek semesterLength:(int)semesterLength;

@end

NS_ASSUME_NONNULL_END
