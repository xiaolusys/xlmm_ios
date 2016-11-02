//
//  AddAdressViewController.m
//  XLMM
//
//  Created by younishijie on 15/8/13.
//  Copyright (c) 2015年 上海己美. All rights reserved.
//

#import "AddAdressViewController.h"
#import "AddressModel.h"

@interface AddAdressViewController ()<UIAlertViewDelegate>


@end

@implementation AddAdressViewController{
    NSString *province;
    NSString *city;
    NSString *county;
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [MobClick beginLogPageView:@"AddAdressViewController"];
    
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
    [MobClick endLogPageView:@"AddAdressViewController"];
}


- (void)viewDidLoad {
    [super viewDidLoad];
  
    self.title = @"新增收货地址";
    
    [self disableTijiaoButton];
    
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

        
        
        UIButton *itemButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
       
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        label.text = @"删除";
        label.textAlignment = NSTextAlignmentRight;
        label.textColor = [UIColor buttonEnabledBackgroundColor];
        [itemButton addSubview:label];
        label.font = [UIFont systemFontOfSize:14];
        [itemButton addTarget:self action:@selector(addressDelete:) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:itemButton];
        self.navigationItem.rightBarButtonItem = rightItem;
        
    }
    
    self.numberTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.numberTextField.borderStyle = UITextBorderStyleNone;
    self.nameTextField.borderStyle = UITextBorderStyleNone;
    self.provinceTextField.borderStyle = UITextBorderStyleNone;
    self.detailsAddressTF.borderStyle = UITextBorderStyleNone;
    self.detailsAddressTF.userInteractionEnabled = NO;
    self.saveButton.layer.cornerRadius = 20;
    self.saveButton.layer.borderWidth = 1;
   // self.saveButton.layer.borderColor = [UIColor buttonBorderColor].CGColor;
    
    
    self.addressSwitch.tintColor = [UIColor buttonEmptyBorderColor];
    
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

- (void)addressDelete:(UIButton *)button{
    NSLog(@"delete");
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"确定要删除吗?" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        NSLog(@"取消");
    } else if (buttonIndex == 1){
        [self deleteAddress];
    }
}

- (void)deleteAddress{
    NSLog(@"%@", self.addressModel.addressID);
    NSString *string = [NSString stringWithFormat:@"%@/rest/v1/address/%@/delete_address", Root_URL, self.addressModel.addressID];
    
    [JMHTTPManager requestWithType:RequestTypePOST WithURLString:string WithParaments:nil WithSuccess:^(id responseObject) {
        [self.navigationController popViewControllerAnimated:YES];
    } WithFail:^(NSError *error) {
        
    } Progress:^(float progress) {
        
    }];
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        //在这里做你响应return键的代码
        [textView resignFirstResponder];
        
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    
    return YES;
}

- (void)enableTijiaoButton{
    self.saveButton.enabled = YES;
    self.saveButton.backgroundColor = [UIColor buttonEnabledBackgroundColor];
    self.saveButton.layer.borderColor = [UIColor buttonEnabledBorderColor].CGColor;
}

- (void)disableTijiaoButton{
    self.saveButton.enabled = NO;
    self.saveButton.backgroundColor = [UIColor buttonDisabledBackgroundColor];
    self.saveButton.layer.borderColor = [UIColor buttonDisabledBorderColor].CGColor;
}



- (void)valueChanged:(id)sender{
    UISwitch *switch2 = (UISwitch *)sender;
    if (switch2.isOn) {
        NSLog(@"设置为默认地址");
        if (_isAdd == NO) {
            [self enableTijiaoButton];
            
        }
        switch2.onTintColor = [UIColor buttonEmptyBorderColor];
        if (self.addressModel.addressID == nil) {
            NSLog(@"添加地址情况下设置为常用地址");//
//#warning set default address
        } else {
            NSLog(@"修改地址情况下设置为常用地址");
            
        //    http://m.xiaolu.so/rest/v1/address
                //  - /{id}/change_default：
            NSString *string = [NSString stringWithFormat:@"%@/rest/v1/address/%@/change_default", Root_URL, self.addressModel.addressID];
            NSLog(@"string = %@", string);
            
            [JMHTTPManager requestWithType:RequestTypePOST WithURLString:string WithParaments:nil WithSuccess:^(id responseObject) {
                
            } WithFail:^(NSError *error) {
                
            } Progress:^(float progress) {
                
            }];
        }
        NSLog(@"%@", self.addressModel.addressID);

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

#pragma mark --UITextFieldDelegate, UITextViewDelegate--

- (void)textViewDidBeginEditing:(UITextView *)textView{
    self.detailsAddressTF.hidden = YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    if (textView == self.streetTextView) {
        [self cancelLocatePicker];
        return YES;
    } return NO;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if ([textField isEqual:self.provinceTextField]) {
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
    if (self.streetTextView.text != nil && ![self.nameTextField.text isEqualToString:@""] && ![self.numberTextField.text isEqualToString:@""] && ![self.provinceTextField.text isEqualToString:@""]) {
        [self enableTijiaoButton];
        
    } else{
        [self disableTijiaoButton];
        
    }
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
    if (self.streetTextView.text != nil && ![self.nameTextField.text isEqualToString:@""] && ![self.numberTextField.text isEqualToString:@""] && ![self.provinceTextField.text isEqualToString:@""]) {
        [self enableTijiaoButton];
        
    } else{
        [self disableTijiaoButton];
        
    }

    
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


- (IBAction)saveBtnClicked:(id)sender {

    if ([self.provinceTextField.text isEqualToString: @""]) {
        self.infoLabel.text = @"请选择所在地区";
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
        
        [JMHTTPManager requestWithType:RequestTypePOST WithURLString:string WithParaments:parameters WithSuccess:^(id responseObject) {
            [self.navigationController popViewControllerAnimated:YES];
        } WithFail:^(NSError *error) {
            
        } Progress:^(float progress) {
            
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
        
        [JMHTTPManager requestWithType:RequestTypePOST WithURLString:modifyUrlStr WithParaments:parameters WithSuccess:^(id responseObject) {
            [self.navigationController popViewControllerAnimated:YES];
        } WithFail:^(NSError *error) {
            
        } Progress:^(float progress) {
            
        }];

    }
    
    //[self.navigationController popViewControllerAnimated:YES];
}
@end
