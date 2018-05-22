//
//  DataCenter.h
//  todo
//
//  Created by JUE DUKE on 2017/4/5.
//  Copyright © 2017年 JUE DUKE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RecordItem.h"
@class TagItem;

typedef void(^TableDataSource)(NSMutableArray *sections, NSMutableDictionary *data);
typedef void(^SummaryDataSrouce)(NSInteger money, NSInteger time);

@interface DataCenter : NSObject

+ (DataCenter *)dataCenter;

- (void)clearData;
- (NSMutableArray *)fetchMissonPool;
- (void )fetchItemsByStatus:(TodoStatus)status dataSource:(TableDataSource)dataSource;
- (void )fetchAllRecords:(TableDataSource)dataSource;

- (void)fetchSummary:(SummaryDataSrouce)dataSource;

- (void)addTag:(TagItem *)tagItem;
- (void)deleteTag:(TagItem *)tagItem;
- (NSArray *)fetchTags;

@end
