//
//  RunLoopTool.h
//  RunLoopPractice
//
//  Created by kimiLin on 2017/3/13.
//  Copyright © 2017年 KimiLin. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef BOOL(^ToolUnit)();

@interface RunLoopTool : NSObject

+ (RunLoopTool *)sharedInstace;

+ (void)addUnit:(ToolUnit)unit;

+ (void)setMaxTaskCount:(NSUInteger)maxTaskCount;

@end
