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
#import "RecordItem.h"
#import "TodoListTableViewController.h"
#import "DataCenter.h"

@interface MasterViewController ()

@property (weak, nonatomic) IBOutlet UITableViewCell *recordCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *targetCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *templateCell;

@property (weak, nonatomic) IBOutlet UITableViewCell *timeSummaryCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *moneySummaryCell;

@end

@implementation MasterViewController



- (void)setupPage {
    [self setupNotifications];
    [self updateSummary];
    
}

- (void)updateSummary {

    [[DataCenter dataCenter]fetchSummary:^(NSInteger money, NSInteger time) {
        self.timeSummaryCell.textLabel.text = [NSString stringWithFormat:@"Time: %@ min", @(time)];
        self.moneySummaryCell.textLabel.text = [NSString stringWithFormat:@"Money:￥ %@", @(money)];
    }];
}

- (void)setupNotifications {
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateSummary) name:NOTI_UPDATE_SUMMARY object:nil];
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
    DataCenter *share = [DataCenter dataCenter];
    TodoListTableViewController *controller = (TodoListTableViewController *)[[segue destinationViewController] topViewController];
    if (sender == self.recordCell) {
        [share fetchRecords:^(NSMutableArray *sections, NSMutableDictionary *data) {
            controller.todoDicts = data;
            controller.sections = sections;
            controller.type = RecordType_Default;
            controller.title = @"Records";
        } byType:RecordType_Default];
    } else if (sender == self.targetCell) {
        [share fetchRecords:^(NSMutableArray *sections, NSMutableDictionary *data) {
            controller.todoDicts = data;
            controller.sections = sections;
            controller.title = @"Targets";
            controller.type = RecordType_Target;
        } byType:RecordType_Target];
    } else if (sender == self.templateCell) {
        [share fetchRecords:^(NSMutableArray *sections, NSMutableDictionary *data) {
            controller.todoDicts = data;
            controller.sections = sections;
            controller.type = RecordType_Template;
            controller.title = @"Templates";
        } byType:RecordType_Template];
    }
}
#pragma mark - Table View

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [self performSegueWithIdentifier:@"showTodoList" sender:cell];
}

@end
