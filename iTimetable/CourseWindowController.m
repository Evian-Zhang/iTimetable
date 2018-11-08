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

- (void)windowDidLoad {
    [super windowDidLoad];
    
    self.window.courseNameText.stringValue = self.course.courseName;
    
    self.window.okButton.target = self;
    self.window.okButton.action = @selector(okButtonHandler);
    
    self.window.cancelButton.target = self;
    self.window.cancelButton.action = @selector(cancelButtonHandler);
    
    self.window.createCourseInfoButton.target = self;
    self.window.createCourseInfoButton.action = @selector(createCourseInfoButtonHandler);
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

- (void)createCourseInfoButtonHandler{
    
}

- (BOOL)statusOfCourseInfo:(CourseInfo *)courseInfo{
    if([self.eventStore eventWithIdentifier:courseInfo.eventIdentifier] != nil){
        return TRUE;
    } else {
        return FALSE;
    }
}

- (BOOL)checkValidation{
    return TRUE;
}

- (void)windowWillClose:(NSNotification *)notification{
    [NSApp stopModal];
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
    CourseInfo *cellCourseInfo = self.course.courseInfos[row];
    if(tableColumn == tableView.tableColumns[0]){
        cellIdentifier = @"EZCourseInfoRoomID";
        cellText = cellCourseInfo.room;
    } else if(tableColumn == tableView.tableColumns[1]){
        cellIdentifier = @"EZCourseInfoTeacherID";
        cellText = cellCourseInfo.teacher;
    } else if(tableColumn == tableView.tableColumns[2]){
        cellIdentifier = @"EZCourseInfoStartTimeID";
        cellText = [dateFormatter stringFromDate:cellCourseInfo.startTime];
    } else if(tableColumn == tableView.tableColumns[3]){
        cellIdentifier = @"EZCourseInfoEndTimeID";
        cellText = [dateFormatter stringFromDate:cellCourseInfo.endTime];
    } else if(tableColumn == tableView.tableColumns[4]){
        cellIdentifier = @"EZCourseInfoWeeksID";
        cellText = [cellCourseInfo.weeks componentsJoinedByString:@", "];
    } else if(tableColumn == tableView.tableColumns[5]){
        cellIdentifier = @"EZCourseInfoStatusID";
    } else if(tableColumn == tableView.tableColumns[6]){
        cellIdentifier = @"EZCourseInfoAlarmID";
    }
    NSTableCellView *tableCellView = [tableView makeViewWithIdentifier:cellIdentifier owner:nil];
    tableCellView.textField.stringValue = cellText;
    return tableCellView;
}

- (void)tableViewSelectionDidChange:(NSNotification *)notification{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"EZCourseTableSelectionChanged" object:nil];
}

@end
