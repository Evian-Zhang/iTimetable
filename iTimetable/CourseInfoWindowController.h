//
//  CoreseInfoWindowController.h
//  iTimetable
//
//  Created by Evian张 on 2018/11/8.
//  Copyright © 2018 Evian张. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CourseInfoWindow.h"
#import "EZCourseInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface CourseInfoWindowController : NSWindowController <NSWindowDelegate>

@property (weak) IBOutlet CourseInfoWindow *window;
@property (nonatomic) EZCourseInfo *courseInfo;
@property (nonatomic) BOOL hasAlarm;
@property (nonatomic) BOOL isCreating;
@property (nonatomic) NSString *warningText;
@property (nonatomic) int row;

@end

NS_ASSUME_NONNULL_END
