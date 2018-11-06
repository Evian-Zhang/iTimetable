//
//  EZCourse.h
//  iTimetable
//
//  Created by Evian张 on 2018/11/6.
//  Copyright © 2018 Evian张. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CourseInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface EZCourse : NSObject

@property (nonatomic) NSString *courseName;
@property (nonatomic) NSMutableArray *courseInfos;

@end

NS_ASSUME_NONNULL_END
