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

@interface TodoListTableViewController ()

@end

@implementation TodoListTableViewController


- (void)setupInitialPage {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [[DataCenter dataCenter]fetchAllTodoItem:^(NSMutableArray *sections, NSMutableDictionary *data) {
            self.todoDicts = data;
            self.sections = sections;
        }];
        self.title = @"History";
    });
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];

        NSArray *todos = self.todoDicts[self.sections[indexPath.section]];
        TodoItem *item = todos[indexPath.row];

        DetailViewController *controller = [segue destinationViewController];
        controller.todoItem = item;
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = YES;
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TodoItemCell1" forIndexPath:indexPath];

    NSArray *todos = self.todoDicts[self.sections[indexPath.section]];
    TodoItem *object = todos[indexPath.row];
    switch (object.todoStatus) {
        case TodoStatus_Abort:
            cell.textLabel.textColor = [UIColor redColor];
            break;
        case TodoStatus_Finish:
            cell.textLabel.textColor = [UIColor greenColor];
            break;
        default:
//            cell.textLabel.textColor = [UIColor blackColor];
            break;
    }
    cell.textLabel.text = object.title;
    return cell;
}


/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
