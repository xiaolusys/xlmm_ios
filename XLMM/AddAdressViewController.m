//
//  AddAdressViewController.m
//  XLMM
//
//  Created by younishijie on 15/8/13.
//  Copyright (c) 2015年 上海己美. All rights reserved.
//

#import "AddAdressViewController.h"
#import "AddressModel.h"



@interface AddAdressViewController ()


@end

@implementation AddAdressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
  
    self.title = @"新增收货地址";
    
    self.numberTextField.keyboardType = UIKeyboardTypeNumberPad;
    
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
    
    return NO;
    }
    else{
        return YES;
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
#if 0
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
#endif
    NSLog(@"save succeed!");
    AddressModel *model = [[AddressModel alloc] init];
    model.provinceName = _provinceTextField.text;
    model.cityName = _cityTextField.text;
    model.countyName = _countyTextField.text;
    model.streetName = _streetTextView.text;
    model.buyerName = _nameTextField.text;
    model.phoneNumber = _numberTextField.text;
    if ([_delegate respondsToSelector:@selector(updateAddressList:)] && _delegate != nil) {
        [self.delegate updateAddressList:model];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}
@end
