//
//  TimetableInfoWindow.h
//  iTimetable
//
//  Created by Evian张 on 2018/11/3.
//  Copyright © 2018 Evian张. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface TimetableInfoWindow : NSWindow

@property (nonatomic) IBOutlet NSPopUpButton *sourcePop;
@property (nonatomic) IBOutlet NSPopUpButton *calPop;
@property (nonatomic) IBOutlet NSDatePicker *firstWeekPicker;
@property (nonatomic) IBOutlet NSTextField *semesterLengthText;
@property (nonatomic) IBOutlet NSDatePicker *firstClassPicker;
@property (nonatomic) IBOutlet NSDatePicker *lastClassPicker;
@property (nonatomic) IBOutlet NSButton *okBtn;
@property (nonatomic) IBOutlet NSButton *cancelBtn;

@end

NS_ASSUME_NONNULL_END
