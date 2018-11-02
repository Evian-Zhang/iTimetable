//
//  MainWindow.h
//  iTimetable
//
//  Created by Evian张 on 2018/11/1.
//  Copyright © 2018 Evian张. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface MainWindow : NSWindow

@property (nonatomic) IBOutlet NSSplitView *splitView;
@property (nonatomic) IBOutlet NSTextField *accessText;
@property (nonatomic) IBOutlet NSTextField *sourceText;
@property (nonatomic) IBOutlet NSPopUpButton *sourcePop;
@property (nonatomic) IBOutlet NSTextField *calText;
@property (nonatomic) IBOutlet NSPopUpButton *calPop;


@end

NS_ASSUME_NONNULL_END
