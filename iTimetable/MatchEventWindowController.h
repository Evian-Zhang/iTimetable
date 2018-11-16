//
//  MatchEventWindowController.h
//  iTimetable
//
//  Created by Evian张 on 2018/11/16.
//  Copyright © 2018 Evian张. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <EventKit/EventKit.h>
#import "MatchEventWindow.h"
#import "EZCourseInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface MatchEventWindowController : NSWindowController <NSTableViewDelegate, NSTableViewDataSource, NSWindowDelegate>

@property (weak) IBOutlet MatchEventWindow *window;

@property (nonatomic) EKEventStore *eventStore;
@property (nonatomic) NSArray *events;
@property (nonatomic) EKCalendar *calendar;
@property (nonatomic) NSDate *firstWeek;
@property (nonatomic) NSString *courseName;
@property (nonatomic) int row;

@end

NS_ASSUME_NONNULL_END
