//
//  TimetableInfoWindowController.h
//  iTimetable
//
//  Created by Evian张 on 2018/11/3.
//  Copyright © 2018 Evian张. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <EventKit/EventKit.h>
#import "TimetableInfoWindow.h"
#import "EZTimetable.h"
#import "EZEventStore.h"

NS_ASSUME_NONNULL_BEGIN

@interface TimetableInfoWindowController : NSWindowController <NSWindowDelegate>

@property (nonatomic) EKSource *selectedSource;
@property (nonatomic) EKCalendar *selectedCalendar;
@property (nonatomic) EZEventStore *storeModel;
@property (nonatomic) EZTimetable *timetable;
@property (nonatomic) NSString *warningText;

@end

NS_ASSUME_NONNULL_END
