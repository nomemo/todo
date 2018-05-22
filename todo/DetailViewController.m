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
@property (weak, nonatomic) IBOutlet UIBarButtonItem *startButton;


@property (weak, nonatomic) IBOutlet UIView *statusBar;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *statusBarBottomConstraint;


@property (weak, nonatomic) IBOutlet UILabel *createTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *startTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *finishTimeLabel;

@property (weak, nonatomic) IBOutlet UILabel *levelLabel;

@property (weak, nonatomic) IBOutlet UILabel *tagDetailLabel;

@end

@implementation DetailViewController



- (void)hideStatusBar:(BOOL)hide {
    [self.view layoutIfNeeded];

    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        if (hide) {
            self.statusBarBottomConstraint.constant = -CGRectGetHeight(self.statusBar.frame);
        } else {
            self.statusBarBottomConstraint.constant = 0.0;
        }
        [self.view layoutIfNeeded];
    } completion:nil];
}

- (void)setupStatusbar {
    
    [self.view layoutIfNeeded];
    
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        switch (self->_todoItem.todoStatus) {
            case TodoStatus_Processing:
                self.statusBar.backgroundColor = [UIColor blueColor];
                break;
            case TodoStatus_Finish:
                self.statusBar.backgroundColor = [UIColor greenColor];
                break;
            case TodoStatus_Abort:
                self.statusBar.backgroundColor = [UIColor redColor];
                break;
            case TodoStatus_NotBeign:
                [self hideStatusBar:true];
                break;
        }
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.statusLabel.text = [RecordItem totoStatusString:self->_todoItem.todoStatus];
    }];

}


- (void)configureView {
    // Update the user interface for the detail item.
    self.title = _todoItem.title;
    [self setupStatusbar];
    self.createTimeLabel.text = [self.todoItem.createTime description];
    self.startTimeLabel.text = [self.todoItem.startTime description];
    self.finishTimeLabel.text = [self.todoItem.endTime description];

    self.tagDetailLabel.text = [self.todoItem.tags componentsJoinedByString:@","];
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


- (IBAction)changeStatus:(id)sender {
    if (sender == self.startButton) {
        [self statusChangeTo:TodoStatus_Processing];
    } else if (sender == self.finishButton) {
        [self statusChangeTo:TodoStatus_Finish];
    } else if (sender == self.abortButton) {
        UIAlertController* sheet = [UIAlertController alertControllerWithTitle:@"Aboart Todo?" message:@"This will not changeable" preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *applyAction = [UIAlertAction actionWithTitle:@"Apply" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [self statusChangeTo:TodoStatus_Abort];
        }];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
        [sheet addAction:applyAction];
        [sheet addAction:cancelAction];
        
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
}

- (void)statusChangeTo:(TodoStatus)status {
    self.todoItem.todoStatus = status;
    self.startTimeLabel.text = [self.todoItem.startTime description];
    self.finishTimeLabel.text = [self.todoItem.endTime description];
    [self hideStatusBar:NO];
    [self setupStatusbar];
    [[NSNotificationCenter defaultCenter]postNotificationName:NOTI_TODO_STATUS object:self.todoItem];
}


#pragma mark - Managing the detail item

- (void)setTodoItem:(RecordItem *)todoItem {
    if (_todoItem != todoItem) {
        _todoItem = todoItem;
        [self configureView];
    }
}

#pragma mark - UIPopoverPresentationControllerDelegate






@end
