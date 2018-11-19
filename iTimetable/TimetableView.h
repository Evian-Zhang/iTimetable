//
//  TimetableView.h
//  iTimetable
//
//  Created by Evian张 on 2018/11/18.
//  Copyright © 2018 Evian张. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CourseInfo.h"
#import "EZTextFieldCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface TimetableView : NSView

@property (nonatomic) IBOutlet NSPopUpButton *currentWeekPicker;
@property (nonatomic) NSMutableArray<NSMutableArray<CourseInfo*>*> *courseInfos;
@property (nonatomic) NSDate *firstClassTime;
@property (nonatomic) int currentWeek;
@property (nonatomic) double dayLength;

@end

NS_ASSUME_NONNULL_END
