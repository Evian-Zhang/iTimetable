//
//  CourseInfoWindowController.h
//  iTimetable
//
//  Created by Evian张 on 2018/11/5.
//  Copyright © 2018 Evian张. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <EventKit/EventKit.h>
#import "CourseWindow.h"
#import "Course.h"

NS_ASSUME_NONNULL_BEGIN

@interface CourseWindowController : NSWindowController <NSWindowDelegate>

@property (weak) IBOutlet CourseWindow *window;
@property (nonatomic) Course *course;
@property (nonatomic) EKEventStore *eventStore;
@property (nonatomic) BOOL isCreating;

- (BOOL)statusOfCourseInfo:(CourseInfo*)courseInfo;

@end

NS_ASSUME_NONNULL_END
