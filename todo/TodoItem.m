//
//  TodoItem.m
//  todo
//
//  Created by JUE DUKE on 2017/4/2.
//  Copyright © 2017年 JUE DUKE. All rights reserved.
//

#import "TodoItem.h"

@implementation TodoItem


- (instancetype)init {
    self = [super init];
    if (self) {
        self.todoStatus = TodoStatus_NotBeign;
        self.createTime = [NSDate date];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.title forKey:@"title"];
    [aCoder encodeObject:self.createTime forKey:@"createTime"];
    [aCoder encodeInteger:self.todoStatus forKey:@"todoStatus"];
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.title = [aDecoder decodeObjectForKey:@"title"];
        self.createTime = [aDecoder decodeObjectForKey:@"createTime"];
        self.todoStatus = [aDecoder decodeIntForKey:@"todoStatus"];
    }
    return self;
}

@end
