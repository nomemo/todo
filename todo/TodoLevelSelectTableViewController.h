//
//  TodoLevelSelectTableViewController.h
//  todo
//
//  Created by JUE DUKE on 2017/4/7.
//  Copyright © 2017年 JUE DUKE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TodoItem.h"

typedef void(^TodoLevelSelectCallback)(TodoLevel level);

@interface TodoLevelSelectTableViewController : UITableViewController

@property (nonatomic, strong) TodoLevelSelectCallback todoLevelCallback;

@end
