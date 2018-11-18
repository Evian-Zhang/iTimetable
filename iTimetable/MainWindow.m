//
//  MainWindow.m
//  iTimetable
//
//  Created by Evian张 on 2018/11/1.
//  Copyright © 2018 Evian张. All rights reserved.
//

#import "MainWindow.h"

@implementation MainWindow
@synthesize currentRow = _currentRow;
@synthesize timetableViewController = _timetableViewController;

- (NSInteger)currentRow{
    if (self.courseTable.clickedRow >= 0) {
        return self.courseTable.clickedRow;
    } else {
        return self.courseTable.selectedRow;
    }
}

@end
