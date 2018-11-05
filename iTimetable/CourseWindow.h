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
@property (nonatomic) IBOutlet NSTableView *courseTableView;
@property (nonatomic) IBOutlet NSButton *createCourseInfoButton;
@property (nonatomic) IBOutlet NSButton *okButton;
@property (nonatomic) IBOutlet NSButton *cancelButton;

@end

NS_ASSUME_NONNULL_END
