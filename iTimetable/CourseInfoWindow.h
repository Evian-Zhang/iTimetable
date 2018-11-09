//
//  CourseInfoWindow.h
//  iTimetable
//
//  Created by Evian张 on 2018/11/8.
//  Copyright © 2018 Evian张. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface CourseInfoWindow : NSWindow

@property (nonatomic) IBOutlet NSTextField *roomText;
@property (nonatomic) IBOutlet NSTextField *teacherText;
@property (nonatomic) IBOutlet NSDatePicker *startTimePicker;
@property (nonatomic) IBOutlet NSDatePicker *endTimePicker;
@property (nonatomic) IBOutlet NSPopUpButton *startWeekPop;
@property (nonatomic) IBOutlet NSPopUpButton *endWeekPop;
@property (nonatomic) IBOutlet NSPopUpButton *singleDoublePicker;
@property (nonatomic) IBOutlet NSButton *alarmBtn;
@property (nonatomic) IBOutlet NSTextField *alarmTimeText;
@property (nonatomic) IBOutlet NSPopUpButton *alarmTypePop;
@property (nonatomic) IBOutlet NSButton *okBtn;
@property (nonatomic) IBOutlet NSButton *cancelBtn;

@end

NS_ASSUME_NONNULL_END
