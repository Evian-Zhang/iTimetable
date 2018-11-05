//
//  Course.m
//  iTimetable
//
//  Created by Evian张 on 2018/11/2.
//  Copyright © 2018 Evian张. All rights reserved.
//

#import "Course.h"

@implementation Course
@synthesize courseName = _courseName;
@synthesize courseInfos = _courseInfos;

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.courseName forKey:@"courseName"];
    [aCoder encodeObject:self.courseInfos forKey:@"courseInfos"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [[self class] new];
    if (self)
    {
        self.courseName = [aDecoder decodeObjectForKey:@"courseName"];
        self.courseInfos = [aDecoder decodeObjectForKey:@"courseInfos"];
    }
    return self;
}

@end
