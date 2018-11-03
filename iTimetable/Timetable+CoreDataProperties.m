//
//  Timetable+CoreDataProperties.m
//  iTimetable
//
//  Created by Evian张 on 2018/11/3.
//  Copyright © 2018 Evian张. All rights reserved.
//
//

#import "Timetable+CoreDataProperties.h"

@implementation Timetable (CoreDataProperties)

+ (NSFetchRequest<Timetable *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"Timetable"];
}

@dynamic courses;
@dynamic firstClassTime;
@dynamic firstWeek;
@dynamic lastClassTime;
@dynamic semesterLength;
@dynamic calendarIdentifier;

@end
