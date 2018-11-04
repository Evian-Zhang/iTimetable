//
//  EZEventStore.h
//  iTimetable
//
//  Created by Evian张 on 2018/11/1.
//  Copyright © 2018 Evian张. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <EventKit/EventKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface EZEventStore : NSObject

@property (nonatomic) EKEventStore *eventStore;
@property (nonatomic, copy) NSArray *sources;
@property (nonatomic, copy) NSArray *calendars;
@property (nonatomic, nullable) EKSource *currentSource;
@property (nonatomic, nullable) EKCalendar *currentCalendar;

- (void)generateCalendars;

@end

NS_ASSUME_NONNULL_END
