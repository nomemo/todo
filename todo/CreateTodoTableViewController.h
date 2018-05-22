//
//  CreateTodoTableViewController.h
//  todo
//
//  Created by JUE DUKE on 2017/4/3.
//  Copyright © 2017年 JUE DUKE. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RecordItem;

@interface CreateTodoTableViewController : UITableViewController

- (IBAction)dismissPage:(id)sender;

@property (nonatomic, strong) RecordItem *recordObj;

@end
