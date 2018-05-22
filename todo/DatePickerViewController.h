//
//  DatePickerViewController.h
//  todo
//
//  Created by 张珏 on 2018/5/22.
//  Copyright © 2018年 JUE DUKE. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DatePickerSource)(NSDate *date);

@interface DatePickerViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIButton *applybutton;
@property (strong, nonatomic) void(^dateCallback)(NSDate *date);
@property (strong, nonatomic) NSDate *date;

- (IBAction)confirm:(id)sender;

@end
