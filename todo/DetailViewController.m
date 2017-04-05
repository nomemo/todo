//
//  DetailViewController.m
//  todo
//
//  Created by JUE DUKE on 2017/4/2.
//  Copyright © 2017年 JUE DUKE. All rights reserved.
//

#import "DetailViewController.h"
#import "NotificationDefines.h"

@interface DetailViewController ()<UIPopoverPresentationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIToolbar *bottomToolbar;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *finishButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *abortButton;

@end

@implementation DetailViewController

- (void)configureView {
    // Update the user interface for the detail item.
    
    if (!_todoItem) {
        self.bottomToolbar.hidden = true;
        self.createTimeLabel.hidden = true;
        self.finishTimeLabel.hidden = true;
        return;
    }
    self.bottomToolbar.hidden = false;
    self.createTimeLabel.text = [NSString stringWithFormat:@"Create at %@", [self.todoItem.createTime description]];
    self.title = _todoItem.title;
    if (_todoItem.todoStatus == TodoStatus_Finish && _todoItem.finishTime) {
        self.finishTimeLabel.hidden = false;
        self.finishTimeLabel.text = [NSString stringWithFormat:@"Finish at %@", [self.todoItem.finishTime description]];
    } else {
        self.finishTimeLabel.hidden = true;
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self configureView];

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Todo Status 

- (IBAction)finish:(id)sender {
    self.todoItem.todoStatus = TodoStatus_Finish;
    [[NSNotificationCenter defaultCenter]postNotificationName:NOTI_TODO_FINISH object:self.todoItem];
}

- (IBAction)aboart:(id)sender {
    
    UIAlertController* sheet = [UIAlertController alertControllerWithTitle:@"Aboart Todo?" message:@"This will not changeable" preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *applyAction = [UIAlertAction actionWithTitle:@"Apply" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        self.todoItem.todoStatus = TodoStatus_Abort;
        [[NSNotificationCenter defaultCenter]postNotificationName:NOTI_TODO_ABORT object:self.todoItem];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [sheet addAction:applyAction];
    [sheet addAction:cancelAction];
    
//    UIUserInterfaceIdiomPhone NS_ENUM_AVAILABLE_IOS(3_2), // iPhone and iPod touch style UI
//    UIUserInterfaceIdiomPad NS_ENUM_AVAILABLE_IOS(3_2), // iPad style UI

    if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        [sheet.popoverPresentationController setPermittedArrowDirections:UIPopoverArrowDirectionAny];
        sheet.popoverPresentationController.sourceView = self.view;
        sheet.popoverPresentationController.barButtonItem = self.abortButton;
        [self presentViewController:sheet animated:YES completion:nil];
    }
    else {
        [self presentViewController:sheet animated:YES completion:nil];
    }

}


#pragma mark - Managing the detail item

- (void)setTodoItem:(TodoItem *)todoItem {
    if (_todoItem != todoItem) {
        _todoItem = todoItem;
        [self configureView];
    }
}

#pragma mark - UIPopoverPresentationControllerDelegate






@end
