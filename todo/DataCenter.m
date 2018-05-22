//
//  DataCenter.m
//  todo
//
//  Created by JUE DUKE on 2017/4/5.
//  Copyright © 2017年 JUE DUKE. All rights reserved.
//

#import "DataCenter.h"
#import "NotificationDefines.h"
#define DATABASE_FILE @"DB.data"



static DataCenter *_sharedInstance;


@interface DataCenter()

@property NSMutableArray *records;
@property NSMutableArray *allTagItems;

@end

@implementation DataCenter



+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [super allocWithZone:zone];
    });
    return _sharedInstance;
}

+ (DataCenter *)dataCenter {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[DataCenter alloc]init];
    });
    return _sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupNotifications];
        [self loadData];
        [self loadTagItemData];
    }
    return self;
}


#pragma mark - Notification

- (void)setupNotifications {
//RECORD
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addRecord:) name:NOTI_RECORD_CREATE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteRecord:) name:NOTI_RECORD_DELETE object:nil];

//STATUS
    
}


#pragma mark - Stroage

- (NSString *)dataPath {
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *filePath = [path stringByAppendingPathComponent:DATABASE_FILE];
    NSLog(@"filePath %@", filePath);
    return filePath;
}

- (void)clearData {
    self.records = [NSMutableArray array];
    [self saveData];
}


- (void)saveData {
    //    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    //    NSString *fileName = [path stringByAppendingPathComponent:@"todoItems.data"];
    BOOL result = [NSKeyedArchiver archiveRootObject:self.records toFile:[self dataPath]];
    NSLog(@"result %@", @(result));
    //    NSJSONSerialization wr
}

- (void)loadData {
    //    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    //    NSString *fileName = [path stringByAppendingPathComponent:@"todoItems.data"];
    NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithFile:[self dataPath]];
    if (array) {
        
        self.records = [NSMutableArray arrayWithArray:array];

    }
    //    NSKeyedArchiver
}

#pragma mark - MISSON

- (NSMutableArray *)fetchMissonPool {
    NSMutableArray *array = [NSMutableArray array];
    for (RecordItem *item in self.records) {
        if (item.type == TodoRepeat_Target) {
            [array addObject:item];
        }
    }
    return array;
}


#pragma mark RECORD

- (void )fetchAllRecords:(TableDataSource)dataSource {
    NSMutableDictionary *sections = [NSMutableDictionary dictionary];
    NSMutableArray *recordSectionList = [NSMutableArray array];
    [self.records sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        RecordItem *o1 = obj1;
        RecordItem *o2 = obj2;
        return [o2.createTime compare:o1.createTime];
    }];
    
    for (RecordItem *item in self.records) {
        if (item.type == TodoRepeat_Record) {
            NSMutableArray *todos = sections[item.createTimeString];
            if (todos == nil) {
                todos = [NSMutableArray array];
                sections[item.createTimeString] = todos;
                [recordSectionList addObject:item.createTimeString];
            }
            [todos addObject:item];
        }
    }
    dataSource(recordSectionList, sections);
}

- (void)addRecord:(NSNotification *)noti {
    if (!self.records) {
        self.records = [[NSMutableArray alloc] init];
    }
    [self.records insertObject:noti.object atIndex:0];
    [[NSNotificationCenter defaultCenter]postNotificationName:NOTI_UPDATE_SUMMARY object:nil];
    [self saveData];
}


- (void)deleteRecord:(NSNotification *)noti {
    [self.records removeObject:noti.object];
    [[NSNotificationCenter defaultCenter]postNotificationName:NOTI_UPDATE_SUMMARY object:nil];

    [self saveData];
}

#pragma mark SUMMARY

- (void)fetchSummary:(SummaryDataSrouce)dataSource {
    NSInteger money = 0;
    NSInteger time = 0;
    for (RecordItem *item in self.records) {
        if (item.todoStatus == TodoStatus_Finish) {
            if (item.value == Record_Spend) {
                money -= item.money;
                time -= item.time;
            } else {
                money += item.money;
                time += item.time;
            }
        }
    }
    dataSource(money, time);
}


#pragma mark - STATUS

- (void )fetchItemsByStatus:(TodoStatus)status dataSource:(TableDataSource)dataSource{
    NSMutableArray *tempArray = [NSMutableArray array];
    for (RecordItem *item in self.records) {
        switch (status) {
            case TodoStatus_Finish:
                if (item.todoStatus == TodoStatus_Finish) {
                    [tempArray addObject:item];
                }
                break;
            case TodoStatus_Abort:
                if (item.todoStatus == TodoStatus_Abort) {
                    [tempArray addObject:item];
                }
                break;
            case TodoStatus_NotBeign:
                if (item.todoStatus == TodoStatus_NotBeign) {
                    [tempArray addObject:item];
                }
                break;
            default:
                break;
        }
    }
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSMutableArray *array = [NSMutableArray array];
    for (RecordItem *item in tempArray) {
        if (item.type == TodoRepeat_Record) {
            NSMutableArray *todos = dict[item.createTimeString];
            if (todos == nil) {
                todos = [NSMutableArray array];
                dict[item.createTimeString] = todos;
                [array addObject:item.createTimeString];
            }
            [todos addObject:item];
        }
    }
    dataSource(array, dict);
}


- (void)statusChange:(NSNotification *)noti {
    
    //    TodoItem *item = noti.object;
    //    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.allTodoITems indexOfObject:item] inSection:0];
    //    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    //    cell.textLabel.textColor = [UIColor redColor];
    //    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    [self saveData];
}


#pragma mark - TAG


- (NSString *)tagItemPath {
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *filePath = [path stringByAppendingPathComponent:@"tags.data"];
    NSLog(@"filePath %@", filePath);
    return filePath;
}

- (void)loadTagItemData {
    NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithFile:[self tagItemPath]];
    if (array) {
        self.allTagItems = [NSMutableArray arrayWithArray:array];
    } else {
        self.allTagItems = [NSMutableArray array];
    }
}

- (void)saveTags {
    BOOL result = [NSKeyedArchiver archiveRootObject:self.allTagItems toFile:[self tagItemPath]];
    NSLog(@"result %@", @(result));
}

- (void)addTag:(TagItem *)tagItem {
    [self.allTagItems addObject:tagItem];
    [self saveTags];
}

- (void)deleteTag:(TagItem *)tagItem {
    [self.allTagItems removeObject:tagItem];
    [self saveTags];
}

- (NSArray *)fetchTags {
    return _allTagItems;
}

@end
