//
//  DetailViewController.m
//  todo
//
//  Created by JUE DUKE on 2017/4/2.
//  Copyright © 2017年 JUE DUKE. All rights reserved.
//

#import "DetailViewController.h"
#import "NotificationDefines.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

- (void)configureView {
    // Update the user interface for the detail item.
    if (_todoItem) {
        self.detailDescriptionLabel.text = [NSString stringWithFormat:@"Create at %@", [self.todoItem.createTime description]];
        self.title = _todoItem.title;
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
    self.todoItem.todoStatus = TodoStatus_Abort;
    [[NSNotificationCenter defaultCenter]postNotificationName:NOTI_TODO_ABORT object:self.todoItem];
}


#pragma mark - Managing the detail item

- (void)setTodoItem:(TodoItem *)todoItem {
    if (_todoItem != todoItem) {
        _todoItem = todoItem;
        [self configureView];
    }
}


@end
