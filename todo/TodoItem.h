//
//  TodoItem.h
//  todo
//
//  Created by JUE DUKE on 2017/4/2.
//  Copyright © 2017年 JUE DUKE. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TodoItem : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSDate *createTime;

@end
