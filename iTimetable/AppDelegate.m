//
//  AppDelegate.m
//  iTimetable
//
//  Created by Evian张 on 2018/11/1.
//  Copyright © 2018 Evian张. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate
@synthesize mainWindowController = _mainWindowController;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    _mainWindowController = [[MainWindowController alloc] initWithWindowNibName:@"MainWindowController"];
    
    [self.mainWindowController.window center];
    [self.mainWindowController.window orderFront:nil];
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}


@end
