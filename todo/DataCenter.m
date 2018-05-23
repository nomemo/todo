//
//  DataCenter.m
//  todo
//
//  Created by JUE DUKE on 2017/4/5.
//  Copyright © 2017年 JUE DUKE. All rights reserved.
//

#import "DataCenter.h"
#import "NotificationDefines.h"
#define DATABASE_RECORD @"DB.data"
#define DATABASE_TEMPLATE @"TP.data"
#define DATABASE_TARGET @"TA.data"



static DataCenter *_sharedInstance;


@interface DataCenter()

@property NSMutableArray *records;
@property NSMutableArray *targets;
@property NSMutableArray *templates;
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
    
}


#pragma mark - Stroage

- (NSString *)dataPath:(NSString *)fileName {
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *filePath = [path stringByAppendingPathComponent:fileName];
    NSLog(@"filePath %@", filePath);
    return filePath;
}



- (void)clearData {
    self.records = [NSMutableArray array];
    self.templates = [NSMutableArray array];
    self.targets = [NSMutableArray array];
    [self saveData];
}


- (void)saveData {
    BOOL result1 = [NSKeyedArchiver archiveRootObject:self.records toFile:[self dataPath:DATABASE_RECORD]];
    BOOL result2 = [NSKeyedArchiver archiveRootObject:self.templates toFile:[self dataPath:DATABASE_TEMPLATE]];
    BOOL result3 = [NSKeyedArchiver archiveRootObject:self.targets toFile:[self dataPath:DATABASE_TARGET]];
    NSLog(@"result %@, %@, %@", @(result1),@(result2),@(result3));
}

- (void)loadData {
    NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithFile:[self dataPath:DATABASE_RECORD]];
    if (array) {
        self.records = [NSMutableArray arrayWithArray:array];
    }
    array = [NSKeyedUnarchiver unarchiveObjectWithFile:[self dataPath:DATABASE_TEMPLATE]];
    if (array) {
        self.templates = [NSMutableArray arrayWithArray:array];
    }
    array = [NSKeyedUnarchiver unarchiveObjectWithFile:[self dataPath:DATABASE_TARGET]];
    if (array) {
        self.targets = [NSMutableArray arrayWithArray:array];
    }

}


#pragma mark RECORD

- (void)arrangeRecordList:(NSMutableArray *)inputList recordSectionList:(NSMutableArray *)recordSectionList sections:(NSMutableDictionary *)sections {
    [inputList sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        RecordItem *o1 = obj1;
        RecordItem *o2 = obj2;
        return [o2.createTime compare:o1.createTime];
    }];
    for (RecordItem *item in inputList) {
        NSMutableArray *todos = sections[item.createTimeString];
        if (todos == nil) {
            todos = [NSMutableArray array];
            sections[item.createTimeString] = todos;
            [recordSectionList addObject:item.createTimeString];
        }
        [todos addObject:item];
    }
}

- (void )fetchRecords:(TableDataSource)dataSource byType:(RecordType)type{
    NSMutableDictionary *sections = [NSMutableDictionary dictionary];
    NSMutableArray *recordSectionList = [NSMutableArray array];
    switch (type) {
        case RecordType_Default:
            [self arrangeRecordList:self.records recordSectionList:recordSectionList sections:sections];
            break;
        case RecordType_Template:
            [self arrangeRecordList:self.templates recordSectionList:recordSectionList sections:sections];
            break;
        case RecordType_Target:
            [self arrangeRecordList:self.targets recordSectionList:recordSectionList sections:sections];
            break;
    }
    dataSource(recordSectionList, sections);
}

- (void)addRecord:(NSNotification *)noti {
    RecordItem *item = noti.object;
    switch (item.type) {
        case RecordType_Target:
        {
            if (!self.targets) {
                self.targets = [[NSMutableArray alloc] init];
            }
            [self.targets insertObject:noti.object atIndex:0];
        }
            break;
        case RecordType_Default:
        {
            if (!self.records) {
                self.records = [[NSMutableArray alloc] init];
            }
            [self.records insertObject:noti.object atIndex:0];
            [[NSNotificationCenter defaultCenter]postNotificationName:NOTI_UPDATE_SUMMARY object:nil];
        }
            break;
        case RecordType_Template:
        {
            if (!self.templates) {
                self.templates = [[NSMutableArray alloc] init];
            }
            [self.templates insertObject:noti.object atIndex:0];
        }
        break;
    }
    [self saveData];
}


- (void)deleteRecord:(NSNotification *)noti {
    RecordItem *item = noti.object;
    switch (item.type) {
        case RecordType_Target:
        {
            [self.targets removeObject:noti.object];
        }
            break;
        case RecordType_Default:
        {
            [self.records removeObject:noti.object];
        }
            break;
        case RecordType_Template:
        {
            [self.templates removeObject:noti.object];
        }
            break;
    }
    [[NSNotificationCenter defaultCenter]postNotificationName:NOTI_UPDATE_SUMMARY object:nil];

    [self saveData];
}

#pragma mark SUMMARY

- (void)fetchSummary:(SummaryDataSrouce)dataSource {
    NSInteger money = 0;
    NSInteger time = 0;
    for (RecordItem *item in self.records) {
        if (item.todoStatus == TodoStatus_Finish) {
            if (item.value == RecordValue_Spend) {
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


#pragma mark - TARGET

- (NSMutableArray *)fetchTargets {
    return self.targets;
}

#pragma mark - TEMPLATE

- (NSMutableArray *)fetchTemplates {
    return self.templates;
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
        if (item.type == RecordType_Default) {
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
