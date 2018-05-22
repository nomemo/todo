//
//  TodoItem.h
//  todo
//
//  Created by JUE DUKE on 2017/4/2.
//  Copyright © 2017年 JUE DUKE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TagItem.h"




typedef enum : NSUInteger {
    TodoStatus_NotBeign,
    TodoStatus_Finish,
    TodoStatus_Abort,
    TodoStatus_Processing,
} TodoStatus;

typedef enum : NSUInteger {
    TodoLevel_Normal,
    TodoLevel_Important,
    TodoLevel_Urgent,
    TodoLevel_ImportantAndUrgent,
} TodoLevel;

typedef enum : NSUInteger {
    Record_Spend,
    Record_Accumulate,
} RecordValue;

typedef enum : NSUInteger {
    TodoRepeat_Record,
    TodoRepeat_Target,
} RecordType;

@interface RecordItem : NSObject<NSCoding>


@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSArray<TagItem *> *tags;
@property (nonatomic, assign) NSInteger money;
@property (nonatomic, assign) NSInteger time;
@property (nonatomic, assign) RecordValue value;
@property (nonatomic, assign) RecordType type;

@property (nonatomic, assign) TodoStatus todoStatus;
@property (nonatomic, assign) TodoLevel level;

#pragma mark - readonly

@property (nonatomic, strong, readonly) NSString *uuid;
@property (nonatomic, strong, readonly) NSString *createTimeString;
@property (nonatomic, strong) NSDate *createTime;
@property (nonatomic, strong, readonly) NSDate *endTime;
@property (nonatomic, strong, readonly) NSDate *startTime;



+ (NSString *)todoLevelString:(TodoLevel)level;
+ (NSString *)totoStatusString:(TodoStatus)status;

@end
