//
//  DataCenter.m
//  todo
//
//  Created by JUE DUKE on 2017/4/5.
//  Copyright © 2017年 JUE DUKE. All rights reserved.
//

#import "DataCenter.h"
#import "NotificationDefines.h"

static DataCenter *_sharedInstance;

@interface DataCenter()

@property NSMutableArray *allTodoItems;
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(createTodo:) name:NOTI_TODO_CREATE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusChange:) name:NOTI_TODO_STATUS object:nil];
}


#pragma mark - Data


- (NSString *)dataPath {
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *filePath = [path stringByAppendingPathComponent:@"todoList.data"];
    NSLog(@"filePath %@", filePath);
    return filePath;
}

- (void)clearData {
    self.allTodoItems = [NSMutableArray array];
    [self saveData];
}


- (void)saveData {
    //    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    //    NSString *fileName = [path stringByAppendingPathComponent:@"todoItems.data"];
    BOOL result = [NSKeyedArchiver archiveRootObject:self.allTodoItems toFile:[self dataPath]];
    NSLog(@"result %@", @(result));
    //    NSJSONSerialization wr
}

- (void)loadData {
    //    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    //    NSString *fileName = [path stringByAppendingPathComponent:@"todoItems.data"];
    NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithFile:[self dataPath]];
    if (array) {
        
        self.allTodoItems = [NSMutableArray arrayWithArray:array];

    }
    //    NSKeyedArchiver
}

- (NSMutableArray *)fetchMissonPool {
    NSMutableArray *array = [NSMutableArray array];
    for (TodoItem *item in self.allTodoItems) {
        if (item.repeat == TodoRepeat_On) {
            [array addObject:item];
        }
    }
    return array;
}

- (void )fetchAllTodoItem:(TableDataSource)dataSource {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSMutableArray *array = [NSMutableArray array];
    for (TodoItem *item in self.allTodoItems) {
        if (item.repeat == TodoRepeat_Off) {
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

- (void )fetchItemsByStatus:(TodoStatus)status dataSource:(TableDataSource)dataSource{
    NSMutableArray *tempArray = [NSMutableArray array];
    for (TodoItem *item in self.allTodoItems) {
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
    for (TodoItem *item in tempArray) {
        if (item.repeat == TodoRepeat_Off) {
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



#pragma mark - TodoItem



- (void)statusChange:(NSNotification *)noti {
    
    //    TodoItem *item = noti.object;
    //    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.allTodoITems indexOfObject:item] inSection:0];
    //    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    //    cell.textLabel.textColor = [UIColor redColor];
    //    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    [self saveData];
}

- (void)createTodo:(NSNotification *)noti {
    //    NSLog(@"%@", noti.object);
    if (!self.allTodoItems) {
        self.allTodoItems = [[NSMutableArray alloc] init];
    }
    [self.allTodoItems insertObject:noti.object atIndex:0];
    
    [self saveData];
    //    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    //    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - TagItem 


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
