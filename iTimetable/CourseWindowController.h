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
#import "MatchEventWindowController.h"

NS_ASSUME_NONNULL_BEGIN

@interface CourseWindowController : NSWindowController <NSWindowDelegate, NSTableViewDelegate, NSTableViewDataSource, NSMenuDelegate, NSTextFieldDelegate>

@property (weak) IBOutlet CourseWindow *window;
@property (nonatomic) EZCourse *course;
@property (nonatomic) EKEventStore *eventStore;
@property (nonatomic) BOOL isCreating;
@property (nonatomic) CourseInfoWindowController *courseInfoWindowController;
@property (nonatomic) MatchEventWindowController *matchEventWindowController;
@property (nonatomic) NSArray *names;
@property (nonatomic) NSString *warningText;
@property (nonatomic) int deleteCount;
@property (nonatomic) int row;
@property (nonatomic) EKCalendar *currentCalendar;

- (void)createCourseInfo;
- (void)changeCourseInfo;
- (void)markCourseInfoWillCreated;
- (void)markCourseInfoWillMatched;
- (void)markCourseInfoWillDeleted;
- (void)markCourseInfoWillUnmatched;
- (BOOL)checkCourseInfoSelected;
- (BOOL)isMarkCourseInfoWillCreatedEnabled;
- (BOOL)isMarkCourseInfoWillMatchedEnabled;
- (BOOL)isMarkCourseInfoWillDeletedEnabled;
- (BOOL)isMarkCourseInfoWillUnmatchedEnabled;

@end

NS_ASSUME_NONNULL_END
