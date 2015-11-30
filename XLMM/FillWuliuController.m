//
//  FillWuliuController.m
//  XLMM
//
//  Created by younishijie on 15/11/30.
//  Copyright © 2015年 上海己美. All rights reserved.
//

#import "FillWuliuController.h"
#import "AFNetworking.h"
#import "MMClass.h"
#import "UIViewController+NavigationBar.h"
#import "TuihuoModel.h"
#import "WuliuCompanyController.h"



@interface FillWuliuController ()<UITextFieldDelegate, UIAlertViewDelegate>

@end

@implementation FillWuliuController

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
    [self createNavigationBarWithTitle:@"填写物流信息" selecotr:@selector(backClicked:)];
    self.commitButton.layer.cornerRadius = 20;
    self.commitButton.layer.borderWidth = 1;
    [self disableTijiaoButton];
    
}

- (void)enableTijiaoButton{
    self.commitButton.enabled = YES;
    self.commitButton.backgroundColor = [UIColor buttonEnabledBackgroundColor];
    self.commitButton.layer.borderColor = [UIColor buttonBorderColor].CGColor;
}

- (void)disableTijiaoButton{
    self.commitButton.enabled = NO;
    self.commitButton.backgroundColor = [UIColor buttonDisabledBackgroundColor];
    self.commitButton.layer.borderColor = [UIColor buttonDisabledBorderColor].CGColor;
}

#pragma mark --UITextFieldDelegate--
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (self.companyTextField == textField) {
        [self.danhaoTextField becomeFirstResponder];
        return NO;
    }
    [textField resignFirstResponder];
    return YES;
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (self.companyTextField.text.length >0 && self.danhaoTextField.text.length > 0) {
        [self enableTijiaoButton];
    } else {
        [self disableTijiaoButton];
        
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.companyTextField resignFirstResponder];
    [self.danhaoTextField resignFirstResponder];
    
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

- (IBAction)commitButtonClicked:(id)sender {
    NSLog(@"提交。。。。");
    
    UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:nil message:@"确定要退吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alterView.tag = 1234;
    [alterView show];
    
    


}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 1234) {
        if (buttonIndex == 1) {
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            
            NSString *urlString = [NSString stringWithFormat:@"%@/rest/v1/refunds", Root_URL];
            NSLog(@"urlstring = %@", urlString);
            
            
            
            NSDictionary *parameters = @{@"id":[NSString stringWithFormat:@"%ld", self.model.order_id],
                                         @"modify":@2,
                                         @"company":self.companyTextField.text,
                                         @"sid":self.danhaoTextField.text
                                         };
            
            NSLog(@"parameters = %@", parameters);
            
            [manager POST:urlString parameters:parameters
                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                      
                      NSLog(@"JSON: %@", responseObject);
                      UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:nil message:@"退货成功，去看看其他商品吧！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                      alterView.tag = 4321;
                      alterView.delegate = self;
                      [alterView show];
//                      [self.navigationController popToRootViewControllerAnimated:YES];
//                      NSLog(@"perration = %@", operation);
//                      [self.navigationController popViewControllerAnimated:YES];
                      
                  }
                  failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                      
                      NSLog(@"Error: %@", error);
                      NSLog(@"erro = %@\n%@", error.userInfo, error.description);
                      NSLog(@"perration = %@", operation);
                      
                      
                  }];
        }

    }
    
    if (alertView.tag == 4321) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
    
}

- (IBAction)selectedWuliuClicked:(id)sender {
    WuliuCompanyController *companyVC = [[WuliuCompanyController alloc] initWithNibName:@"WuliuCompanyController" bundle:nil];
    
    [self.navigationController pushViewController:companyVC animated:YES];
    
}
@end
