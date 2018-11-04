//
//  Timetable.h
//  iTimetable
//
//  Created by Evian张 on 2018/11/4.
//  Copyright © 2018 Evian张. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Course.h"

NS_ASSUME_NONNULL_BEGIN

@interface EZTimetable : NSObject

@property (nullable, nonatomic, retain) NSArray *courses;
@property (nullable, nonatomic, copy) NSDate *firstClassTime;
@property (nullable, nonatomic, copy) NSDate *firstWeek;
@property (nullable, nonatomic, copy) NSDate *lastClassTime;
@property (nonatomic) int semesterLength;
@property (nullable, nonatomic, copy) NSString *calendarIdentifier;
@property (nullable, nonatomic, copy) NSString *sourceIdentifier;

@end

NS_ASSUME_NONNULL_END
