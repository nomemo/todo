//
//  TagTableViewController.h
//  todo
//
//  Created by JUE DUKE on 2017/4/16.
//  Copyright © 2017年 JUE DUKE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TagItem.h"


@protocol TagSelectionPageDelegate <NSObject>

- (NSString *)titleForSelection;
- (NSArray<TagItem *> *)selectedTags;
- (void)selectResult:(NSArray<TagItem *> *)selectedTags;

@end

@interface TagTableViewController : UITableViewController

@property (nonatomic, weak) id<TagSelectionPageDelegate> delegate;

@end
