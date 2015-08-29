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



@interface AddAdressViewController ()


@end

@implementation AddAdressViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
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
       
        
        self.provinceTextField.text = _addressModel.provinceName;
        self.cityTextField.text = _addressModel.cityName;
        self.countyTextField.text = _addressModel.countyName;
    }
    
    self.numberTextField.keyboardType = UIKeyboardTypeNumberPad;
    
}

- (void)setInfo{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    if (_isAdd == YES) {
        label.text = @"新增收货地址";
        
    }else{
        label.text = @"修改收货地址";

    }
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:26];
    label.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = label;
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon-fanhui.png"]];
    imageView.frame = CGRectMake(8, 8, 18, 31);
    [button addSubview:imageView];
    [button addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = leftItem;
}

- (void)backBtnClicked:(UIButton *)button{
    NSLog(@"fanhui");
    [self.navigationController popViewControllerAnimated:YES];
}





- (void)pickerDidChangeStatus:(AddressPickerView *)picker{
 //   self.areaValue = [NSString stringWithFormat:@"%@ %@ %@", picker.locate.state, picker.locate.city, picker.locate.district];
//    
//    NSLog(@"chen");
//    
//    NSLog(@"%@", picker.address.provinceName);
//    NSLog(@"%@", picker.address.cityName);
//
//    NSLog(@"%@", picker.address.countyName);

    self.provinceTextField.text = picker.address.provinceName;
    self.cityTextField.text = picker.address.cityName;
    self.countyTextField.text = picker.address.countyName;
//    NSLog(@"dddadf");
    
}

-(void)cancelLocatePicker
{
    [self.addressPicker cancelPicker];
    self.addressPicker.delegate = nil;
    self.addressPicker = nil;
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
    CGRect rect = self.view.frame;
    rect.origin.y = -[UIScreen mainScreen].bounds.size.height + 400;
    if ([UIScreen mainScreen].bounds.size.width == 320) {
        
    
    [UIView animateWithDuration:0.3 animations:^{
        self.view.frame = rect;

    } completion:^(BOOL finished) {
        
    }];
    }
    
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    [UIView animateWithDuration:0.3 animations:^{
            self.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    } completion:^(BOOL finished) {
        
    }];

    
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
        self.infoLabel.text = @"请选择省";
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
                                     @"receiver_state": _provinceTextField.text,
                                     @"receiver_city": _cityTextField.text,
                                     @"receiver_district": _countyTextField.text,
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
               
                  
              }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  
                  NSLog(@"Error: %@", error);
                  
              }];
    }
    else{
        NSLog(@"修改地址");
        NSDictionary *parameters = @{
                                     @"id":_addressModel.addressID,
                                     @"receiver_state": _provinceTextField.text,
                                     @"receiver_city": _cityTextField.text,
                                     @"receiver_district": _countyTextField.text,
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
                  
                  NSLog(@"修改成功");
                  
                  
              }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  
                  NSLog(@"Error: %@", error);
                  
              }];

    }
    
    //[self.navigationController popViewControllerAnimated:YES];
}
@end
