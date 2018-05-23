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
- (void )fetchItemsByStatus:(TodoStatus)status dataSource:(TableDataSource)dataSource;

- (void)fetchSummary:(SummaryDataSrouce)dataSource;


#pragma mark - RECORD

- (void )fetchRecords:(TableDataSource)dataSource byType:(RecordType)type;

#pragma mark - TARGET

- (NSMutableArray *)fetchTargets;

#pragma mark - TEMPLATE

- (NSMutableArray *)fetchTemplates;


#pragma mark - TAG

- (void)addTag:(TagItem *)tagItem;
- (void)deleteTag:(TagItem *)tagItem;
- (NSArray *)fetchTags;

@end
