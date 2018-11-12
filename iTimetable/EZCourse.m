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
@synthesize semesterLength = _semesterLength;

- (instancetype)initWithFirstWeek:(NSDate*)firstWeek semesterLength:(int)semesterLength{
    if(self = [super init]){
        self.courseInfos = [NSMutableArray array];
        self.firstWeek = firstWeek;
        self.semesterLength = semesterLength;
        self.courseName = [NSString string];
        EZCourseInfo *initialCourseInfo = [[EZCourseInfo alloc] initWithFirstWeek:self.firstWeek semesterLength:self.semesterLength];
        [self.courseInfos addObject:initialCourseInfo];
        
        return self;
    }
    return nil;
}

- (instancetype)init{
    if(self = [super init]){
        self.courseInfos = [NSMutableArray array];
        self.courseName = [NSString string];
        self.firstWeek = [NSDate date];
        self.semesterLength = 0;
        return self;
    }
    return nil;
}

@end
