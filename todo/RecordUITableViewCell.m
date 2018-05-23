//
//  RecordUITableViewCell.m
//  todo
//
//  Created by 张珏 on 2018/5/20.
//  Copyright © 2018年 JUE DUKE. All rights reserved.
//

#import "RecordUITableViewCell.h"
#import "RecordItem.h"

@implementation RecordUITableViewCell

- (void)setItem:(RecordItem *)item {
    self.title.text = item.title;
    self.recordTime.text = item.createTimeString;
    self.time.text = [NSString stringWithFormat:@"%@ min",@(item.time)];
    self.money.text = [NSString stringWithFormat:@"￥ %@",@(item.money)];
    self.status.text = [RecordItem totoStatusString:item.todoStatus];
    if (item.value == RecordValue_Spend) {
        self.time.textColor = [UIColor redColor];
        self.money.textColor = [UIColor redColor];
    }else {
        self.time.textColor = [UIColor greenColor];
        self.money.textColor = [UIColor greenColor];

    }
    
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
