//
//  EZCourse.m
//  iTimetable
//
//  Created by Evian张 on 2018/11/6.
//  Copyright © 2018 Evian张. All rights reserved.
//

#import "EZCourse.h"

@implementation EZCourse
@synthesize courseInfos = _courseInfos;
@synthesize courseName = _courseName;
@synthesize firstWeek = _firstWeek;

- (instancetype)init{
    if(self = [super init]){
        self.courseInfos = [NSMutableArray array];
        CourseInfo *initialCourseInfo = [[CourseInfo alloc] init];
        [self.courseInfos addObject:initialCourseInfo];
        self.courseName = [NSString string];
        self.firstWeek = [NSDate date];
        return self;
    }
    return nil;
}

@end
