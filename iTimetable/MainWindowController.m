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
    self.window.createTimetableBtn.action = @selector(createTimetableBtnHandler);
    [self initNotification];
    [self initPopUpButton];
    self.storeModel = [[EZEventStore alloc] init];
    //self.timetables = self.persistentContainer
}

- (void)initNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(eventStoreForEventAccessSuccessfullyNotificicationHandler) name:@"EZEventStoreForEventAccessSuccessfully" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(eventStoreBForEventAccessUnsuccessfullyNotificicationHandler) name:@"EZEventStoreForEventAccessUnsuccessfully" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(timetableGetSuccessfullyHandler:) name:@"EZTimetableGetSuccessfully" object:nil];
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
    self.currentTimetable.firstWeek = tmpTimetable.firstWeek;
    self.currentTimetable.firstClassTime = tmpTimetable.firstClassTime;
    self.currentTimetable.lastClassTime = tmpTimetable.lastClassTime;
    self.currentTimetable.semesterLength = tmpTimetable.semesterLength;
    
    Timetable *timeTable = [NSEntityDescription  insertNewObjectForEntityForName:@"Timetable"  inManagedObjectContext:self.persistentContainer.viewContext];
    timeTable.calendarIdentifier = self.currentTimetable.calendarIdentifier;
    timeTable.sourceIdentifier = self.currentTimetable.sourceIdentifier;
    timeTable.firstWeek = self.currentTimetable.firstWeek;
    timeTable.firstClassTime = self.currentTimetable.firstClassTime;
    timeTable.lastClassTime = self.currentTimetable.lastClassTime;
    timeTable.semesterLength = self.currentTimetable.semesterLength;
    timeTable.courses = self.currentTimetable.courses;
    
    NSError *error = nil;
    if ([self.persistentContainer.viewContext save:&error]) {
        NSLog(@"数据插入到数据库成功");
    }else{
        NSLog(@"%@", [NSString stringWithFormat:@"数据插入到数据库失败, %@",error]);
    }
    [self checkTimetable];
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
}

#pragma mark - Button Handler
- (void)createTimetableBtnHandler{
    self.currentTimetable = [[EZTimetable alloc] init];
    self.currentTimetable.sourceIdentifier = self.storeModel.currentSource.sourceIdentifier;
    self.currentTimetable.calendarIdentifier = self.storeModel.currentCalendar.calendarIdentifier;
    self.timetableInfoWindowController = [[TimetableInfoWindowController alloc] initWithWindowNibName:@"TimetableInfoWindowController"];
    self.timetableInfoWindowController.timetable = self.currentTimetable;
    [NSApp runModalForWindow:self.timetableInfoWindowController.window];
}

#pragma mark - delete
- (void)deleteTimetable{
    NSFetchRequest *deleRequest = [NSFetchRequest fetchRequestWithEntityName:@"Timetable"];
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"calendarIdentifier = %@", self.storeModel.currentCalendar.calendarIdentifier];
    deleRequest.predicate = pre;
    
    //返回需要删除的对象数组
    NSArray *deleArray = [self.persistentContainer.viewContext executeFetchRequest:deleRequest error:nil];
    
    //从数据库中删除
    [self.persistentContainer.viewContext deleteObject:deleArray[0]];
    
    NSError *error = nil;
    //保存--记住保存
    if ([self.persistentContainer.viewContext save:&error]) {
        NSLog(@"删除成功");
    }else{
        NSLog(@"删除数据失败, %@", error);
    }
    [self checkTimetable];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"EZCalendarChanged" object:nil];
}

#pragma mark - checker
- (void)checkCalendarEmpty{
    if(self.storeModel.calendars.count > 0){
        self.window.createTimetableBtn.enabled = YES;
    } else {
        self.window.createTimetableBtn.enabled = NO;
    }
}

- (BOOL)checkTimetable{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Timetable"];
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"calendarIdentifier = %@", self.storeModel.currentCalendar.calendarIdentifier];
    request.predicate = pre;
    NSArray *resArray = [self.persistentContainer.viewContext executeFetchRequest:request error:nil];
    if(resArray.count == 0){
        [self checkCalendarEmpty];
        self.window.scrollView.hidden = YES;
        self.window.createTimetableBtn.hidden = NO;
        return NO;
    } else {
        self.window.createTimetableBtn.enabled = NO;
        self.window.scrollView.hidden = NO;
        self.window.createTimetableBtn.hidden = YES;
        self.currentTimetable = resArray[0];
        return YES;
    }
}

@end
