//
//  DataCenter.h
//  todo
//
//  Created by JUE DUKE on 2017/4/5.
//  Copyright © 2017年 JUE DUKE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TodoItem.h"

@interface DataCenter : NSObject

+ (DataCenter *)dataCenter;

- (void)clearData;
- (NSMutableArray *)fetchMissonPool;
- (NSMutableArray *)fetchItemsByStatus:(TodoStatus)status;
- (NSMutableArray *)fetchAllTodoItem;


@end
