//
//  TodoItem.m
//  todo
//
//  Created by JUE DUKE on 2017/4/2.
//  Copyright © 2017年 JUE DUKE. All rights reserved.
//

#import "RecordItem.h"
#import "Tool.h"

@interface RecordItem()

//@property (nonatomic, strong) NSDate *createTime;
@property (nonatomic, strong) NSDate *endTime;
@property (nonatomic, strong) NSDate *startTime;
@property (nonatomic, strong) NSString *createTimeString;
@property (nonatomic, strong) NSString *uuid;

@end

@implementation RecordItem


- (instancetype)init {
    self = [super init];
    if (self) {
        self.todoStatus = TodoStatus_NotBeign;
        self.createTime = [NSDate date];
        self.level = TodoLevel_Normal;
        self.type = RecordType_Default;
        self.uuid = [Tool uuidString];
        self.tags = [NSMutableArray array];
    }
    return self;
}

- (BOOL)isEqual:(id)object {
    if ([object class] == [self class]) {
        RecordItem *obj = object;
        if ([obj.uuid isEqual:self.uuid]) {
            return true;
        }
        return false;
    }
    return [super isEqual:object];

}



- (NSString *)description {
    NSMutableString *result = [[NSMutableString alloc]initWithString:[super description]];
    [result appendString:@"\n"];
    return result;
}

#pragma mark - Propertys


//Record_Default,
//Record_Template,

- (void)setType:(RecordType)type {
    _type = type;
    if (type == RecordType_Default) {
        self.todoStatus = TodoStatus_Finish;
    } else {
        self.todoStatus = TodoStatus_NotBeign;
    }
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
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"..."]];
    _createTimeString = [formatter stringFromDate:self.createTime];
    return _createTimeString;
}



#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.title forKey:@"title"];
    [aCoder encodeInteger:self.todoStatus forKey:@"todoStatus"];
    [aCoder encodeInteger:self.level forKey:@"level"];
    [aCoder encodeInteger:self.type forKey:@"type"];
    [aCoder encodeObject:self.tags forKey:@"tags"];
    
    [aCoder encodeObject:self.endTime forKey:@"endTime"];
    [aCoder encodeObject:self.createTime forKey:@"createTime"];
    [aCoder encodeObject:self.startTime forKey:@"startTime"];
    [aCoder encodeObject:self.uuid forKey:@"uuid"];

    [aCoder encodeInteger:self.time forKey:@"time"];
    [aCoder encodeInteger:self.money forKey:@"money"];
    [aCoder encodeInteger:self.value forKey:@"value"];

}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.title = [aDecoder decodeObjectForKey:@"title"];
        self.todoStatus = [aDecoder decodeIntForKey:@"todoStatus"];
        self.level = [aDecoder decodeIntegerForKey:@"level"];
        self.type = [aDecoder decodeIntegerForKey:@"repeat"];
        self.tags = [aDecoder decodeObjectForKey:@"tags"];
        
        self.createTime = [aDecoder decodeObjectForKey:@"createTime"];
        self.startTime = [aDecoder decodeObjectForKey:@"startTime"];
        self.endTime = [aDecoder decodeObjectForKey:@"endTime"];
        self.uuid = [aDecoder decodeObjectForKey:@"uuid"];
        
        self.money = [aDecoder decodeIntForKey:@"money"];
        self.time = [aDecoder decodeIntForKey:@"time"];
        self.value = [aDecoder decodeIntForKey:@"value"];
    }
    return self;
}
#pragma mark-

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

@end
