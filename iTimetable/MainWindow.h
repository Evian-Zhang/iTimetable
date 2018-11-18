//
//  MainWindow.h
//  iTimetable
//
//  Created by Evian张 on 2018/11/1.
//  Copyright © 2018 Evian张. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "TimetableViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface MainWindow : NSWindow

@property (nonatomic) IBOutlet NSSplitView *splitView;
@property (nonatomic) IBOutlet NSTextField *accessText;
@property (nonatomic) IBOutlet NSTextField *sourceText;
@property (nonatomic) IBOutlet NSPopUpButton *sourcePop;
@property (nonatomic) IBOutlet NSTextField *calText;
@property (nonatomic) IBOutlet NSPopUpButton *calPop;
@property (nonatomic) IBOutlet NSButton *createTimetableBtn;
@property (nonatomic) IBOutlet NSTableView *courseTable;
@property (nonatomic) IBOutlet NSScrollView *scrollView;
@property (nonatomic) IBOutlet NSMenuItem *createCourseItem;
@property (nonatomic) IBOutlet NSMenuItem *changeCourseItem;
@property (nonatomic) IBOutlet NSMenuItem *deleteCourseItem;
@property (nonatomic) IBOutlet NSMenu *contextualMenu;
@property (nonatomic) IBOutlet NSScrollView *timetableScrollView;
@property (nonatomic) TimetableViewController *timetableViewController;
@property (nonatomic) NSInteger currentRow;

@end

NS_ASSUME_NONNULL_END
