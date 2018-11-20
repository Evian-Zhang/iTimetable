//
//  MainWindowController.h
//  iTimetable
//
//  Created by Evian张 on 2018/11/1.
//  Copyright © 2018 Evian张. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MainWindow.h"
#import "EZEventStore.h"
#import "TimetableInfoWindowController.h"
#import "CourseWindowController.h"
#import "EZTimetable.h"
#import "EZCourse.h"
#import "Timetable+CoreDataClass.h"

NS_ASSUME_NONNULL_BEGIN

@interface MainWindowController : NSWindowController <NSTableViewDelegate, NSTableViewDataSource, NSMenuDelegate>

@property (strong) NSPersistentContainer *persistentContainer;
@property (nonatomic) EZEventStore *storeModel;
@property (nonatomic) TimetableInfoWindowController *timetableInfoWindowController;
@property (nonatomic) CourseWindowController *courseWindowController;
@property (nonatomic) EZTimetable *currentTimetable;

- (void)createTimetable;
- (void)changeTimetable;
- (void)deleteTimetable;
- (void)createCourse;
- (void)changeCourse;
- (void)deleteCourse;
- (BOOL)checkCalendarEmpty;
- (BOOL)checkTimetable;
- (BOOL)checkTimetableEmpty;
- (BOOL)checkCourseSelected;

@end

NS_ASSUME_NONNULL_END
