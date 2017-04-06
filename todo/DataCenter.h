//
//  DataCenter.h
//  todo
//
//  Created by JUE DUKE on 2017/4/5.
//  Copyright © 2017年 JUE DUKE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TodoItem.h"

typedef void(^TableDataSource)(NSMutableArray *sections, NSMutableDictionary *data);

@interface DataCenter : NSObject

+ (DataCenter *)dataCenter;

- (void)clearData;
- (NSMutableArray *)fetchMissonPool;
- (void )fetchItemsByStatus:(TodoStatus)status dataSource:(TableDataSource)dataSource;
- (void )fetchAllTodoItem:(TableDataSource)dataSource;


@end
