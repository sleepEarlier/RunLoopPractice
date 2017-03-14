//
//  RunLoopTool.m
//  RunLoopPractice
//
//  Created by kimiLin on 2017/3/13.
//  Copyright © 2017年 KimiLin. All rights reserved.
//

#import "RunLoopTool.h"


@interface RunLoopTool ()

@property (nonatomic, strong) NSMutableArray *taskes;
@property (nonatomic, assign) NSUInteger maxTaskCount;
@property (nonatomic, weak) NSTimer *timer;
@end

@implementation RunLoopTool

+ (RunLoopTool *)sharedInstace
{
    static RunLoopTool *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[RunLoopTool alloc] init];
        [instance dataInit];
        [instance startLoopTimmer];
        [instance registerRunLoopObserver];
    });
    return instance;
}

- (void)dataInit {
    _maxTaskCount = 25;
    _taskes = [NSMutableArray arrayWithCapacity:_maxTaskCount];
}

- (void)startLoopTimmer {
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.1 repeats:YES block:^(NSTimer * _Nonnull timer) {
       // do nothing
    }];
}

+ (void)setMaxTaskCount:(NSUInteger)maxTaskCount {
    [self sharedInstace].maxTaskCount = maxTaskCount;
}

+ (void)addUnit:(ToolUnit)unit {
    if (!unit) {
        return;
    }
    RunLoopTool *tool = [self sharedInstace];
    [tool.taskes addObject:unit];
    if (tool.taskes.count > tool.maxTaskCount) {
        [tool.taskes removeObjectAtIndex:0];
    }
}

- (void)registerRunLoopObserver {
    static CFRunLoopObserverRef observer;
    
    CFRunLoopObserverContext context = {
        0,
        (__bridge void*)self,
        &CFRetain,
        &CFRelease,
        NULL,
    };
    
    observer = CFRunLoopObserverCreate(
                                       kCFAllocatorDefault,
                                       kCFRunLoopBeforeWaiting,
                                       true,
                                       NSUIntegerMax - 999,
                                       &loopObserverCallback,
                                       &context
                                       );
    CFRunLoopRef mainLoop = CFRunLoopGetMain();
    CFRunLoopAddObserver(mainLoop, observer, kCFRunLoopDefaultMode);
}

static void loopObserverCallback(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info) {
    RunLoopTool *tool = (__bridge RunLoopTool*)info;
    BOOL result = NO;
    
    while (result == NO && tool.taskes.count > 0) {
        ToolUnit unit = tool.taskes.firstObject;
        result = unit();
        [tool.taskes removeObject:unit];
    }
}

@end
