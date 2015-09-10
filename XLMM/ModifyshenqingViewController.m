//
//  ModifyshenqingViewController.m
//  XLMM
//
//  Created by younishijie on 15/9/10.
//  Copyright (c) 2015年 上海己美. All rights reserved.
//

#import "ModifyshenqingViewController.h"

@interface ModifyshenqingViewController ()

@end

@implementation ModifyshenqingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"修改申请退货(款)";
    NSLog(@"tid = %@ and oid = %@", self.tid, self.oid);
    
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

@end
