//
//  CourseInfoWindowController.m
//  iTimetable
//
//  Created by Evian张 on 2018/11/5.
//  Copyright © 2018 Evian张. All rights reserved.
//

#import "CourseWindowController.h"

@interface CourseWindowController ()

@end

@implementation CourseWindowController
@synthesize course = _course;
@synthesize eventStore = _eventStore;
@synthesize isCreating = _isCreating;
@synthesize names = _names;
@synthesize statuses = _statuses;
@synthesize warningText = _warningText;

- (void)windowDidLoad {
    [super windowDidLoad];
    
    self.window.courseNameText.stringValue = self.course.courseName;
    
    self.window.okButton.target = self;
    self.window.okButton.action = @selector(okButtonHandler);
    self.window.okButton.keyEquivalent = @"\r";
    
    self.window.cancelButton.target = self;
    self.window.cancelButton.action = @selector(cancelButtonHandler);
    
    self.window.createCourseInfoButton.target = self;
    self.window.createCourseInfoButton.action = @selector(createCourseInfo);
    
    self.window.courseInfoTable.delegate = self;
    self.window.courseInfoTable.dataSource = self;
    
    self.statuses = [NSMutableArray array];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(EZCourseInfoGetSuccessfullyNotificicationHandler:) name:@"EZCourseInfoGetSuccessfully" object:nil];
}

#pragma mark - Button Handler
- (void)okButtonHandler{
    if([self checkValidation]){
        self.course.courseName = self.window.courseNameText.stringValue;
        NSDictionary *userInfo = @{@"course": self.course, @"isCreating": [NSNumber numberWithBool:self.isCreating]};
        [[NSNotificationCenter defaultCenter] postNotificationName:@"EZCourseGetSuccessfully" object:nil userInfo:userInfo];
        [self cancelButtonHandler];
    }
}

- (void)cancelButtonHandler{
    [NSApp stopModal];
    [self.window close];
}

- (void)createCourseInfo{
    self.courseInfoWindowController = [[CourseInfoWindowController alloc] initWithWindowNibName:@"CourseInfoWindowController"];
    EZCourseInfo *courseInfo = [[EZCourseInfo alloc] initWithFirstWeek:self.course.firstWeek semesterLength:self.course.semesterLength];
    self.courseInfoWindowController.isCreating = YES;
    self.courseInfoWindowController.courseInfo = courseInfo;
    [NSApp runModalForWindow:self.courseInfoWindowController.window];
}

- (void)changeCourseInfo{
    self.courseInfoWindowController = [[CourseInfoWindowController alloc] initWithWindowNibName:@"CourseInfoWindowController"];
    EZCourseInfo *courseInfo = self.course.courseInfos[self.window.courseInfoTable.selectedRow];
    self.courseInfoWindowController.isCreating = NO;
    self.courseInfoWindowController.courseInfo = courseInfo;
    [NSApp runModalForWindow:self.courseInfoWindowController.window];
}

- (void)deleteCourseInfo{
    
}

- (void)EZCourseInfoGetSuccessfullyNotificicationHandler:(NSNotification*)aNotification{
    NSDictionary *userInfo = aNotification.userInfo;
    EZCourseInfo *courseInfo = [userInfo objectForKey:@"courseInfo"];
    NSNumber *tmpNumber = [userInfo objectForKey:@"isCreating"];
    BOOL tmpFlag = tmpNumber.boolValue;
    [self.course.courseInfos addObject:courseInfo];
    [self.window.courseInfoTable reloadData];
}

- (BOOL)statusOfCourseInfo:(CourseInfo *)courseInfo{
    if([self.eventStore eventWithIdentifier:courseInfo.eventIdentifier] != nil){
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)checkValidation{
    BOOL isValid = YES;
    if([self.names containsObject:self.window.courseNameText.stringValue]){
        isValid = NO;
        self.warningText = [self.warningText stringByAppendingString:@"课程名不得重复。\n"];
    }
    if(self.course.courseInfos.count == 0){
        isValid = NO;
        self.warningText = [self.warningText stringByAppendingString:@"至少得有一个时段。\n"];
    }
    return isValid;
}

- (void)windowWillClose:(NSNotification *)notification{
    [NSApp stopModal];
}

- (BOOL)checkCourseInfoSelected{
    if(self.window.courseInfoTable.selectedRow >= 0){
        return YES;
    } else {
        return NO;
    }
}

#pragma mark - conform <NSTableViewDelegate, NSTableViewDataSource>
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView{
    return self.course.courseInfos.count;
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
    NSString *cellIdentifier;
    NSString *cellText;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"HH:mm:ss";
    EZCourseInfo *cellCourseInfo = self.course.courseInfos[row];
    if(tableColumn == tableView.tableColumns[0]){
        cellIdentifier = @"EZCourseInfoRoomID";
        cellText = cellCourseInfo.room;
    } else if(tableColumn == tableView.tableColumns[1]){
        cellIdentifier = @"EZCourseInfoTeacherID";
        cellText = cellCourseInfo.teacher;
    } else if(tableColumn == tableView.tableColumns[2]){
        cellIdentifier = @"EZCourseInfoDayID";
        switch (cellCourseInfo.day) {
            case 0:
                cellText = @"周一";
                break;
            case 1:
                cellText = @"周二";
                break;
            case 2:
                cellText = @"周三";
                break;
            case 3:
                cellText = @"周四";
                break;
            case 4:
                cellText = @"周五";
                break;
            case 5:
                cellText = @"周六";
                break;
            case 6:
                cellText = @"周日";
            default:
                cellText = @"周一";
                break;
        }
    } else if(tableColumn == tableView.tableColumns[3]){
        cellIdentifier = @"EZCourseInfoStartTimeID";
        cellText = [dateFormatter stringFromDate:cellCourseInfo.startTime];
    } else if(tableColumn == tableView.tableColumns[4]){
        cellIdentifier = @"EZCourseInfoEndTimeID";
        cellText = [dateFormatter stringFromDate:cellCourseInfo.endTime];
    } else if(tableColumn == tableView.tableColumns[5]){
        cellIdentifier = @"EZCourseInfoWeeksID";
        cellText = [cellCourseInfo.weeks componentsJoinedByString:@", "];
    } else if(tableColumn == tableView.tableColumns[6]){
        cellIdentifier = @"EZCourseInfoStatusID";
    } else if(tableColumn == tableView.tableColumns[7]){
        cellIdentifier = @"EZCourseInfoAlarmID";
    }
    NSTableCellView *tableCellView = [tableView makeViewWithIdentifier:cellIdentifier owner:nil];
    if(cellText != NULL){
        tableCellView.textField.stringValue = cellText;
    }
    return tableCellView;
}

- (void)tableViewSelectionDidChange:(NSNotification *)notification{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"EZCourseInfoTableSelectionChanged" object:nil];
}

@end
