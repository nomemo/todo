//
//  MasterViewController.m
//  todo
//
//  Created by JUE DUKE on 2017/4/2.
//  Copyright © 2017年 JUE DUKE. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "NotificationDefines.h"
#import "TodoItem.h"

@interface MasterViewController ()

@property NSMutableArray *objects;
@end

@implementation MasterViewController



- (void)setupPage {
    [self loadData];
    [self setupNotifications];
}

- (void)setupNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(createTodo:) name:NOTI_TODO_CREATE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(abortTodo:) name:NOTI_TODO_ABORT object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishTodo:) name:NOTI_TODO_FINISH object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupPage];
}


- (void)viewWillAppear:(BOOL)animated {
    self.clearsSelectionOnViewWillAppear = self.splitViewController.isCollapsed;
    [super viewWillAppear:animated];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Setting 

- (IBAction)setting:(id)sender {
    
    
    UIAlertController* sheet = [UIAlertController alertControllerWithTitle:@"Setting" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *applyAction = [UIAlertAction actionWithTitle:@"Clean Data" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self clearData];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [sheet addAction:applyAction];
    [sheet addAction:cancelAction];
    
    
    if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        [sheet.popoverPresentationController setPermittedArrowDirections:UIPopoverArrowDirectionAny];
        sheet.popoverPresentationController.sourceView = self.view;
        sheet.popoverPresentationController.barButtonItem = sender;
        [self presentViewController:sheet animated:YES completion:nil];
    } else {
        [self presentViewController:sheet animated:YES completion:nil];
    }

}




#pragma mark - TodoItem

- (void)finishTodo:(NSNotification *)noti {
    
    TodoItem *item = noti.object;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.objects indexOfObject:item] inSection:0];
//    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
//    cell.textLabel.textColor = [UIColor greenColor];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self saveData];
}

- (void)abortTodo:(NSNotification *)noti {
    
    TodoItem *item = noti.object;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.objects indexOfObject:item] inSection:0];
//    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
//    cell.textLabel.textColor = [UIColor redColor];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];

    [self saveData];
}

- (void)createTodo:(NSNotification *)noti {
//    NSLog(@"%@", noti.object);
    if (!self.objects) {
        self.objects = [[NSMutableArray alloc] init];
    }
    [self.objects insertObject:noti.object atIndex:0];

    [self saveData];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - Data 


- (NSString *)dataPath {
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *filePath = [path stringByAppendingPathComponent:@"todoItems.data"];
    return filePath;
}

- (void)clearData {
    self.objects = [NSMutableArray array];
    [self saveData];
    [self.tableView reloadData];
}


- (void)saveData {
//    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
//    NSString *fileName = [path stringByAppendingPathComponent:@"todoItems.data"];
    BOOL result = [NSKeyedArchiver archiveRootObject:self.objects toFile:[self dataPath]];
    NSLog(@"result %@", @(result));
//    NSJSONSerialization wr
}

- (void)loadData {
//    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
//    NSString *fileName = [path stringByAppendingPathComponent:@"todoItems.data"];
    NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithFile:[self dataPath]];
    if (array) {
        self.objects = [NSMutableArray arrayWithArray:array];
    }
//    NSKeyedArchiver 
}


#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        TodoItem *item = self.objects[indexPath.row];
        DetailViewController *controller = (DetailViewController *)[[segue destinationViewController] topViewController];
        controller.todoItem = item;
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = YES;
    }
}


#pragma mark - Table View



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.objects.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    TodoItem *object = self.objects[indexPath.row];
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


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}


@end
