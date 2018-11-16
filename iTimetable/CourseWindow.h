//
//  CourseInfoWindow.h
//  iTimetable
//
//  Created by Evian张 on 2018/11/5.
//  Copyright © 2018 Evian张. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface CourseWindow : NSWindow

@property (nonatomic) IBOutlet NSTextField *courseNameText;
@property (nonatomic) IBOutlet NSTableView *courseInfoTable;
@property (nonatomic) IBOutlet NSButton *createCourseInfoButton;
@property (nonatomic) IBOutlet NSButton *okButton;
@property (nonatomic) IBOutlet NSButton *cancelButton;
@property (nonatomic) IBOutlet NSMenu *contextualMenu;
@property (nonatomic) IBOutlet NSMenuItem *createCourseInfoItem;
@property (nonatomic) IBOutlet NSMenuItem *changeCourseInfoItem;
@property (nonatomic) IBOutlet NSMenuItem *markCourseInfoWillCreatedItem;
@property (nonatomic) IBOutlet NSMenuItem *markCourseInfoWillMatchedItem;
@property (nonatomic) IBOutlet NSMenuItem *markCourseInfoWillDeletedItem;
@property (nonatomic) NSInteger currentRow;

@end

NS_ASSUME_NONNULL_END
