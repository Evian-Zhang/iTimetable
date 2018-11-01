//
//  MainWindowController.h
//  iTimetable
//
//  Created by Evian张 on 2018/11/1.
//  Copyright © 2018 Evian张. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MainWindow.h"
#import "EZEventStore.h"

NS_ASSUME_NONNULL_BEGIN

@interface MainWindowController : NSWindowController

@property (nonatomic) EZEventStore *storeModel;

@end

NS_ASSUME_NONNULL_END
