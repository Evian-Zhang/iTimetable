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
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool: NO forKey:@"isEventStoreAccessed"];
    self.window.accessText.stringValue = @"正在获取日历访问权限";
    self.window.accessText.hidden = NO;
    self.window.sourceText.hidden = YES;
    self.window.sourcePop.hidden = YES;
    self.window.calText.hidden = YES;
    self.window.calPop.hidden = YES;
    [self initNotification];
    [self initPopUpButton];
    self.storeModel = [[EZEventStore alloc] init];
/*
 self.view.notificationText.stringValue = @"正在获取日历源...";
 self.view.dateSetButton.enabled = NO;
 
 //accessEventStore
 [self.eventModel accessEventStore];
 
 self.view.aButton.target = self;
 self.view.aButton.action = @selector(aButtonHandler);
 //if has access to dataBase
 if(isDBAccessed){
 //access source and calendar
 [self.eventModel accessSources];
 [self.eventModel accessCalendars];
 
 //clear popUpButton
 [self.view.sourceSelector removeAllItems];
 [self.view.calSelector removeAllItems];
 
 //set default source popUpButton
 for(EKSource *source in self.eventModel.eventSources){
 NSMenuItem *sourceItem = [[NSMenuItem alloc] initWithTitle:source.title action:nil keyEquivalent:@""];
 [self.view.sourceSelector.menu addItem:sourceItem];
 }
 [self.view.sourceSelector setTarget:self];
 [self.view.sourceSelector setAction:@selector(sourceSelectorHandler)];
 
 //set default selected source
 if(self.eventModel.eventSources.count != 0){
 self.entitySource = self.eventModel.eventSources[0];
 
 //set default calendar popUpButton
 for(EKCalendar *calendar in [self.eventModel calendarsForSource:self.entitySource]){
 NSMenuItem *calendarItem = [[NSMenuItem alloc] initWithTitle:calendar.title action:nil keyEquivalent:@""];
 [self.view.calSelector.menu addItem:calendarItem];
 }
 [self.view.calSelector setTarget:self];
 [self.view.calSelector setAction:@selector(calSelectorHandler)];
 
 //set dateSetButton
 if([self.eventModel calendarsForSource:self.entitySource].count != 0){
 self.calendarSource = [self.eventModel calendarsForSource:self.entitySource][0];
 NSArray *calArray = @[self.calendarSource];
 [self.eventModel makeEntrysForCalendar:calArray];
 self.view.dateSetButton.enabled = YES;
 } else {
 [self.eventModel makeEntrysEmpty];
 self.view.dateSetButton.enabled = NO;
 }
 }
 
 //set popover
 self.popover = [[NSPopover alloc] init];
 self.popover.behavior = NSPopoverBehaviorTransient;
 
 self.popoverViewController = [[LCPopoverViewController alloc] initWithNibName:@"LCPopoverViewController" bundle:nil];
 self.popover.contentViewController = self.popoverViewController;
 
 //initialize startDate and endDate
 self.startDate = [NSDate date];
 NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
 NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
 [offsetComponents setYear:1];
 self.endDate = [gregorian dateByAddingComponents:offsetComponents toDate:self.startDate options:0];
 self.eventModel.startDate = self.startDate;
 self.eventModel.endDate = self.endDate;
 
 //set dateSetButton
 self.view.dateSetButton.target = self;
 self.view.dateSetButton.action = @selector(showPopover:);
 self.view.entryTableView.dataSource = self;
 self.view.entryTableView.delegate = self;
 [self.view.entryTableView reloadData];
 }
 */
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
