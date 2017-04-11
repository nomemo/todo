//
//  TodoItem.m
//  todo
//
//  Created by JUE DUKE on 2017/4/2.
//  Copyright © 2017年 JUE DUKE. All rights reserved.
//

#import "TodoItem.h"
#import "Tool.h"

@interface TodoItem()

@property (nonatomic, strong) NSDate *createTime;
@property (nonatomic, strong) NSDate *endTime;
@property (nonatomic, strong) NSDate *startTime;
@property (nonatomic, strong) NSString *createTimeString;
@property (nonatomic, strong) NSString *uuid;

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
            self.endTime = [NSDate date];
            break;
        case TodoStatus_Processing:
            self.startTime = [NSDate date];
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
        self.uuid = [Tool uuidString];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.title forKey:@"title"];
    [aCoder encodeInteger:self.todoStatus forKey:@"todoStatus"];
    [aCoder encodeInteger:self.level forKey:@"level"];
    [aCoder encodeInteger:self.repeat forKey:@"repeat"];
    
    
    [aCoder encodeObject:self.endTime forKey:@"endTime"];
    [aCoder encodeObject:self.createTime forKey:@"createTime"];
    [aCoder encodeObject:self.startTime forKey:@"startTime"];
    [aCoder encodeObject:self.uuid forKey:@"uuid"];
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.title = [aDecoder decodeObjectForKey:@"title"];
        self.todoStatus = [aDecoder decodeIntForKey:@"todoStatus"];
        self.level = [aDecoder decodeIntegerForKey:@"level"];
        self.repeat = [aDecoder decodeIntegerForKey:@"repeat"];
        
        self.createTime = [aDecoder decodeObjectForKey:@"createTime"];
        self.startTime = [aDecoder decodeObjectForKey:@"startTime"];
        self.endTime = [aDecoder decodeObjectForKey:@"endTime"];
        self.uuid = [aDecoder decodeObjectForKey:@"uuid"];
    }
    return self;
}

- (NSString *)description {
    NSMutableString *result = [[NSMutableString alloc]initWithString:[super description]];
    [result appendString:@"\n"];
    return result;
}

@end
