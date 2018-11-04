//
//  EZEventStore.m
//  iTimetable
//
//  Created by Evian张 on 2018/11/1.
//  Copyright © 2018 Evian张. All rights reserved.
//

#import "EZEventStore.h"

@implementation EZEventStore
@synthesize eventStore = _eventStore;
@synthesize sources = _sources;
@synthesize calendars = _calendars;
@synthesize currentSource = _currentSource;
@synthesize currentCalendar = _currentCalendar;

- (instancetype)init{
    if(self = [super init]){
        self.eventStore = [[EKEventStore alloc] init];
        self.currentSource = [[EKSource alloc] init];
        self.currentCalendar = [[EKCalendar alloc] init];
        [self.eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError * _Nullable error) {
            if (granted) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"EZEventStoreForEventAccessSuccessfully" object:nil];
                NSLog(@"AccessEventSuccessfully");
            } else {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"EZEventStoreForEventAccessUnsuccessfully" object:nil];
                NSLog(@"AccessEventUnsuccessfully");
            }
        }];
        return self;
    }
    return nil;
}

- (void)generateCalendars{
    self.calendars = [[self.currentSource calendarsForEntityType:EKEntityTypeEvent] allObjects];
}

@end
