//
//  EZCourse.h
//  iTimetable
//
//  Created by Evian张 on 2018/11/6.
//  Copyright © 2018 Evian张. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EZCourseInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface EZCourse : NSObject

@property (nonatomic) NSString *courseName;
@property (nonatomic) NSMutableArray *courseInfos;
@property (nullable, nonatomic, copy) NSDate *firstWeek;
@property (nonatomic) int semesterLength;

- (instancetype)initWithFirstWeek:(NSDate*)firstWeek semesterLength:(int)semesterLength;

@end

NS_ASSUME_NONNULL_END
