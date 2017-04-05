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
#import "TodoListTableViewController.h"
#import "DataCenter.h"

@interface MasterViewController ()




@property (weak, nonatomic) IBOutlet UITableViewCell *allCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *finishCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *undoneCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *abortCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *missionPoolCell;


@end

@implementation MasterViewController



- (void)setupPage {
    [self setupNotifications];
}

- (void)setupNotifications {
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(createTodo:) name:NOTI_TODO_CREATE object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(abortTodo:) name:NOTI_TODO_ABORT object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishTodo:) name:NOTI_TODO_FINISH object:nil];
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
        [[DataCenter dataCenter] clearData];
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






#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    TodoListTableViewController *controller = (TodoListTableViewController *)[[segue destinationViewController] topViewController];
    if (sender == self.allCell) {
        controller.todoLists = [[DataCenter dataCenter] fetchAllTodoItem];
        controller.title = @"History";
    } else if (sender == self.finishCell) {
        controller.todoLists = [[DataCenter dataCenter] fetchItemsByStatus:TodoStatus_Finish];
        controller.title = @"Finish";
    } else if (sender == self.undoneCell) {
        controller.todoLists = [[DataCenter dataCenter] fetchItemsByStatus:TodoStatus_NotBeign];
        controller.title = @"Unfinish";
    } else if (sender == self.abortCell) {
        controller.todoLists = [[DataCenter dataCenter] fetchItemsByStatus:TodoStatus_Abort];
        controller.title = @"Abort";
    } else if (sender == self.missionPoolCell) {
        controller.todoLists = [[DataCenter dataCenter] fetchMissonPool];
        controller.title = @"Mission Pool";
    }
    
}
#pragma mark - Table View



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return self.objects.count;
    NSInteger result = 0;
    switch (section) {
        case 0:
            result = 4;
            break;
        case 1:
            result = 1;
            break;
        default:
            break;
    }
    return result;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [self performSegueWithIdentifier:@"showTodoList" sender:cell];
}


//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
//    // Return NO if you do not want the specified item to be editable.
//    return YES;
//}


//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        [self.objects removeObjectAtIndex:indexPath.row];
//        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
//        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
//    }
//}


@end
