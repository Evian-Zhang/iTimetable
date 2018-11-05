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

@end
