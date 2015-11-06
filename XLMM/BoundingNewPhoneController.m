//
//  BoundingNewPhoneController.m
//  XLMM
//
//  Created by younishijie on 15/11/6.
//  Copyright © 2015年 上海己美. All rights reserved.
//

#import "BoundingNewPhoneController.h"
#import "UIColor+RGBColor.h"
#import "UIViewController+NavigationBar.h"

@interface BoundingNewPhoneController ()<UITextFieldDelegate>

@end

@implementation BoundingNewPhoneController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.codeButton.layer.cornerRadius = 16;
    self.codeButton.layer.borderWidth = 1;
    self.codeButton.layer.borderColor = [UIColor colorWithR:245 G:177 B:35 alpha:1].CGColor;
    self.commitButton.layer.cornerRadius = 20;
    self.commitButton.layer.borderWidth = 1;
    self.commitButton.layer.borderColor = [UIColor buttonBorderColor].CGColor;
    self.phoneNumberTF.delegate = self;
    self.codeTF.delegate = self;
    self.phoneNumberTF.keyboardType = UIKeyboardTypeNumberPad;
    self.codeTF.keyboardType = UIKeyboardTypeNumberPad;
    self.phoneNumberTF.borderStyle = UITextBorderStyleNone;
    self.codeTF.borderStyle = UITextBorderStyleNone;
    
    
    [self createNavigationBarWithTitle:@"绑定新手机号" selecotr:@selector(backClicked:)];
    
    
    
}

- (void)backClicked:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
    
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

- (IBAction)getCodeClicked:(id)sender {
}
@end
