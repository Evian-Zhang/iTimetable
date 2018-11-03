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
    [self initNotification];
    [self initPopUpButton];
    self.storeModel = [[EZEventStore alloc] init];
}

- (void)initNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(eventStoreForEventAccessSucessfullyNotificicationHandler) name:@"EZEventStoreForEventAccessSucessfully" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(eventStoreBForEventAccessUnsucessfullyNotificicationHandler) name:@"EZEventStoreForEventAccessUnsucessfully" object:nil];
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
    } else {
        self.storeModel.currentSource = [[EKSource alloc] init];
    }
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
        self.storeModel.currentCalendar = [[EKCalendar alloc] init];
    }
}

#pragma mark - Notification Handler
- (void)eventStoreForEventAccessSucessfullyNotificicationHandler{
    self.window.accessText.stringValue = @"获取日历权限成功";
    self.window.accessText.hidden = YES;
    self.window.sourceText.hidden = NO;
    self.window.sourcePop.hidden = NO;
    self.window.calText.hidden = NO;
    self.window.calPop.hidden = NO;
    self.storeModel.sources = [self.storeModel.eventStore sources];
    [self generateSorucePopUpItems];
    self.storeModel.calendars = [[self.storeModel.currentSource calendarsForEntityType:EKEntityTypeEvent] allObjects];
    [self generateCalendarPopUpItems];
}

- (void)eventStoreBForEventAccessUnsucessfullyNotificicationHandler{
    self.window.accessText.stringValue = @"获取日历权限失败";
    self.window.accessText.hidden = NO;
    self.window.sourceText.hidden = YES;
    self.window.sourcePop.hidden = YES;
    self.window.calText.hidden = YES;
    self.window.calPop.hidden = YES;
}

#pragma mark - PopUpButton Handler
- (void)sourcePopHandler{
    self.storeModel.currentSource = self.storeModel.sources[self.window.sourcePop.indexOfSelectedItem];
    [self.storeModel setCalendarsForSource:self.storeModel.currentSource];
    [self generateCalendarPopUpItems];
}

- (void)calPopHandler{
    self.storeModel.currentCalendar = self.storeModel.calendars[self.window.calPop.indexOfSelectedItem];
}

@end
