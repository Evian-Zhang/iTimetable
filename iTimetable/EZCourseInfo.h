//
//  EZCourseInfo.h
//  iTimetable
//
//  Created by Evian张 on 2018/11/7.
//  Copyright © 2018 Evian张. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface EZCourseInfo : NSObject

@property (nonatomic) NSDate *startTime;
@property (nonatomic) NSDate *endTime;
@property (nonatomic) NSMutableArray *weeks;
@property (nonatomic) NSString *room;
@property (nonatomic) NSString *teacher;
@property (nonatomic) NSString *eventIdentifier;
@property (nullable, nonatomic, copy) NSDate *firstWeek;
@property (nonatomic) int semesterLength;

@end

NS_ASSUME_NONNULL_END
