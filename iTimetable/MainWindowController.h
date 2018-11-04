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
#import "EZTimetable.h"
#import "Timetable+CoreDataClass.h"
//#import "AppDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface MainWindowController : NSWindowController

@property (strong) NSPersistentContainer *persistentContainer;
@property (nonatomic) EZEventStore *storeModel;
@property (nonatomic) TimetableInfoWindowController *timetableInfoWindowController;
@property (nonatomic) EZTimetable *currentTimetable;
@property (nonatomic) Timetable *timetables;

- (void)createTimetable;
- (void)changeTimetable;
- (void)deleteTimetable;
- (BOOL)checkCalendarEmpty;
- (BOOL)checkTimetable;

@end

NS_ASSUME_NONNULL_END
