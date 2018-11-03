//
//  Timetable+CoreDataProperties.h
//  iTimetable
//
//  Created by Evian张 on 2018/11/3.
//  Copyright © 2018 Evian张. All rights reserved.
//
//

#import "Timetable+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Timetable (CoreDataProperties)

+ (NSFetchRequest<Timetable *> *)fetchRequest;

@property (nullable, nonatomic, retain) NSArray *courses;
@property (nullable, nonatomic, copy) NSDate *firstClassTime;
@property (nullable, nonatomic, copy) NSDate *firstWeek;
@property (nullable, nonatomic, copy) NSDate *lastClassTime;
@property (nonatomic) int64_t semesterLength;
@property (nullable, nonatomic, copy) NSString *calendarIdentifier;

@end

NS_ASSUME_NONNULL_END
