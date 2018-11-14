//
//  CourseInfoWindow.m
//  iTimetable
//
//  Created by Evian张 on 2018/11/5.
//  Copyright © 2018 Evian张. All rights reserved.
//

#import "CourseWindow.h"

@implementation CourseWindow
@synthesize currentRow = _currentRow;

- (NSInteger)currentRow{
    if (self.courseInfoTable.clickedRow >= 0) {
        return self.courseInfoTable.clickedRow;
    }
    return self.courseInfoTable.selectedRow;
}

@end
