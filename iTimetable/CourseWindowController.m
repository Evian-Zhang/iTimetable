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
@synthesize deleteCount = _deleteCount;

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
    
    self.deleteCount = 0;
    
    self.warningText = [NSString string];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(EZCourseInfoGetSuccessfullyNotificicationHandler:) name:@"EZCourseInfoGetSuccessfully" object:nil];
}

#pragma mark - Button Handler
- (void)okButtonHandler{
    if ([self checkValidation]) {
        self.course.courseName = self.window.courseNameText.stringValue;
        NSDictionary *userInfo = @{@"course": self.course, @"isCreating": [NSNumber numberWithBool:self.isCreating]};
        [[NSNotificationCenter defaultCenter] postNotificationName:@"EZCourseGetSuccessfully" object:nil userInfo:userInfo];
        [self cancelButtonHandler];
    } else {
        NSAlert *alert = [NSAlert new];
        [alert addButtonWithTitle:@"确定"];
        [alert setMessageText:@"错误"];
        [alert setInformativeText:self.warningText];
        [alert setAlertStyle:NSAlertStyleWarning];
        [alert beginSheetModalForWindow:self.window completionHandler:^(NSModalResponse returnCode) {}];
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
    self.courseInfoWindowController.row = -1;
    [NSApp runModalForWindow:self.courseInfoWindowController.window];
}

- (void)changeCourseInfo{
    self.courseInfoWindowController = [[CourseInfoWindowController alloc] initWithWindowNibName:@"CourseInfoWindowController"];
    EZCourseInfo *courseInfo = self.course.courseInfos[self.window.currentRow];
    self.courseInfoWindowController.isCreating = NO;
    self.courseInfoWindowController.courseInfo = courseInfo;
    self.courseInfoWindowController.row = self.window.currentRow;
    [NSApp runModalForWindow:self.courseInfoWindowController.window];
}

- (void)markCourseInfoWillCreated{
    EZCourseInfo *courseInfo = self.course.courseInfos[self.window.currentRow];
    switch (courseInfo.status) {
        case EZCourseStatusWillDelete:
            self.deleteCount--;
            break;
            
        default:
            break;
    }
    courseInfo.eventIdentifier = [NSString string];
    courseInfo.status = EZCourseStatusWillCreate;
    [self.window.courseInfoTable reloadData];
}

- (void)markCourseInfoWillMatched{
    EZCourseInfo *courseInfo = self.course.courseInfos[self.window.currentRow];
    switch (courseInfo.status) {
        case EZCourseStatusWillDelete:
            self.deleteCount--;
            break;
            
        default:
            break;
    }
    courseInfo.status = EZCourseStatusWillMatched;
    [self.window.courseInfoTable reloadData];
}

- (void)markCourseInfoWillDeleted{
    EZCourseInfo *courseInfo = self.course.courseInfos[self.window.currentRow];
    courseInfo.status = EZCourseStatusWillDelete;
    self.deleteCount++;
    [self.window.courseInfoTable reloadData];
}

- (void)EZCourseInfoGetSuccessfullyNotificicationHandler:(NSNotification*)aNotification{
    NSDictionary *userInfo = aNotification.userInfo;
    EZCourseInfo *courseInfo = [userInfo objectForKey:@"courseInfo"];
    NSNumber *tmpNumber = [userInfo objectForKey:@"isCreating"];
    BOOL isCreating = tmpNumber.boolValue;
    if (isCreating) {
        [self.course.courseInfos addObject:courseInfo];
    } else {
        
    }
    [self.window.courseInfoTable reloadData];
}

- (BOOL)checkValidation{
    BOOL isValid = YES;
    self.warningText = [NSString string];
    if([self.names containsObject:self.window.courseNameText.stringValue]){
        isValid = NO;
        self.warningText = [self.warningText stringByAppendingString:@"课程名不得重复。\n"];
    }
    if(self.course.courseInfos.count - self.deleteCount == 0){
        isValid = NO;
        self.warningText = [self.warningText stringByAppendingString:@"至少得有一个时段。\n"];
    }
    return isValid;
}

- (BOOL)isMarkCourseInfoWillCreatedEnabled{
    BOOL isEnabled = YES;
    if (![self checkCourseInfoSelected]) {
        isEnabled = NO;
    } else {
        EZCourseInfo *currentCourseInfo = self.course.courseInfos[self.window.currentRow];
        switch (currentCourseInfo.status) {
            case EZCourseStatusWillCreate:
                isEnabled = NO;
                break;
                
            default:
                break;
        }
    }
    return isEnabled;
}

- (BOOL)isMarkCourseInfoWillMatchedEnabled{
    BOOL isEnabled = YES;
    if (![self checkCourseInfoSelected]) {
        isEnabled = NO;
    } else {
        EZCourseInfo *currentCourseInfo = self.course.courseInfos[self.window.currentRow];
        switch (currentCourseInfo.status) {
            case EZCourseStatusWillMatched:
                isEnabled = NO;
                break;
                
            default:
                break;
        }
    }
    return isEnabled;
}

- (BOOL)isMarkCourseInfoWillDeletedEnabled{
    BOOL isEnabled = YES;
    if (![self checkCourseInfoSelected]) {
        isEnabled = NO;
    } else {
        EZCourseInfo *currentCourseInfo = self.course.courseInfos[self.window.currentRow];
        switch (currentCourseInfo.status) {
            case EZCourseStatusWillDelete:
                isEnabled = NO;
                break;
                
            default:
                break;
        }
    }
    return isEnabled;
}

- (void)windowWillClose:(NSNotification *)notification{
    [NSApp stopModal];
}

- (BOOL)checkCourseInfoSelected{
    if(self.window.currentRow >= 0){
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
        switch (cellCourseInfo.status) {
            case EZCourseStatusWillCreate:
                cellText = @"将生成";
                break;
            case EZCourseStatusHasMatched:
                cellText = @"已匹配";
                break;
            case EZCourseStatusNotMatched:
                cellText = @"未匹配";
                break;
            case EZCourseStatusWillDelete:
                cellText = @"将删除";
                break;
            case EZCourseStatusWillMatched:
                cellText = @"将匹配";
                break;
        }
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
