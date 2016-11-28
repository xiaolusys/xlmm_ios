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

@property (weak, nonatomic) IBOutlet UITextView *streetTextView;
@property (weak, nonatomic) IBOutlet UIView *idCardView;

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *numberTextField;
@property (weak, nonatomic) IBOutlet UITextField *idCardTextField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *idCardheight;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;


@property (nonatomic, assign) BOOL isBondedGoods;

@property (strong, nonatomic) AddressPickerView *addressPicker;
@property (assign, nonatomic)BOOL isAdd;
@property (strong, nonatomic) AddressModel *addressModel;
@property (weak, nonatomic) IBOutlet UITextField *detailsAddressTF;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;

@property (weak, nonatomic) IBOutlet UISwitch *addressSwitch;

- (IBAction)saveBtnClicked:(id)sender;

@end
