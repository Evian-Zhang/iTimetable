//
//  MainWindowController.m
//  iTimetable
//
//  Created by Evian张 on 2018/11/1.
//  Copyright © 2018 Evian张. All rights reserved.
//

#import "MainWindowController.h"

@interface MainWindowController ()

@property (weak) IBOutlet MainWindow *window;

@end

@implementation MainWindowController
@synthesize storeModel = _storeModel;
@synthesize timetableInfoWindowController = _timetableInfoWindowController;
@synthesize courseWindowController = _courseWindowController;
@synthesize currentTimetable = _currentTimetable;
@synthesize persistentContainer = _persistentContainer;

- (void)windowDidLoad {
    [super windowDidLoad];
    self.window.accessText.stringValue = @"正在获取日历访问权限";
    self.window.accessText.hidden = NO;
    self.window.sourceText.hidden = YES;
    self.window.sourcePop.hidden = YES;
    self.window.calText.hidden = YES;
    self.window.calPop.hidden = YES;
    self.window.scrollView.hidden = YES;
    self.window.createTimetableBtn.hidden = NO;
    self.window.createTimetableBtn.target = self;
    self.window.createTimetableBtn.action = @selector(createTimetable);
    [self initNotification];
    [self initPopUpButton];
    [self initContextualMenu];
    self.storeModel = [[EZEventStore alloc] init];
    self.window.courseTable.dataSource = self;
    self.window.courseTable.delegate = self;
    
    self.window.timetableView.courseInfoViews = [NSMutableArray<NSTextField*> array];
    self.window.timetableView.courseInfos = [NSMutableArray<NSMutableArray<CourseInfo*>*> arrayWithCapacity:7];
    for (int day = 0; day < 7; day++) {
        self.window.timetableView.courseInfos[day] = [NSMutableArray<CourseInfo*> array];
    }
    self.window.timetableView.currentWeekPicker.target = self;
    self.window.timetableView.currentWeekPicker.action = @selector(currentWeekPickerHandler);
}

- (void)initNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(eventStoreForEventAccessSuccessfullyNotificicationHandler) name:@"EZEventStoreForEventAccessSuccessfully" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(eventStoreBForEventAccessUnsuccessfullyNotificicationHandler) name:@"EZEventStoreForEventAccessUnsuccessfully" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(timetableGetSuccessfullyHandler:) name:@"EZTimetableGetSuccessfully" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(courseGetSuccessfullyHandler:) name:@"EZCourseGetSuccessfully" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(courseWindowWillCloseHandler) name:@"EZCourseWindowWillClose" object:nil];
}

- (void)initPopUpButton{
    [self.window.sourcePop setTarget:self];
    [self.window.sourcePop setAction:@selector(sourcePopHandler)];
    
    [self.window.calPop setTarget:self];
    [self.window.calPop setAction:@selector(calPopHandler)];
}

- (void)initContextualMenu{
    self.window.contextualMenu.delegate = self;
    
    [self.window.createCourseItem setTarget:self];
    [self.window.createCourseItem setAction:@selector(createCourse)];
    
    [self.window.changeCourseItem setTarget:self];
    [self.window.changeCourseItem setAction:@selector(changeCourse)];
    
    [self.window.deleteCourseItem setTarget:self];
    [self.window.deleteCourseItem setAction:@selector(deleteCourse)];
}

- (BOOL)validateMenuItem:(NSMenuItem *)menuItem{
    self.window.createCourseItem.enabled = [self checkTimetableEmpty] && !self.courseWindowController.window.isVisible;
    self.window.changeCourseItem.enabled = [self checkCourseSelected] && !self.courseWindowController.window.isVisible;
    self.window.deleteCourseItem.enabled = [self checkCourseSelected] && !self.courseWindowController.window.isVisible;
    return [menuItem isEnabled];
}

#pragma mark - Generate PopUpItems
- (void)generateSorucePopUpItems{
    [self.window.sourcePop removeAllItems];
    for(EKSource *source in self.storeModel.sources){
        NSMenuItem *sourceItem = [[NSMenuItem alloc] initWithTitle:source.title action:nil keyEquivalent:@""];
        [self.window.sourcePop.menu addItem:sourceItem];
    }
    if(self.storeModel.sources.count > 0){
        self.storeModel.currentSource = self.storeModel.sources[0];
        [self.storeModel generateCalendars];
    } else {
        self.storeModel.currentSource = nil;
        self.storeModel.currentCalendar = nil;
    }
    [self checkCalendarEmpty];
    [self checkTimetable];
}

- (void)generateCalendarPopUpItems{
    [self.window.calPop removeAllItems];
    for(EKCalendar *calendar in self.storeModel.calendars){
        NSMenuItem *calItem = [[NSMenuItem alloc] initWithTitle:calendar.title action:nil keyEquivalent:@""];
        [self.window.calPop.menu addItem:calItem];
    }
    if(self.storeModel.calendars.count > 0){
        self.storeModel.currentCalendar = self.storeModel.calendars[0];
    } else {
        self.storeModel.currentCalendar = nil;
    }
    [self checkCalendarEmpty];
    [self checkTimetable];
    [self.window.courseTable reloadData];
}

#pragma mark - Notification Handler
- (void)eventStoreForEventAccessSuccessfullyNotificicationHandler{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.window.accessText.stringValue = @"获取日历权限成功";
    });
    self.window.accessText.hidden = YES;
    self.window.sourceText.hidden = NO;
    self.window.sourcePop.hidden = NO;
    self.window.calText.hidden = NO;
    self.window.calPop.hidden = NO;
    self.storeModel.sources = [self.storeModel.eventStore sources];
    [self generateSorucePopUpItems];
    [self generateCalendarPopUpItems];
}

- (void)eventStoreBForEventAccessUnsuccessfullyNotificicationHandler{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.window.accessText.stringValue = @"获取日历权限失败";
    });
    self.window.accessText.hidden = NO;
    self.window.sourceText.hidden = YES;
    self.window.sourcePop.hidden = YES;
    self.window.calText.hidden = YES;
    self.window.calPop.hidden = YES;
}

- (void)timetableGetSuccessfullyHandler:(NSNotification*)aNotification{
    EZTimetable *tmpTimetable = [[aNotification userInfo] valueForKey:@"timetable"];
    NSNumber *tmpNumber = [[aNotification userInfo] valueForKey:@"isCreating"];
    BOOL tmpFlag = tmpNumber.boolValue;
    self.currentTimetable.firstWeek = tmpTimetable.firstWeek;
    self.currentTimetable.firstClassTime = tmpTimetable.firstClassTime;
    self.currentTimetable.lastClassTime = tmpTimetable.lastClassTime;
    self.currentTimetable.semesterLength = tmpTimetable.semesterLength;
    
    if(tmpFlag){
        Timetable *timetable = [NSEntityDescription insertNewObjectForEntityForName:@"Timetable"  inManagedObjectContext:self.persistentContainer.viewContext];
        timetable.calendarIdentifier = self.currentTimetable.calendarIdentifier;
        timetable.sourceIdentifier = self.currentTimetable.sourceIdentifier;
        timetable.firstWeek = self.currentTimetable.firstWeek;
        timetable.firstClassTime = self.currentTimetable.firstClassTime;
        timetable.lastClassTime = self.currentTimetable.lastClassTime;
        timetable.semesterLength = self.currentTimetable.semesterLength;
        timetable.courses = [NSArray arrayWithArray:self.currentTimetable.courses];
        
        NSError *error = nil;
        if ([self.persistentContainer.viewContext save:&error]) {
            NSLog(@"数据插入到数据库成功");
        }else{
            NSLog(@"%@", [NSString stringWithFormat:@"数据插入到数据库失败, %@", error]);
        }
    } else {
        NSFetchRequest *changeRequest = [NSFetchRequest fetchRequestWithEntityName:@"Timetable"];
        NSPredicate *pre = [NSPredicate predicateWithFormat:@"calendarIdentifier = %@", self.storeModel.currentCalendar.calendarIdentifier];
        changeRequest.predicate = pre;
        
        NSArray *changeArray = [self.persistentContainer.viewContext executeFetchRequest:changeRequest error:nil];
        Timetable *timetable = changeArray[0];
        timetable.calendarIdentifier = self.currentTimetable.calendarIdentifier;
        timetable.sourceIdentifier = self.currentTimetable.sourceIdentifier;
        timetable.firstWeek = self.currentTimetable.firstWeek;
        timetable.firstClassTime = self.currentTimetable.firstClassTime;
        timetable.lastClassTime = self.currentTimetable.lastClassTime;
        timetable.semesterLength = self.currentTimetable.semesterLength;
        timetable.courses = [NSArray arrayWithArray:self.currentTimetable.courses];
        NSError *error = nil;
        if ([self.persistentContainer.viewContext save:&error]) {
            NSLog(@"数据修改到数据库成功");
        }else{
            NSLog(@"%@", [NSString stringWithFormat:@"数据修改到数据库失败, %@", error]);
        }
    }
    [self.window.courseTable reloadData];
    [self checkTimetable];
}

- (void)courseGetSuccessfullyHandler:(NSNotification*)aNotification{
    EZCourse *tmpCourse = [[aNotification userInfo] valueForKey:@"course"];
    NSNumber *tmpNumber = [[aNotification userInfo] valueForKey:@"isCreating"];
    BOOL tmpFlag = tmpNumber.boolValue;
    if(tmpFlag){
        Course *course = [[Course alloc] init];
        course.courseName = tmpCourse.courseName;
        course.courseInfos = [self convertedCourseInfosWithUnconvertedCourseInfos:[NSArray arrayWithArray:tmpCourse.courseInfos] andCourseName:course.courseName];
        [self.currentTimetable.courses addObject:course];
        NSFetchRequest *changeRequest = [NSFetchRequest fetchRequestWithEntityName:@"Timetable"];
        NSPredicate *pre = [NSPredicate predicateWithFormat:@"calendarIdentifier = %@", self.storeModel.currentCalendar.calendarIdentifier];
        changeRequest.predicate = pre;
        
        NSArray *changeArray = [self.persistentContainer.viewContext executeFetchRequest:changeRequest error:nil];
        Timetable *timetable = changeArray[0];
        timetable.courses = [NSArray arrayWithArray:self.currentTimetable.courses];
        NSError *error = nil;
        if ([self.persistentContainer.viewContext save:&error]) {
            NSLog(@"数据修改到数据库成功");
        }else{
            NSLog(@"%@", [NSString stringWithFormat:@"数据修改到数据库失败, %@", error]);
        }
    } else {
        Course *course = [[Course alloc] init];
        course.courseName = tmpCourse.courseName;
        course.courseInfos = [self convertedCourseInfosWithUnconvertedCourseInfos:[NSArray arrayWithArray:tmpCourse.courseInfos] andCourseName:course.courseName];
        NSNumber *tmpRow = [[aNotification userInfo] valueForKey:@"row"];
        [self.currentTimetable.courses replaceObjectAtIndex:tmpRow.intValue withObject:course];
        NSFetchRequest *changeRequest = [NSFetchRequest fetchRequestWithEntityName:@"Timetable"];
        NSPredicate *pre = [NSPredicate predicateWithFormat:@"calendarIdentifier = %@", self.storeModel.currentCalendar.calendarIdentifier];
        changeRequest.predicate = pre;
        
        NSArray *changeArray = [self.persistentContainer.viewContext executeFetchRequest:changeRequest error:nil];
        Timetable *timetable = changeArray[0];
        timetable.courses = [NSArray arrayWithArray:self.currentTimetable.courses];
        NSError *error = nil;
        if ([self.persistentContainer.viewContext save:&error]) {
            NSLog(@"数据修改到数据库成功");
        }else{
            NSLog(@"%@", [NSString stringWithFormat:@"数据修改到数据库失败, %@", error]);
        }
    }
    [self.window.courseTable reloadData];
    [self checkTimetable];
}

- (void)courseWindowWillCloseHandler{
    [self checkTimetable];
}

#pragma mark - PopUpButton Handler
- (void)sourcePopHandler{
    self.storeModel.currentSource = self.storeModel.sources[self.window.sourcePop.indexOfSelectedItem];
    [self.storeModel generateCalendars];
    [self generateCalendarPopUpItems];
}

- (void)calPopHandler{
    self.storeModel.currentCalendar = self.storeModel.calendars[self.window.calPop.indexOfSelectedItem];
    [self checkTimetable];
    [self.window.courseTable reloadData];
}

- (void)currentWeekPickerHandler {
    self.window.timetableView.currentWeek = self.window.timetableView.currentWeekPicker.indexOfSelectedItem;
    for (NSTextField *textField in self.window.timetableView.courseInfoViews) {
        [textField removeFromSuperviewWithoutNeedingDisplay];
        [self.window.timetableView.courseInfoViews removeObject:textField];
    }
    [self classifyCourseInfosToTimetableView];
    [self.window.timetableView setNeedsDisplay:YES];
}

#pragma mark - create timetable
- (void)createTimetable{
    self.currentTimetable = [[EZTimetable alloc] init];
    self.currentTimetable.sourceIdentifier = self.storeModel.currentSource.sourceIdentifier;
    self.currentTimetable.calendarIdentifier = self.storeModel.currentCalendar.calendarIdentifier;
    self.timetableInfoWindowController = [[TimetableInfoWindowController alloc] initWithWindowNibName:@"TimetableInfoWindowController"];
    self.timetableInfoWindowController.timetable = self.currentTimetable;
    self.timetableInfoWindowController.isCreating = YES;
    [NSApp runModalForWindow:self.timetableInfoWindowController.window];
}

#pragma mark - change timetable
- (void)changeTimetable{
    self.timetableInfoWindowController = [[TimetableInfoWindowController alloc] initWithWindowNibName:@"TimetableInfoWindowController"];
    self.timetableInfoWindowController.timetable = self.currentTimetable;
    self.timetableInfoWindowController.isCreating = NO;
    [NSApp runModalForWindow:self.timetableInfoWindowController.window];
}

#pragma mark - delete timetable
- (void)deleteTimetable{
    for (Course *course in self.currentTimetable.courses) {
        [self deleteCourseInfosInCalendarOfCourse:course];
    }
    NSFetchRequest *deleRequest = [NSFetchRequest fetchRequestWithEntityName:@"Timetable"];
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"calendarIdentifier = %@", self.storeModel.currentCalendar.calendarIdentifier];
    deleRequest.predicate = pre;
    
    NSArray *deleArray = [self.persistentContainer.viewContext executeFetchRequest:deleRequest error:nil];
    
    [self.persistentContainer.viewContext deleteObject:deleArray[0]];
    
    NSError *error = nil;
    if ([self.persistentContainer.viewContext save:&error]) {
        NSLog(@"删除成功");
    }else{
        NSLog(@"删除数据失败, %@", error);
    }
    [self checkTimetable];
}

#pragma mark - create course
- (void)createCourse{
    NSMutableArray *names = [NSMutableArray array];
    for(EZCourse *course in self.currentTimetable.courses){
        [names addObject:course.courseName];
    }
    EZCourse *course = [[EZCourse alloc] initWithFirstWeek:self.currentTimetable.firstWeek semesterLength:self.currentTimetable.semesterLength];
    self.courseWindowController = [[CourseWindowController alloc] initWithWindowNibName:@"CourseWindowController"];
    self.courseWindowController.course = course;
    self.courseWindowController.eventStore = self.storeModel.eventStore;
    self.courseWindowController.isCreating = YES;
    self.courseWindowController.row = -1;
    self.courseWindowController.names = [NSArray arrayWithArray:names];
    self.courseWindowController.currentCalendar = self.storeModel.currentCalendar;
    [NSApp runModalForWindow:self.courseWindowController.window];
}

#pragma mark - change course
- (void)changeCourse{
    if(self.window.currentRow >= 0){
        NSMutableArray *names = [NSMutableArray array];
        for(Course *course in self.currentTimetable.courses){
            [names addObject:course.courseName];
        }
        self.courseWindowController = [[CourseWindowController alloc] initWithWindowNibName:@"CourseWindowController"];
        Course *tmpCourse = self.currentTimetable.courses[self.window.currentRow];
        [names removeObject:tmpCourse.courseName];
        EZCourse *course = [[EZCourse alloc] init];
        course.courseName = tmpCourse.courseName;
        course.firstWeek = self.currentTimetable.firstWeek;
        course.semesterLength = self.currentTimetable.semesterLength;
        [course.courseInfos removeAllObjects];
        for(CourseInfo *unconvertedCourseInfo in tmpCourse.courseInfos){
            EZCourseInfo *convertedCourseInfo = [[EZCourseInfo alloc] initWithFirstWeek:self.currentTimetable.firstWeek semesterLength:self.currentTimetable.semesterLength];
            convertedCourseInfo.courseName = unconvertedCourseInfo.courseName;
            convertedCourseInfo.room = unconvertedCourseInfo.room;
            convertedCourseInfo.teacher = unconvertedCourseInfo.teacher;
            convertedCourseInfo.startTime = unconvertedCourseInfo.startTime;
            convertedCourseInfo.endTime = unconvertedCourseInfo.endTime;
            convertedCourseInfo.weeks = [NSMutableArray arrayWithArray:unconvertedCourseInfo.weeks];
            convertedCourseInfo.eventIdentifier = unconvertedCourseInfo.eventIdentifier;
            convertedCourseInfo.day = [unconvertedCourseInfo dayWithFirstWeek:convertedCourseInfo.firstWeek];
            if (convertedCourseInfo.eventIdentifier.length == 0) {
                convertedCourseInfo.status = EZCourseStatusNotMatched;
                convertedCourseInfo.hasAlarm = NO;
                convertedCourseInfo.relativeOffset = 0;
            } else {
                EKEvent *courseInfoEvent = [self.storeModel.eventStore eventWithIdentifier:convertedCourseInfo.eventIdentifier];
                if (courseInfoEvent == nil) {
                    convertedCourseInfo.status = EZCourseStatusNotMatched;
                    convertedCourseInfo.hasAlarm = NO;
                    convertedCourseInfo.relativeOffset = 0;
                } else {
                    convertedCourseInfo.status = EZCourseStatusHasMatched;
                    if (![courseInfoEvent hasAlarms]) {
                        convertedCourseInfo.hasAlarm = NO;
                        convertedCourseInfo.relativeOffset = 0;
                    } else {
                        convertedCourseInfo.hasAlarm = YES;
                        EKAlarm *alarm = courseInfoEvent.alarms[0];
                        convertedCourseInfo.relativeOffset = alarm.relativeOffset;
                    }
                }
            }
            [course.courseInfos addObject:convertedCourseInfo];
        }
        self.courseWindowController.course = course;
        self.courseWindowController.eventStore = self.storeModel.eventStore;
        self.courseWindowController.isCreating = NO;
        self.courseWindowController.row = self.window.currentRow;
        self.courseWindowController.currentCalendar = self.storeModel.currentCalendar;
        self.courseWindowController.names = [NSArray arrayWithArray:names];
        [NSApp runModalForWindow:self.courseWindowController.window];
    }
}

#pragma mark - delete course
- (void)deleteCourse{
    Course *currentCourse = self.currentTimetable.courses[self.window.currentRow];
    [self deleteCourseInfosInCalendarOfCourse:currentCourse];
    [self.currentTimetable.courses removeObjectAtIndex:self.window.currentRow];
    NSFetchRequest *changeRequest = [NSFetchRequest fetchRequestWithEntityName:@"Timetable"];
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"calendarIdentifier = %@", self.storeModel.currentCalendar.calendarIdentifier];
    changeRequest.predicate = pre;
    
    NSArray *changeArray = [self.persistentContainer.viewContext executeFetchRequest:changeRequest error:nil];
    
    Timetable *timetable = changeArray[0];
    timetable.courses = [NSArray arrayWithArray:self.currentTimetable.courses];
    
    NSError *error = nil;
    if ([self.persistentContainer.viewContext save:&error]) {
        NSLog(@"从数据库中删除成功");
    }else{
        NSLog(@"从数据库中删除数据失败, %@", error);
    }
    [self checkTimetable];
    [self.window.courseTable reloadData];
}

#pragma mark - checker
- (BOOL)checkCalendarEmpty{
    if(self.storeModel.calendars.count > 0){
        self.window.createTimetableBtn.enabled = YES;
        return YES;
    } else {
        self.window.createTimetableBtn.enabled = NO;
        return NO;
    }
}

- (BOOL)checkTimetable{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Timetable"];
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"calendarIdentifier = %@", self.storeModel.currentCalendar.calendarIdentifier];
    request.predicate = pre;
    NSArray *resArray = [self.persistentContainer.viewContext executeFetchRequest:request error:nil];
    if(resArray.count == 0){
        [self checkCalendarEmpty];
        self.currentTimetable = [[EZTimetable alloc] init];
        self.window.scrollView.hidden = YES;
        self.window.createTimetableBtn.hidden = NO;
        self.window.timetableView.currentWeekPicker.enabled = NO;
        [self.window.timetableView.currentWeekPicker removeAllItems];
        self.window.timetableView.firstClassTime = [NSDate date];
        self.window.timetableView.dayLength = 0;
        for (NSTextField *textField in self.window.timetableView.courseInfoViews) {
            [textField removeFromSuperviewWithoutNeedingDisplay];
            [self.window.timetableView.courseInfoViews removeObject:textField];
        }
        self.window.timetableView.currentWeek = 0;
        [self classifyCourseInfosToTimetableView];
        [self.window.timetableView setNeedsDisplay:YES];
        return NO;
    } else {
        self.window.createTimetableBtn.enabled = NO;
        self.window.scrollView.hidden = NO;
        self.window.createTimetableBtn.hidden = YES;
        Timetable *tmpTimetable = resArray[0];
        self.currentTimetable = [[EZTimetable alloc] init];
        self.currentTimetable.sourceIdentifier = tmpTimetable.sourceIdentifier;
        self.currentTimetable.calendarIdentifier = tmpTimetable.calendarIdentifier;
        self.currentTimetable.firstWeek = tmpTimetable.firstWeek;
        self.currentTimetable.firstClassTime = tmpTimetable.firstClassTime;
        self.currentTimetable.lastClassTime = tmpTimetable.lastClassTime;
        self.currentTimetable.semesterLength = tmpTimetable.semesterLength;
        self.currentTimetable.courses = [NSMutableArray arrayWithArray:tmpTimetable.courses];
        self.window.timetableView.currentWeekPicker.enabled = YES;
        for (int week = 0; week < self.currentTimetable.semesterLength; week++) {
            [self.window.timetableView.currentWeekPicker addItemWithTitle:[NSString stringWithFormat:@"第%d周", week + 1]];
        }
        NSDateComponents *tmpComponents = [[NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian] components:NSCalendarUnitDay fromDate:self.currentTimetable.firstWeek toDate:[NSDate date] options:0];
        int currentWeek = (tmpComponents.day) / 7;
        if (currentWeek >= 0 && currentWeek < self.currentTimetable.semesterLength) {
            self.window.timetableView.currentWeek = currentWeek;
            [self.window.timetableView.currentWeekPicker selectItemAtIndex:currentWeek];
        } else {
            self.window.timetableView.currentWeek = 0;
            [self.window.timetableView.currentWeekPicker selectItemAtIndex:0];
        }
        self.window.timetableView.firstClassTime = self.currentTimetable.firstClassTime;
        self.window.timetableView.dayLength = [self.currentTimetable.lastClassTime timeIntervalSinceDate:self.currentTimetable.firstClassTime] / (double)3600;
        for (NSTextField *textField in self.window.timetableView.courseInfoViews) {
            [textField removeFromSuperviewWithoutNeedingDisplay];
            [self.window.timetableView.courseInfoViews removeObject:textField];
        }
        [self classifyCourseInfosToTimetableView];
        [self.window.timetableView setNeedsDisplay:YES];
        return YES;
    }
}

- (BOOL)checkTimetableEmpty {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Timetable"];
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"calendarIdentifier = %@", self.storeModel.currentCalendar.calendarIdentifier];
    request.predicate = pre;
    NSArray *resArray = [self.persistentContainer.viewContext executeFetchRequest:request error:nil];
    if(resArray.count == 0){
        return NO;
    } else {
        return YES;
    }
}

- (BOOL)checkCourseSelected{
    if(self.window.currentRow >= 0){
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)eventStoreHasCourseInfo:(CourseInfo*)courseInfo{
    if ([self.storeModel.eventStore eventWithIdentifier:courseInfo.eventIdentifier] != nil) {
        return YES;
    }
    return NO;
}

#pragma mark - helper function
- (NSArray*)convertedCourseInfosWithUnconvertedCourseInfos:(NSArray*)unconvertedCourseInfos andCourseName:(NSString*)courseName{
    NSMutableArray *convertedCourseInfos = [NSMutableArray array];
    for(EZCourseInfo *courseInfo in unconvertedCourseInfos){
        switch (courseInfo.status) {
            case EZCourseStatusWillCreate: {
                CourseInfo *convertedCourseInfo = [[CourseInfo alloc] init];
                convertedCourseInfo.courseName = courseInfo.courseName;
                convertedCourseInfo.room = courseInfo.room;
                convertedCourseInfo.teacher = courseInfo.teacher;
                convertedCourseInfo.startTime = courseInfo.startTime;
                convertedCourseInfo.endTime = courseInfo.endTime;
                convertedCourseInfo.weeks = [NSArray arrayWithArray:courseInfo.weeks];
                EKEvent *courseInfoEvent = [EKEvent eventWithEventStore:self.storeModel.eventStore];
                courseInfoEvent.title = courseName;
                courseInfoEvent.startDate = convertedCourseInfo.startTime;
                courseInfoEvent.endDate = convertedCourseInfo.endTime;
                if (convertedCourseInfo.teacher.length > 0) {
                    courseInfoEvent.title = [courseInfoEvent.title stringByAppendingString:[NSString stringWithFormat:@"（教师：%@）", convertedCourseInfo.teacher]];
                }
                if (convertedCourseInfo.room.length > 0) {
                    [courseInfoEvent setStructuredLocation:[EKStructuredLocation locationWithTitle:convertedCourseInfo.room]];
                }
                if (courseInfo.hasAlarm) {
                    [courseInfoEvent addAlarm:[EKAlarm alarmWithRelativeOffset:courseInfo.relativeOffset]];
                }
                NSInteger interval;
                if (courseInfo.weeks.count == 1) {
                    interval = 1;
                } else {
                    NSNumber *firstWeek = courseInfo.weeks[0];
                    NSNumber *secondWeek = courseInfo.weeks[1];
                    if (secondWeek.intValue - firstWeek.intValue == 1) {
                        interval = 1;
                    } else {
                        interval = 2;
                    }
                }
                [courseInfoEvent addRecurrenceRule:[[EKRecurrenceRule alloc] initRecurrenceWithFrequency:EKRecurrenceFrequencyWeekly interval:interval end:[EKRecurrenceEnd recurrenceEndWithOccurrenceCount:courseInfo.weeks.count]]];
                courseInfoEvent.allDay = NO;
                courseInfoEvent.calendar = self.storeModel.currentCalendar;
                NSError *createError;
                if ([self.storeModel.eventStore saveEvent:courseInfoEvent span:EKSpanFutureEvents commit:YES error:&createError]) {
                    NSLog(@"向日历添加事件成功");
                    convertedCourseInfo.eventIdentifier = courseInfoEvent.eventIdentifier;
                    [convertedCourseInfos addObject:convertedCourseInfo];
                } else {
                    NSLog(@"向日历添加事件失败。%@", createError);
                }
            }
                break;
            case EZCourseStatusWillDelete: {
                if (courseInfo.eventIdentifier.length > 0) {
                    EKEvent *courseInfoEvent = [self.storeModel.eventStore eventWithIdentifier:courseInfo.eventIdentifier];
                    if (courseInfoEvent != nil) {
                        NSError *removeError;
                        if ([self.storeModel.eventStore removeEvent:courseInfoEvent span:EKSpanFutureEvents commit:YES error:&removeError]) {
                            NSLog(@"从日历删除事件成功");
                        } else {
                            NSLog(@"从日历删除事件失败。%@", removeError);
                        }
                    }
                }
            }
                break;
            case EZCourseStatusWillMatched: {
                CourseInfo *convertedCourseInfo = [[CourseInfo alloc] init];
                convertedCourseInfo.courseName = courseInfo.courseName;
                convertedCourseInfo.room = courseInfo.room;
                convertedCourseInfo.teacher = courseInfo.teacher;
                convertedCourseInfo.startTime = courseInfo.startTime;
                convertedCourseInfo.endTime = courseInfo.endTime;
                convertedCourseInfo.weeks = [NSArray arrayWithArray:courseInfo.weeks];
                convertedCourseInfo.eventIdentifier = courseInfo.eventIdentifier;
                [convertedCourseInfos addObject:convertedCourseInfo];
            }
                break;
            case EZCourseStatusNotMatched: {
                CourseInfo *convertedCourseInfo = [[CourseInfo alloc] init];
                convertedCourseInfo.courseName = courseInfo.courseName;
                convertedCourseInfo.room = courseInfo.room;
                convertedCourseInfo.teacher = courseInfo.teacher;
                convertedCourseInfo.startTime = courseInfo.startTime;
                convertedCourseInfo.endTime = courseInfo.endTime;
                convertedCourseInfo.weeks = [NSArray arrayWithArray:courseInfo.weeks];
                convertedCourseInfo.eventIdentifier = courseInfo.eventIdentifier;
                [convertedCourseInfos addObject:convertedCourseInfo];
            }
                break;
            case EZCourseStatusHasMatched: {
                CourseInfo *convertedCourseInfo = [[CourseInfo alloc] init];
                convertedCourseInfo.courseName = courseInfo.courseName;
                convertedCourseInfo.room = courseInfo.room;
                convertedCourseInfo.teacher = courseInfo.teacher;
                convertedCourseInfo.startTime = courseInfo.startTime;
                convertedCourseInfo.endTime = courseInfo.endTime;
                convertedCourseInfo.weeks = [NSArray arrayWithArray:courseInfo.weeks];
                convertedCourseInfo.eventIdentifier = courseInfo.eventIdentifier;
                [convertedCourseInfos addObject:convertedCourseInfo];
            }
                break;
            case EZCourseStatusWillChange: {
                CourseInfo *convertedCourseInfo = [[CourseInfo alloc] init];
                convertedCourseInfo.courseName = courseInfo.courseName;
                convertedCourseInfo.room = courseInfo.room;
                convertedCourseInfo.teacher = courseInfo.teacher;
                convertedCourseInfo.startTime = courseInfo.startTime;
                convertedCourseInfo.endTime = courseInfo.endTime;
                convertedCourseInfo.weeks = [NSArray arrayWithArray:courseInfo.weeks];
                if (courseInfo.eventIdentifier.length == 0) {
                    EKEvent *courseInfoEvent = [EKEvent eventWithEventStore:self.storeModel.eventStore];
                    courseInfoEvent.title = courseName;
                    courseInfoEvent.startDate = convertedCourseInfo.startTime;
                    courseInfoEvent.endDate = convertedCourseInfo.endTime;
                    if (convertedCourseInfo.teacher.length > 0) {
                        courseInfoEvent.title = [courseInfoEvent.title stringByAppendingString:[NSString stringWithFormat:@"（教师：%@）", convertedCourseInfo.teacher]];
                    }
                    if (convertedCourseInfo.room.length > 0) {
                        [courseInfoEvent setStructuredLocation:[EKStructuredLocation locationWithTitle:convertedCourseInfo.room]];
                    }
                    if (courseInfo.hasAlarm) {
                        [courseInfoEvent addAlarm:[EKAlarm alarmWithRelativeOffset:courseInfo.relativeOffset]];
                    }
                    NSInteger interval;
                    if (courseInfo.weeks.count == 1) {
                        interval = 1;
                    } else {
                        NSNumber *firstWeek = courseInfo.weeks[0];
                        NSNumber *secondWeek = courseInfo.weeks[1];
                        if (secondWeek.intValue - firstWeek.intValue == 1) {
                            interval = 1;
                        } else {
                            interval = 2;
                        }
                    }
                    [courseInfoEvent addRecurrenceRule:[[EKRecurrenceRule alloc] initRecurrenceWithFrequency:EKRecurrenceFrequencyWeekly interval:interval end:[EKRecurrenceEnd recurrenceEndWithOccurrenceCount:courseInfo.weeks.count]]];
                    courseInfoEvent.allDay = NO;
                    courseInfoEvent.calendar = self.storeModel.currentCalendar;
                    NSError *createError;
                    if ([self.storeModel.eventStore saveEvent:courseInfoEvent span:EKSpanFutureEvents commit:YES error:&createError]) {
                        NSLog(@"向日历添加事件成功");
                        convertedCourseInfo.eventIdentifier = courseInfoEvent.eventIdentifier;
                        [convertedCourseInfos addObject:convertedCourseInfo];
                    } else {
                        NSLog(@"向日历添加事件失败。%@", createError);
                    }
                } else {
                    EKEvent *courseInfoEvent = [self.storeModel.eventStore eventWithIdentifier:courseInfo.eventIdentifier];
                    if (courseInfoEvent != nil) {
                        courseInfoEvent.title = courseName;
                        courseInfoEvent.startDate = convertedCourseInfo.startTime;
                        courseInfoEvent.endDate = convertedCourseInfo.endTime;
                        if (convertedCourseInfo.teacher.length > 0) {
                            courseInfoEvent.title = [courseInfoEvent.title stringByAppendingString:[NSString stringWithFormat:@"（教师：%@）", convertedCourseInfo.teacher]];
                        }
                        if (convertedCourseInfo.room.length > 0) {
                            [courseInfoEvent setStructuredLocation:[EKStructuredLocation locationWithTitle:convertedCourseInfo.room]];
                        }
                        for (EKAlarm *alarm in courseInfoEvent.alarms) {
                            [courseInfoEvent removeAlarm:alarm];
                        }
                        if (courseInfo.hasAlarm) {
                            [courseInfoEvent addAlarm:[EKAlarm alarmWithRelativeOffset:courseInfo.relativeOffset]];
                        }
                        NSInteger interval;
                        if (courseInfo.weeks.count == 1) {
                            interval = 1;
                        } else {
                            NSNumber *firstWeek = courseInfo.weeks[0];
                            NSNumber *secondWeek = courseInfo.weeks[1];
                            if (secondWeek.intValue - firstWeek.intValue == 1) {
                                interval = 1;
                            } else {
                                interval = 2;
                            }
                        }
                        for (EKRecurrenceRule *recurrenceRule in courseInfoEvent.recurrenceRules) {
                            [courseInfoEvent removeRecurrenceRule:recurrenceRule];
                        }
                        [courseInfoEvent addRecurrenceRule:[[EKRecurrenceRule alloc] initRecurrenceWithFrequency:EKRecurrenceFrequencyWeekly interval:interval end:[EKRecurrenceEnd recurrenceEndWithOccurrenceCount:courseInfo.weeks.count]]];
                        courseInfoEvent.allDay = NO;
                        courseInfoEvent.calendar = self.storeModel.currentCalendar;
                        NSError *createError;
                        if ([self.storeModel.eventStore saveEvent:courseInfoEvent span:EKSpanFutureEvents commit:YES error:&createError]) {
                            NSLog(@"向日历修改事件成功");
                            convertedCourseInfo.eventIdentifier = courseInfoEvent.eventIdentifier;
                            [convertedCourseInfos addObject:convertedCourseInfo];
                        } else {
                            NSLog(@"向日历修改事件失败。%@", createError);
                        }
                    } else {
                        CourseInfo *convertedCourseInfo = [[CourseInfo alloc] init];
                        convertedCourseInfo.room = courseInfo.room;
                        convertedCourseInfo.teacher = courseInfo.teacher;
                        convertedCourseInfo.startTime = courseInfo.startTime;
                        convertedCourseInfo.endTime = courseInfo.endTime;
                        convertedCourseInfo.weeks = [NSArray arrayWithArray:courseInfo.weeks];
                        convertedCourseInfo.eventIdentifier = courseInfo.eventIdentifier;
                        [convertedCourseInfos addObject:convertedCourseInfo];
                    }
                }
            }
                break;
            case EZCourseStatusWillUnmatched: {
                CourseInfo *convertedCourseInfo = [[CourseInfo alloc] init];
                convertedCourseInfo.courseName = courseInfo.courseName;
                convertedCourseInfo.room = courseInfo.room;
                convertedCourseInfo.teacher = courseInfo.teacher;
                convertedCourseInfo.startTime = courseInfo.startTime;
                convertedCourseInfo.endTime = courseInfo.endTime;
                convertedCourseInfo.weeks = [NSArray arrayWithArray:courseInfo.weeks];
                convertedCourseInfo.eventIdentifier = courseInfo.eventIdentifier;
                [convertedCourseInfos addObject:convertedCourseInfo];
            }
                break;
        }
    }
    return [NSArray arrayWithArray:convertedCourseInfos];
}

- (void)deleteCourseInfosInCalendarOfCourse:(Course*)course{
    for (CourseInfo *courseInfo in course.courseInfos) {
        if (courseInfo.eventIdentifier.length > 0) {
            EKEvent *courseInfoEvent = [self.storeModel.eventStore eventWithIdentifier:courseInfo.eventIdentifier];
            if (courseInfoEvent != nil) {
                NSError *removeError;
                if ([self.storeModel.eventStore removeEvent:courseInfoEvent span:EKSpanFutureEvents commit:YES error:&removeError]) {
                    NSLog(@"从日历中删除课程成功");
                } else {
                    NSLog(@"从日历中删除失败。%@", removeError);
                }
            }
        }
    }
}

- (void)classifyCourseInfosToTimetableView {
    NSDateComponents *dateComponent = [[NSDateComponents alloc] init];
    dateComponent.day = 7 * self.window.timetableView.currentWeekPicker.indexOfSelectedItem;
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *currentDay = [gregorian dateByAddingComponents:dateComponent toDate:self.currentTimetable.firstWeek options:0];
    dateComponent.day = 0;
    if (self.storeModel.currentCalendar != nil) {
        NSArray *calendars = @[self.storeModel.currentCalendar];
        for (int day = 0; day < 7; day++) {
            [self.window.timetableView.courseInfos[day] removeAllObjects];
            currentDay = [gregorian dateByAddingComponents:dateComponent toDate:currentDay options:0];
            dateComponent.day = 1;
            NSDate *nextDay = [gregorian dateByAddingComponents:dateComponent toDate:currentDay options:0];
            NSPredicate *predicate = [self.storeModel.eventStore predicateForEventsWithStartDate:currentDay endDate:nextDay calendars:calendars];
            NSArray *currentEvents = [self.storeModel.eventStore eventsMatchingPredicate:predicate];
            NSMutableArray *currentIdentifiers = [NSMutableArray array];
            for (EKEvent *event in currentEvents) {
                [currentIdentifiers addObject:event.eventIdentifier];
            }
            for (Course *course in self.currentTimetable.courses) {
                for (CourseInfo *courseInfo in course.courseInfos) {
                    if ([currentIdentifiers containsObject:courseInfo.eventIdentifier]) {
                        [self.window.timetableView.courseInfos[day] addObject:courseInfo];
                    }
                }
            }
        }
    } else {
        for (int day = 0; day < 7; day++) {
            [self.window.timetableView.courseInfos[day] removeAllObjects];
        }
    }
}

#pragma mark - conform <NSTableViewDelegate, NSTableViewDataSource>
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView{
    return self.currentTimetable.courses.count;
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
    NSString *cellIdentifier;
    NSString *cellText;
    Course *cellCourse = self.currentTimetable.courses[row];
    if(tableColumn == tableView.tableColumns[0]){
        cellIdentifier = @"EZCourseNameID";
        cellText = cellCourse.courseName;
    } else {
        cellIdentifier = @"EZCourseStatusID";
        BOOL isCellMatched = YES;
        for(CourseInfo *courseInfo in cellCourse.courseInfos){
            isCellMatched = isCellMatched && [self eventStoreHasCourseInfo:courseInfo];
        }
        if(isCellMatched){
            cellText = @"已匹配";
        } else {
            cellText = @"未匹配";
        }
    }
    NSTableCellView *tableCellView = [tableView makeViewWithIdentifier:cellIdentifier owner:nil];
    tableCellView.textField.stringValue = cellText;
    return tableCellView;
}

- (void)tableViewSelectionDidChange:(NSNotification *)notification{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"EZCourseTableSelectionChanged" object:nil];
}

@end
