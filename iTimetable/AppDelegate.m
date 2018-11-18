//
//  AppDelegate.m
//  iTimetable
//
//  Created by Evian张 on 2018/11/1.
//  Copyright © 2018 Evian张. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

- (IBAction)saveAction:(id)sender;

@end

@implementation AppDelegate
@synthesize mainWindowController = _mainWindowController;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    _mainWindowController = [[MainWindowController alloc] initWithWindowNibName:@"MainWindowController"];
    _mainWindowController.persistentContainer = self.persistentContainer;
    [self.mainWindowController.window center];
    [self.mainWindowController.window orderFront:nil];
    self.createTimetableItem.enabled = YES;
    self.createTimetableItem.target = self;
    self.createTimetableItem.action = @selector(createTimetableItemHandler);
    
    self.changeTimetableItem.enabled = NO;
    self.changeTimetableItem.target = self;
    self.changeTimetableItem.action = @selector(changeTimetableItemHandler);
    
    self.deleteTimetableItem.enabled = NO;
    self.deleteTimetableItem.target = self;
    self.deleteTimetableItem.action = @selector(deleteTimetableItemHandler);
    
    self.createCourseItem.enabled = NO;
    self.createCourseItem.target = self;
    self.createCourseItem.action = @selector(createCourseItemHandler);
    
    self.changeCourseItem.enabled = NO;
    self.changeCourseItem.target = self;
    self.changeCourseItem.action = @selector(changeCourseItemHandler);
    
    self.deleteCourseItem.enabled = NO;
    self.deleteCourseItem.target = self;
    self.deleteCourseItem.action = @selector(deleteCourseItemHandler);
    
    self.createCourseInfoItem.enabled = NO;
    //self.createCourseInfoItem.target = self;
    self.createCourseInfoItem.action = @selector(createCourseInfoItemHandler);
    
    self.changeCourseInfoItem.enabled = NO;
    //self.changeCourseInfoItem.target = self;
    self.changeCourseInfoItem.action = @selector(changeCourseInfoItemHandler);
    
    self.markCourseInfoWillCreatedItem.enabled = NO;
    self.markCourseInfoWillCreatedItem.action = @selector(markCourseInfoWillCreatedItemHandler);
    
    self.markCourseInfoWillMatchedItem.enabled = NO;
    self.markCourseInfoWillMatchedItem.action = @selector(markCourseInfoWillMatchedItemHandler);
    
    self.markCourseInfoWillDeletedItem.enabled = NO;
    //self.deleteCourseInfoItem.target = self;
    self.markCourseInfoWillDeletedItem.action = @selector(markCourseInfoWillDeletedItemHandler);
    
    self.markCourseInfoWillUnmatchedItem.enabled = NO;
    self.markCourseInfoWillUnmatchedItem.action = @selector(markCourseInfoWillUnmatchedItemHandler);
    
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(calendarChangedHandler) name:@"EZCalendarChanged" object:nil];
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(courseTableSelectionChangedHandler) name:@"EZCourseTableSelectionChanged" object:nil];
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(courseInfoTableSelectionChangedHandler) name:@"EZCourseInfoTableSelectionChanged" object:nil];
}

- (BOOL)validateMenuItem:(NSMenuItem *)menuItem{
    self.createTimetableItem.enabled = [self.mainWindowController checkCalendarEmpty] && (![self.mainWindowController checkTimetable]) && (!self.mainWindowController.courseWindowController.window.isVisible) && (!self.mainWindowController.courseWindowController.matchEventWindowController.window.isVisible);
    self.changeTimetableItem.enabled = [self.mainWindowController checkTimetable] && !self.mainWindowController.courseWindowController.window.isVisible && (!self.mainWindowController.courseWindowController.matchEventWindowController.window.isVisible);
    self.deleteTimetableItem.enabled = [self.mainWindowController checkTimetable] && !self.mainWindowController.courseWindowController.window.isVisible && (!self.mainWindowController.courseWindowController.matchEventWindowController.window.isVisible);
    self.createCourseItem.enabled = [self.mainWindowController checkTimetable] && !self.mainWindowController.courseWindowController.window.isVisible && (!self.mainWindowController.courseWindowController.matchEventWindowController.window.isVisible);
    self.changeCourseItem.enabled = [self.mainWindowController checkCourseSelected] && !self.mainWindowController.courseWindowController.window.isVisible && (!self.mainWindowController.courseWindowController.matchEventWindowController.window.isVisible);
    self.deleteCourseItem.enabled = [self.mainWindowController checkCourseSelected] && !self.mainWindowController.courseWindowController.window.isVisible && (!self.mainWindowController.courseWindowController.matchEventWindowController.window.isVisible);
    self.createCourseInfoItem.enabled = self.mainWindowController.courseWindowController.window.isVisible && (!self.mainWindowController.courseWindowController.matchEventWindowController.window.isVisible);
    self.changeCourseInfoItem.enabled = [self.mainWindowController.courseWindowController checkCourseInfoSelected] && self.mainWindowController.courseWindowController.window.isVisible && (!self.mainWindowController.courseWindowController.matchEventWindowController.window.isVisible);
    self.markCourseInfoWillCreatedItem.enabled = [self.mainWindowController.courseWindowController isMarkCourseInfoWillCreatedEnabled] && self.mainWindowController.courseWindowController.window.isVisible && (!self.mainWindowController.courseWindowController.matchEventWindowController.window.isVisible);
    self.markCourseInfoWillMatchedItem.enabled = [self.mainWindowController.courseWindowController isMarkCourseInfoWillMatchedEnabled] && self.mainWindowController.courseWindowController.window.isVisible && (!self.mainWindowController.courseWindowController.matchEventWindowController.window.isVisible);
    self.markCourseInfoWillDeletedItem.enabled = [self.mainWindowController.courseWindowController isMarkCourseInfoWillDeletedEnabled] && self.mainWindowController.courseWindowController.window.isVisible && (!self.mainWindowController.courseWindowController.matchEventWindowController.window.isVisible);
    self.markCourseInfoWillUnmatchedItem.enabled = [self.mainWindowController.courseWindowController isMarkCourseInfoWillUnmatchedEnabled] && self.mainWindowController.courseWindowController.window.isVisible && (!self.mainWindowController.courseWindowController.matchEventWindowController.window.isVisible);
    return [menuItem isEnabled];
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (void)createTimetableItemHandler{
    [self.mainWindowController createTimetable];
}

- (void)changeTimetableItemHandler{
    [self.mainWindowController changeTimetable];
}

- (void)deleteTimetableItemHandler{
    [self.mainWindowController deleteTimetable];
}

- (void)createCourseItemHandler{
    [self.mainWindowController createCourse];
}

- (void)changeCourseItemHandler{
    [self.mainWindowController changeCourse];
}

- (void)deleteCourseItemHandler{
    [self.mainWindowController deleteCourse];
}

- (void)createCourseInfoItemHandler{
    [self.mainWindowController.courseWindowController createCourseInfo];
}

- (void)changeCourseInfoItemHandler{
    [self.mainWindowController.courseWindowController changeCourseInfo];
}

- (void)markCourseInfoWillCreatedItemHandler{
    [self.mainWindowController.courseWindowController markCourseInfoWillCreated];
}

- (void)markCourseInfoWillMatchedItemHandler{
    [self.mainWindowController.courseWindowController markCourseInfoWillMatched];
}

- (void)markCourseInfoWillDeletedItemHandler{
    [self.mainWindowController.courseWindowController markCourseInfoWillDeleted];
}

- (void)markCourseInfoWillUnmatchedItemHandler{
    [self.mainWindowController.courseWindowController markCourseInfoWillUnmatched];
}
/*
- (void)calendarChangedHandler{
    self.createTimetableItem.enabled = [self.mainWindowController checkCalendarEmpty] && (![self.mainWindowController checkTimetable]);
    self.changeTimetableItem.enabled = [self.mainWindowController checkTimetable];
    self.deleteTimetableItem.enabled = [self.mainWindowController checkTimetable];
    self.createCourseItem.enabled = [self.mainWindowController checkTimetable];
    self.changeCourseItem.enabled = [self.mainWindowController checkCourseSelected];
    self.deleteCourseItem.enabled = [self.mainWindowController checkCourseSelected];
    self.changeCourseInfoItem.enabled = [self.mainWindowController.courseWindowController checkCourseInfoSelected];
}

- (void)courseTableSelectionChangedHandler{
    self.changeCourseItem.enabled = [self.mainWindowController checkCourseSelected];
    self.deleteCourseItem.enabled = [self.mainWindowController checkCourseSelected];
    self.changeCourseInfoItem.enabled = [self.mainWindowController.courseWindowController checkCourseInfoSelected];
}

- (void)courseInfoTableSelectionChangedHandler{
    self.changeCourseInfoItem.enabled = [self.mainWindowController.courseWindowController checkCourseInfoSelected];
}
*/
#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"iTimetable"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                     */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving and Undo support

- (IBAction)saveAction:(id)sender {
    // Performs the save action for the application, which is to send the save: message to the application's managed object context. Any encountered errors are presented to the user.
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    
    if (![context commitEditing]) {
        NSLog(@"%@:%@ unable to commit editing before saving", [self class], NSStringFromSelector(_cmd));
    }
    
    NSError *error = nil;
    if (context.hasChanges && ![context save:&error]) {
        // Customize this code block to include application-specific recovery steps.
        [[NSApplication sharedApplication] presentError:error];
    }
}

- (NSUndoManager *)windowWillReturnUndoManager:(NSWindow *)window {
    // Returns the NSUndoManager for the application. In this case, the manager returned is that of the managed object context for the application.
    return self.persistentContainer.viewContext.undoManager;
}

- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender {
    // Save changes in the application's managed object context before the application terminates.
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    
    if (![context commitEditing]) {
        NSLog(@"%@:%@ unable to commit editing to terminate", [self class], NSStringFromSelector(_cmd));
        return NSTerminateCancel;
    }
    
    if (!context.hasChanges) {
        return NSTerminateNow;
    }
    
    NSError *error = nil;
    if (![context save:&error]) {
        
        // Customize this code block to include application-specific recovery steps.
        BOOL result = [sender presentError:error];
        if (result) {
            return NSTerminateCancel;
        }
        
        NSString *question = NSLocalizedString(@"Could not save changes while quitting. Quit anyway?", @"Quit without saves error question message");
        NSString *info = NSLocalizedString(@"Quitting now will lose any changes you have made since the last successful save", @"Quit without saves error question info");
        NSString *quitButton = NSLocalizedString(@"Quit anyway", @"Quit anyway button title");
        NSString *cancelButton = NSLocalizedString(@"Cancel", @"Cancel button title");
        NSAlert *alert = [[NSAlert alloc] init];
        [alert setMessageText:question];
        [alert setInformativeText:info];
        [alert addButtonWithTitle:quitButton];
        [alert addButtonWithTitle:cancelButton];
        
        NSInteger answer = [alert runModal];
        
        if (answer == NSAlertSecondButtonReturn) {
            return NSTerminateCancel;
        }
    }
    
    return NSTerminateNow;
}

@end
