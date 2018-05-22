//
//  CreateTodoTableViewController.m
//  todo
//
//  Created by JUE DUKE on 2017/4/3.
//  Copyright © 2017年 JUE DUKE. All rights reserved.
//

#import "CreateTodoTableViewController.h"
#import "NotificationDefines.h" 
#import "RecordItem.h"
#import "TodoLevelSelectTableViewController.h"
#import "TagTableViewController.h"
#import "DatePickerViewController.h"

@interface CreateTodoTableViewController ()<TagSelectionPageDelegate>



@property (weak, nonatomic) IBOutlet UITextField *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *moneyLabel;
@property (weak, nonatomic) IBOutlet UITextField *timeLabel;

@property (weak, nonatomic) IBOutlet UISwitch *asSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *trSwitch;

@property (nonatomic, assign) TodoLevel todoLevel;
@property (weak, nonatomic) IBOutlet UILabel *levelDetailLabel;

@property (weak, nonatomic) IBOutlet UILabel *tagDetailLabel;
@property (assign, nonatomic) BOOL showDatePicker;

@property (weak, nonatomic) IBOutlet UILabel *createDateLabel;
//@property (strong, nonatomic) NSDate *createDate;

@property (strong, nonatomic) NSArray *tags;
@end

@implementation CreateTodoTableViewController


- (void)setTodoLevel:(TodoLevel)todoLevel {
    _todoLevel = todoLevel;
    NSString *string = [RecordItem todoLevelString:todoLevel];
    self.levelDetailLabel.text = string;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.recordObj == nil) {
        self.recordObj = [[RecordItem alloc]init];
    }
    self.createDateLabel.text = self.recordObj.createTimeString;
    self.showDatePicker = false;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dismissPage:(id)sender {
    if (self.navigationItem.leftBarButtonItem == sender) {
        NSLog(@"Cancel");
    } else {
        [self saveTodoItem];
    }
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Save todo item 

- (void)saveTodoItem {
    self.recordObj.title = self.titleLabel.text;
    self.recordObj.money = [self.moneyLabel.text integerValue];
    self.recordObj.time = [self.timeLabel.text integerValue];
    self.recordObj.value = self.asSwitch.isOn?Record_Spend:Record_Accumulate;
    self.recordObj.type = self.trSwitch.isOn?TodoRepeat_Target:TodoRepeat_Record;
    self.recordObj.level = self.todoLevel;
    self.recordObj.tags = self.tags;
    [[NSNotificationCenter defaultCenter]postNotificationName:NOTI_RECORD_CREATE object:self.recordObj];
    NSLog(@"Save");
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 8;
        case 1:
            return 2;
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    NSIndexPath *ddindexPath = [tableView indexPathForCell:self.deadlineTableViewCell];
//    if ([ddindexPath compare:indexPath] == NSOrderedSame ) {
//        self.showDatePicker = !self.showDatePicker;
//        [self.tableView beginUpdates];
//        [self.tableView endUpdates];
//    }
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.row == 1 && indexPath.section == 1) {
//        if (self.showDatePicker == true) {
//            return [super tableView:tableView heightForRowAtIndexPath:indexPath];
//        } else {
//            return 0;
//        }
//    }
//    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
//}

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
////    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier" forIndexPath:indexPath];
//
////    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    // Configure the cell...
//    return nil;
////    return cell;
//}

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

#pragma mark - TagSelectionPageDelegate

- (NSString *)titleForSelection {
    if (self.titleLabel.text.length == 0) {
        return @"New Mission";
    }
    return self.titleLabel.text;
}

- (NSArray<TagItem *> *)selectedTags {
    return self.tags;
}

- (void)selectResult:(NSArray<TagItem *> *)selectedTags {
    self.tags = [selectedTags copy];
    switch (selectedTags.count) {
        case 0:
            self.tagDetailLabel.text = @"None";
            break;
        case 1: {
            TagItem *item = selectedTags[0];
            self.tagDetailLabel.text = item.name;
            break;
        }
        default:
            self.tagDetailLabel.text = [NSString stringWithFormat:@"%@", @(selectedTags.count)];
            break;
    }
}


#pragma mark - Navigation

 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"gotoSelectLevelPage"]) {
        TodoLevelSelectTableViewController *selectCon = segue.destinationViewController;
        selectCon.todoLevelCallback = ^(TodoLevel level) {
            self.todoLevel = level;
        };
    }
    if ([segue.identifier isEqualToString:@"gotoSelectTagPage"]) {
        TagTableViewController *selectCon = segue.destinationViewController;
        selectCon.delegate = self;
    }
    if ([segue.identifier isEqualToString:@"gotoDatePickerPage"]) {
        DatePickerViewController *dateCon = segue.destinationViewController;
        dateCon.date = self.recordObj.createTime;
        dateCon.dateCallback = ^(NSDate *date) {
            self.recordObj.createTime = date;
            self.createDateLabel.text = self.recordObj.createTimeString;
        };
    }
}

@end
