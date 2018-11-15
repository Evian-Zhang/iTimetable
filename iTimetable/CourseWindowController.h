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
#import "EZCourse.h"
#import "CourseInfo.h"
#import "CourseInfoWindowController.h"

NS_ASSUME_NONNULL_BEGIN

@interface CourseWindowController : NSWindowController <NSWindowDelegate, NSTableViewDelegate, NSTableViewDataSource>

@property (weak) IBOutlet CourseWindow *window;
@property (nonatomic) EZCourse *course;
@property (nonatomic) EKEventStore *eventStore;
@property (nonatomic) BOOL isCreating;
@property (nonatomic) CourseInfoWindowController *courseInfoWindowController;
@property (nonatomic) NSArray *names;
@property (nonatomic) NSMutableArray *statuses;
@property (nonatomic) NSString *warningText;
@property (nonatomic) int deleteCount;
@property (nonatomic) int row;

- (void)createCourseInfo;
- (void)changeCourseInfo;
- (void)markCourseInfoWillCreated;
- (void)markCourseInfoWillMatched;
- (void)markCourseInfoWillDeleted;
- (BOOL)checkCourseInfoSelected;
- (BOOL)isMarkCourseInfoWillCreatedEnabled;
- (BOOL)isMarkCourseInfoWillMatchedEnabled;
- (BOOL)isMarkCourseInfoWillDeletedEnabled;

@end

NS_ASSUME_NONNULL_END
