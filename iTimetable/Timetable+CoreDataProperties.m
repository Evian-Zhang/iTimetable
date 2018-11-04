//
//  Timetable+CoreDataProperties.m
//  iTimetable
//
//  Created by Evian张 on 2018/11/4.
//  Copyright © 2018 Evian张. All rights reserved.
//
//

#import "Timetable+CoreDataProperties.h"

@implementation Timetable (CoreDataProperties)

+ (NSFetchRequest<Timetable *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"Timetable"];
}

@dynamic calendarIdentifier;
@dynamic courses;
@dynamic firstClassTime;
@dynamic firstWeek;
@dynamic lastClassTime;
@dynamic semesterLength;
@dynamic sourceIdentifier;

@end
