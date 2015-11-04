//
//  AddAdressViewController.m
//  XLMM
//
//  Created by younishijie on 15/8/13.
//  Copyright (c) 2015年 上海己美. All rights reserved.
//

#import "AddAdressViewController.h"
#import "AddressModel.h"
#import "AFNetworking.h"
#import "MMClass.h"

#import "UIViewController+NavigationBar.h"

@interface AddAdressViewController ()


@end

@implementation AddAdressViewController{
    NSString *province;
    NSString *city;
    NSString *county;
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
  
    self.title = @"新增收货地址";
    
    [self setInfo];
    
    self.nameTextField.tag = 100;
    self.numberTextField.tag = 101;
    if (_isAdd == NO) {
        NSLog(@"修改地址");       
        self.streetTextView.text = _addressModel.streetName;
        self.nameTextField.text = _addressModel.buyerName;
        self.numberTextField.text = _addressModel.phoneNumber;
        self.detailsAddressTF.hidden = YES;
        
        province = _addressModel.provinceName;
        city = _addressModel.cityName;
        county = _addressModel.countyName;
        
        self.provinceTextField.text = [NSString stringWithFormat:@"%@%@%@", _addressModel.provinceName, _addressModel.cityName, _addressModel.countyName];
        //_addressModel.provinceName;
        self.cityTextField.text = _addressModel.cityName;
        self.countyTextField.text = _addressModel.countyName;
    }
    
    self.numberTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.numberTextField.borderStyle = UITextBorderStyleNone;
    self.nameTextField.borderStyle = UITextBorderStyleNone;
    self.provinceTextField.borderStyle = UITextBorderStyleNone;
    self.detailsAddressTF.borderStyle = UITextBorderStyleNone;
    self.detailsAddressTF.userInteractionEnabled = NO;
    self.saveButton.layer.cornerRadius = 20;
    self.saveButton.layer.borderWidth = 1;
    self.saveButton.layer.borderColor = [UIColor buttonBorderColor].CGColor;
    
    
    self.addressSwitch.tintColor = [UIColor colorWithR:245 G:166 B:35 alpha:1];
    
//    self.addressSwitch.backgroundColor=[UIColor redColor];
//  //on 时颜色
//    self.addressSwitch.onTintColor=[UIColor yellowColor];
//   //off 时边框颜色
//    self.addressSwitch.tintColor=[UIColor purpleColor];
//  //滑块颜色
//    self.addressSwitch.thumbTintColor=[UIColor greenColor];
    [self.addressSwitch addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    //
 //   UITextView
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        //在这里做你响应return键的代码
        [textView resignFirstResponder];
        
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    
    return YES;
}




- (void)valueChanged:(id)sender{
    UISwitch *switch2 = (UISwitch *)sender;
    if (switch2.isOn) {
        NSLog(@"设置为默认地址");
    } else {
        NSLog(@"取消默认地址");
    }
}

- (void)setInfo{
    if (_isAdd == YES) {
      //  label.text = @"新增收货地址";
        [self createNavigationBarWithTitle:@"新增收货地址" selecotr:@selector(backBtnClicked:)];
        
    }else{
      //  label.text = @"修改收货地址";
          [self createNavigationBarWithTitle:@"修改收货地址" selecotr:@selector(backBtnClicked:)];
    }
  
}

- (void)backBtnClicked:(UIButton *)button{
    NSLog(@"fanhui");
    [self.navigationController popViewControllerAnimated:YES];
}





- (void)pickerDidChangeStatus:(AddressPickerView *)picker{


    province = picker.address.provinceName;
    city = picker.address.cityName;
    county = picker.address.countyName;

    NSString *string = [NSString stringWithFormat:@"%@%@%@", picker.address.provinceName, picker.address.cityName, picker.address.countyName];
    self.provinceTextField.text = string;
    
}

-(void)cancelLocatePicker
{
    [self.addressPicker cancelPicker];
    self.addressPicker.delegate = nil;
    self.addressPicker = nil;
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    self.detailsAddressTF.hidden = YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if ([textField isEqual:self.provinceTextField] ||
        [textField isEqual:self.cityTextField] ||
        [textField isEqual:self.countyTextField]) {
        [self cancelLocatePicker];
        self.addressPicker = [[AddressPickerView alloc] initWithdelegate:self];
        [self.addressPicker showInView:self.view];
    
        
        [self.nameTextField resignFirstResponder];
        [self.numberTextField resignFirstResponder];
        [self.streetTextView resignFirstResponder];
        return NO;
    }
    else{
        [self cancelLocatePicker];
        return YES;
    }
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    [textView resignFirstResponder];
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    [textView resignFirstResponder];
}


- (void)textFieldDidBeginEditing:(UITextField *)textField{
//    CGRect rect = self.view.frame;
//    rect.origin.y = -[UIScreen mainScreen].bounds.size.height + 400;
//    if ([UIScreen mainScreen].bounds.size.width == 320) {
//        
//    
//    [UIView animateWithDuration:0.3 animations:^{
//        self.view.frame = rect;
//
//    } completion:^(BOOL finished) {
//        
//    }];
//    }
    
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
//    [UIView animateWithDuration:0.3 animations:^{
//            self.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
//    } completion:^(BOOL finished) {
//        
//    }];

    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.nameTextField resignFirstResponder];
    [self.numberTextField resignFirstResponder];
    [self.streetTextView resignFirstResponder];
    [self cancelLocatePicker];
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

- (IBAction)saveBtnClicked:(id)sender {

    if ([self.provinceTextField.text isEqualToString: @""]) {
        self.infoLabel.text = @"请选择所在地区";
        return;
        
    }
    if ([self.cityTextField.text isEqualToString:@""]) {
        self.infoLabel.text = @"请选择城市";
        return;
    }
    if ([self.countyTextField.text isEqualToString:@""]) {
        self.infoLabel.text = @"请选择区/县";
        return;
    }
    if ([self.streetTextView.text isEqualToString:@""]) {
        self.infoLabel.text = @"请填写收货详细地址";
        return;
    }
    if ([self.nameTextField.text isEqualToString:@""]) {
        self.infoLabel.text = @"请填写收货人姓名";
        return;
    }
    if (self.numberTextField.text.length != 11) {
        self.infoLabel.text = @"请填写正确的收货人手机号码";
        return;
    }

    NSLog(@"save succeed!");
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
  
    if (_isAdd == YES) {
        NSDictionary *parameters = @{
                                     @"receiver_state": province,
                                     @"receiver_city": city,
                                     @"receiver_district": county,
                                     @"receiver_address": _streetTextView.text,
                                     @"receiver_name": _nameTextField.text,
                                     @"receiver_mobile": _numberTextField.text,
                                     };
        NSLog(@"parameters = %@", parameters);
    
        
        NSString *string = [NSString stringWithFormat:@"%@/rest/v1/address/create_address?format=json", Root_URL];
        NSLog(@"url = %@", string);
        [manager POST:string parameters:parameters
              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                  
                  NSLog(@"JSON: %@", responseObject);
                  [self.navigationController popViewControllerAnimated:YES];
               
                  
              }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  
                  NSLog(@"Error: %@", error);
                  
              }];
    }
    else{
        NSLog(@"修改地址");
        NSDictionary *parameters = @{
                                     @"id":_addressModel.addressID,
                                     @"receiver_state": province,
                                     @"receiver_city": city,
                                     @"receiver_district": county,
                                     @"receiver_address": _streetTextView.text,
                                     @"receiver_name": _nameTextField.text,
                                     @"receiver_mobile": _numberTextField.text,
                                     };
        NSLog(@"parameters = %@", parameters);
        
        NSString *modifyUrlStr = [NSString stringWithFormat:@"%@/rest/v1/address/%@/update", Root_URL,self.addressModel.addressID];
        
        NSLog(@"modifyUrlStr = %@", modifyUrlStr);
        
        [manager POST:modifyUrlStr parameters:parameters
              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                  
                  NSLog(@"JSON: %@", responseObject);
                  
                  [self.navigationController popViewControllerAnimated:YES];
                  
                  
                  NSLog(@"修改成功");
                  
                  
              }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  
                  NSLog(@"Error: %@", error);
                  
              }];

    }
    
    //[self.navigationController popViewControllerAnimated:YES];
}
@end
