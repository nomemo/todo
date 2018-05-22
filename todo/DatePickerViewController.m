//
//  DatePickerViewController.m
//  todo
//
//  Created by 张珏 on 2018/5/22.
//  Copyright © 2018年 JUE DUKE. All rights reserved.
//

#import "DatePickerViewController.h"

@interface DatePickerViewController ()

@end

@implementation DatePickerViewController

- (void)viewDidLoad {
    
    if (self.date) {
        self.datePicker.date = self.date;
    }
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)confirm:(id)sender {
    if (self.dateCallback) {
        self.dateCallback(self.datePicker.date);
    }
    [self.navigationController popViewControllerAnimated:true];
}
@end
