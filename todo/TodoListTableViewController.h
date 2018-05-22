//
//  TodoListTableViewController.h
//  todo
//
//  Created by JUE DUKE on 2017/4/4.
//  Copyright © 2017年 JUE DUKE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecordItem.h"

@interface TodoListTableViewController : UITableViewController

@property (nonatomic, strong) NSMutableDictionary *todoDicts;
@property (nonatomic, strong) NSMutableArray *sections;

@end
