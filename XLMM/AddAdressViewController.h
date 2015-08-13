//
//  AddAdressViewController.h
//  XLMM
//
//  Created by younishijie on 15/8/13.
//  Copyright (c) 2015年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddressPickerView.h"

@class AddressModel;

@protocol AddAddressDelegate <NSObject>

- (void)updateAddressList:(AddressModel *)model;


@end

@interface AddAdressViewController : UIViewController<UITextFieldDelegate, UITextViewDelegate, AddressPickerDelegate>

@property (nonatomic, weak)id<AddAddressDelegate>delegate;


@property (weak, nonatomic) IBOutlet UITextField *provinceTextField;
@property (weak, nonatomic) IBOutlet UITextField *cityTextField;
@property (weak, nonatomic) IBOutlet UITextField *countyTextField;
@property (weak, nonatomic) IBOutlet UITextView *streetTextView;

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *numberTextField;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;

@property (strong, nonatomic) AddressPickerView *addressPicker;

- (IBAction)saveBtnClicked:(id)sender;

@end
