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
    self.storeModel = [[EZEventStore alloc] init];
    self.window.courseTable.dataSource = self;
    self.window.courseTable.delegate = self;
}

- (void)initNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(eventStoreForEventAccessSuccessfullyNotificicationHandler) name:@"EZEventStoreForEventAccessSuccessfully" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(eventStoreBForEventAccessUnsuccessfullyNotificicationHandler) name:@"EZEventStoreForEventAccessUnsuccessfully" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(timetableGetSuccessfullyHandler:) name:@"EZTimetableGetSuccessfully" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(courseGetSuccessfullyHandler:) name:@"EZCourseGetSuccessfully" object:nil];
}

- (void)initPopUpButton{
    [self.window.sourcePop setTarget:self];
    [self.window.sourcePop setAction:@selector(sourcePopHandler)];
    
    [self.window.calPop setTarget:self];
    [self.window.calPop setAction:@selector(calPopHandler)];
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
    [[NSNotificationCenter defaultCenter] postNotificationName:@"EZCalendarChanged" object:nil];
}

#pragma mark - Notification Handler
- (void)eventStoreForEventAccessSuccessfullyNotificicationHandler{
    self.window.accessText.stringValue = @"获取日历权限成功";
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
    self.window.accessText.stringValue = @"获取日历权限失败";
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
        Timetable *timetable = [NSEntityDescription  insertNewObjectForEntityForName:@"Timetable"  inManagedObjectContext:self.persistentContainer.viewContext];
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
    [self checkTimetable];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"EZCalendarChanged" object:nil];
}

- (void)courseGetSuccessfullyHandler:(NSNotification*)aNotification{
    EZCourse *tmpCourse = [[aNotification userInfo] valueForKey:@"course"];
    NSNumber *tmpNumber = [[aNotification userInfo] valueForKey:@"isCreating"];
    BOOL tmpFlag = tmpNumber.boolValue;
    if(tmpFlag){
        Course *course = [[Course alloc] init];
        course.courseName = tmpCourse.courseName;
        course.courseInfos = [NSArray arrayWithArray:tmpCourse.courseInfos];
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
        for(course in self.currentTimetable.courses){
            if([course.courseName isEqualToString:tmpCourse.courseName]){
                course.courseInfos = [NSArray arrayWithArray:tmpCourse.courseInfos];
                break;
            }
        }
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
    [[NSNotificationCenter defaultCenter] postNotificationName:@"EZCalendarChanged" object:nil];
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
    [[NSNotificationCenter defaultCenter] postNotificationName:@"EZCalendarChanged" object:nil];
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
    [[NSNotificationCenter defaultCenter] postNotificationName:@"EZCalendarChanged" object:nil];
}

#pragma mark - create course
- (void)createCourse{
    EZCourse *course = [[EZCourse alloc] init];
    self.courseWindowController = [[CourseWindowController alloc] initWithWindowNibName:@"CourseWindowController"];
    self.courseWindowController.course = course;
    self.courseWindowController.eventStore = self.storeModel.eventStore;
    self.courseWindowController.isCreating = YES;
    [NSApp runModalForWindow:self.courseWindowController.window];
}

#pragma mark - change course
- (void)changeCourse{
    if(self.window.courseTable.selectedRow >= 0){
        self.courseWindowController = [[CourseWindowController alloc] initWithWindowNibName:@"CourseWindowController"];
        Course *tmpCourse = self.currentTimetable.courses[self.window.courseTable.selectedRow];
        EZCourse *course = [[EZCourse alloc] init];
        course.courseName = tmpCourse.courseName;
        course.courseInfos = [NSMutableArray arrayWithArray:tmpCourse.courseInfos];
        self.courseWindowController.course = course;
        self.courseWindowController.eventStore = self.storeModel.eventStore;
        self.courseWindowController.isCreating = NO;
        [NSApp runModalForWindow:self.courseWindowController.window];
    }
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
        return YES;
    }
}

- (BOOL)checkCourseSelected{
    if(self.window.courseTable.selectedRow >= 0){
        return YES;
    } else {
        return NO;
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
            isCellMatched = isCellMatched && [self.courseWindowController statusOfCourseInfo:courseInfo];
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
