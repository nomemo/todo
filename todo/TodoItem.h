//
//  TodoItem.h
//  todo
//
//  Created by JUE DUKE on 2017/4/2.
//  Copyright © 2017年 JUE DUKE. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    TodoStatus_NotBeign,
    TodoStatus_Finish,
    TodoStatus_Abort,
} TodoStatus;

@interface TodoItem : NSObject<NSCoding>

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSDate *createTime;
@property (nonatomic, assign) TodoStatus todoStatus;

@end
