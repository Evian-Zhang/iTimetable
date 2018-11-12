//
//  AppDelegate.h
//  iTimetable
//
//  Created by Evian张 on 2018/11/1.
//  Copyright © 2018 Evian张. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MainWindowController.h"

@interface AppDelegate : NSObject <NSApplicationDelegate, NSValidatedUserInterfaceItem>

@property (readonly, strong) NSPersistentContainer *persistentContainer;
@property (nonatomic) MainWindowController *mainWindowController;
@property (nonatomic) IBOutlet NSMenuItem *createTimetableItem;
@property (nonatomic) IBOutlet NSMenuItem *changeTimetableItem;
@property (nonatomic) IBOutlet NSMenuItem *deleteTimetableItem;
@property (nonatomic) IBOutlet NSMenuItem *createCourseItem;
@property (nonatomic) IBOutlet NSMenuItem *changeCourseItem;
@property (nonatomic) IBOutlet NSMenuItem *deleteCourseItem;
@property (nonatomic) IBOutlet NSMenuItem *createCourseInfoItem;
@property (nonatomic) IBOutlet NSMenuItem *changeCourseInfoItem;
@property (nonatomic) IBOutlet NSMenuItem *deleteCourseInfoItem;

@end

