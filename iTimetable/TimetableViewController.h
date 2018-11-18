//
//  TimetableViewController.h
//  iTimetable
//
//  Created by Evian张 on 2018/11/18.
//  Copyright © 2018 Evian张. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "TimetableView.h"

NS_ASSUME_NONNULL_BEGIN

@interface TimetableViewController : NSViewController

@property (weak) IBOutlet TimetableView *view;

@end

NS_ASSUME_NONNULL_END
