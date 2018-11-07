//
//  CourseInfo.h
//  iTimetable
//
//  Created by Evian张 on 2018/11/2.
//  Copyright © 2018 Evian张. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CourseInfo : NSObject <NSSecureCoding>

@property (nonatomic) NSDate *startTime;
@property (nonatomic) NSDate *endTime;
@property (nonatomic) NSArray *weeks;
@property (nonatomic) NSString *room;
@property (nonatomic) NSString *teacher;
@property (nonatomic) NSString *eventIdentifier;

@end

NS_ASSUME_NONNULL_END
