//
//  CourseInfo.m
//  iTimetable
//
//  Created by Evian张 on 2018/11/2.
//  Copyright © 2018 Evian张. All rights reserved.
//

#import "CourseInfo.h"

@implementation CourseInfo

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    /*
     [aCoder encodeObject:self.bookId forKey:@"bookId"];
     [aCoder encodeObject:self.name forKey:@"name"];
     [aCoder encodeObject:self.publisher forKey:@"publisher"];
     */
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    /*
     self = [[self class] new];
     if (self)
     {
     self.bookId = [aDecoder decodeObjectForKey:@"bookId"];
     self.name = [aDecoder decodeObjectForKey:@"name"];
     self.publisher = [aDecoder decodeObjectForKey:@"publisher"];
     }
     */
    return self;
}

@end
