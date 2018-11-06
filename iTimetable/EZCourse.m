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

- (instancetype)init{
    if(self = [super init]){
        self.courseInfos = [NSMutableArray array];
        self.courseName = [NSString string];
        return self;
    }
    return nil;
}

@end
