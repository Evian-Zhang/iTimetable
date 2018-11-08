//
//  CoreseInfoWindowController.h
//  iTimetable
//
//  Created by Evian张 on 2018/11/8.
//  Copyright © 2018 Evian张. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CourseInfoWindow.h"

NS_ASSUME_NONNULL_BEGIN

@interface CoreseInfoWindowController : NSWindowController

@property (weak) IBOutlet CourseInfoWindow *window;

@end

NS_ASSUME_NONNULL_END
