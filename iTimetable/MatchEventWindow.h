//
//  MatchEventWindow.h
//  iTimetable
//
//  Created by Evian张 on 2018/11/16.
//  Copyright © 2018 Evian张. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface MatchEventWindow : NSWindow

@property (nonatomic) IBOutlet NSDatePicker *datePicker;
@property (nonatomic) IBOutlet NSTableView *eventTable;
@property (nonatomic) IBOutlet NSButton *displayButton;
@property (nonatomic) IBOutlet NSButton *okButton;
@property (nonatomic) IBOutlet NSButton *cancelButton;

@end

NS_ASSUME_NONNULL_END
