//
//  TodoItem.m
//  todo
//
//  Created by JUE DUKE on 2017/4/2.
//  Copyright © 2017年 JUE DUKE. All rights reserved.
//

#import "TodoItem.h"

@interface TodoItem()

@property (nonatomic, strong) NSDate *createTime;
@property (nonatomic, strong) NSDate *finishTime;
@property (nonatomic, strong) NSDate *beginTime;
@property (nonatomic, strong) NSString *createTimeString;


@end

@implementation TodoItem

+ (NSString *)totoStatusString:(TodoStatus)status {
    switch (status) {
        case TodoStatus_Abort:
            return @"Abort";
            break;
        case TodoStatus_Finish:
            return @"Finish";
            break;
        case TodoStatus_NotBeign:
            return @"NotBegin";
            break;
        case TodoStatus_Processing:
            return @"Processing";
            break;
    }
}

+ (NSString *)todoLevelString:(TodoLevel)level {
    switch (level) {
        case TodoLevel_ImportantAndUrgent:
            return @"Important&Urgent";
            break;
        case TodoLevel_Important:
            return @"Important";
            break;
        case TodoLevel_Normal:
            return @"Normal";
            break;
        case TodoLevel_Urgent:
            return @"Urgent";
            break;
    }
    return nil;
}

- (void)setTodoStatus:(TodoStatus)todoStatus {
    _todoStatus = todoStatus;
    switch (todoStatus) {
        case TodoStatus_Abort:
        case TodoStatus_Finish:
            self.finishTime = [NSDate date];
            break;
        case TodoStatus_Processing:
            self.beginTime = [NSDate date];
            break;
        default:
            break;
    }
}

- (NSString *)createTimeString {
    if (_createTimeString == nil) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"..."]];
        _createTimeString = [formatter stringFromDate:self.createTime];
    }
    return _createTimeString;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.todoStatus = TodoStatus_NotBeign;
        self.createTime = [NSDate date];
        self.level = TodoLevel_Normal;
        self.repeat = TodoRepeat_Off;
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.title forKey:@"title"];
    [aCoder encodeObject:self.createTime forKey:@"createTime"];
    [aCoder encodeInteger:self.todoStatus forKey:@"todoStatus"];
    [aCoder encodeInteger:self.level forKey:@"level"];
    [aCoder encodeInteger:self.repeat forKey:@"repeat"];
    [aCoder encodeObject:self.finishTime forKey:@"finishTime"];
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.title = [aDecoder decodeObjectForKey:@"title"];
        self.createTime = [aDecoder decodeObjectForKey:@"createTime"];
        self.todoStatus = [aDecoder decodeIntForKey:@"todoStatus"];
        self.level = [aDecoder decodeIntegerForKey:@"level"];
        self.repeat = [aDecoder decodeIntegerForKey:@"repeat"];
        self.finishTime = [aDecoder decodeObjectForKey:@"finishTime"];
    }
    return self;
}

@end
