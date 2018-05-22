//
//  RecordUITableViewCell.h
//  todo
//
//  Created by 张珏 on 2018/5/20.
//  Copyright © 2018年 JUE DUKE. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RecordItem;

#define RecordUITableViewCellID @"RecordUITableViewCell"

@interface RecordUITableViewCell : UITableViewCell

@property (weak, nonatomic) RecordItem *item;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *recordTime;
@property (weak, nonatomic) IBOutlet UILabel *money;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *status;



@end
