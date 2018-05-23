//
//  TodoListTableViewController.m
//  todo
//
//  Created by JUE DUKE on 2017/4/4.
//  Copyright © 2017年 JUE DUKE. All rights reserved.
//

#import "TodoListTableViewController.h"
#import "DetailViewController.h"
#import "DataCenter.h"
#import "RecordUITableViewCell.h"
#import "NotificationDefines.h"
#import "CreateTodoTableViewController.h"

@interface TodoListTableViewController ()

@end

@implementation TodoListTableViewController


//For the firstView
- (void)setupInitialPage {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [[DataCenter dataCenter]fetchRecords:^(NSMutableArray *sections, NSMutableDictionary *data) {
            self.todoDicts = data;
            self.sections = sections;
            self.type = RecordType_Default;
        } byType:RecordType_Default];
        self.title = @"Records";
    });
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:RecordUITableViewCellID bundle:nil] forCellReuseIdentifier:RecordUITableViewCellID];

    [self setupInitialPage];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Page Control

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    NSArray *todos = self.todoDicts[self.sections[indexPath.section]];
    RecordItem *item = todos[indexPath.row];

    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        DetailViewController *controller = [segue destinationViewController];
        controller.todoItem = item;
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = YES;
    }
    if ([[segue identifier]isEqualToString:@"showCreateTodo"]) {
        UINavigationController *con = [segue destinationViewController];
        CreateTodoTableViewController *root = con.viewControllers[0];
        root.templateObj = item;
    }
}


#pragma mark - Table view data source


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.sections[section];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.todoDicts allKeys].count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *todos = self.todoDicts[self.sections[section]];
    return todos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RecordUITableViewCell* cell = cell = [tableView dequeueReusableCellWithIdentifier:RecordUITableViewCellID];

    id object = [self fetchItemByPath:indexPath];
    cell.item = object;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.type == RecordType_Template) {
        
        [self performSegueWithIdentifier:@"showCreateTodo" sender:nil];

    } else {
        [self performSegueWithIdentifier:@"showDetail" sender:nil];
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        id object = [self deleteObjectByIndexPath:indexPath];
        [[NSNotificationCenter defaultCenter]postNotificationName:NOTI_RECORD_DELETE object:object];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}


#pragma mark - VIEW DATA

- (RecordItem *)deleteObjectByIndexPath:(NSIndexPath *)indexPath {
    NSMutableArray *todos = self.todoDicts[self.sections[indexPath.section]];
    RecordItem *object = todos[indexPath.row];
    [todos removeObject:object];
    return object;
}

- (RecordItem *)fetchItemByPath:(NSIndexPath *)indexPath {
    NSMutableArray *todos = self.todoDicts[self.sections[indexPath.section]];
    RecordItem *object = todos[indexPath.row];
    return object;
}

@end
