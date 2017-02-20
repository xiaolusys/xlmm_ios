//
//  AddressPickerView.h
//  XLMM
//
//  Created by younishijie on 15/8/13.
//  Copyright (c) 2015年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddressModel.h"


@class AddressPickerView;

@protocol AddressPickerDelegate <NSObject>

- (void)pickerDidChangeStatus:(AddressPickerView *)picker Button:(UIButton *)btn;

@end

@interface AddressPickerView : UIView<UIPickerViewDelegate, UIPickerViewDataSource>

@property (assign, nonatomic)id <AddressPickerDelegate>delegate;
@property (strong, nonatomic)UIPickerView *addressPicker;
@property (retain, nonatomic)AddressModel *address;

- (id)initWithdelegate:(id <AddressPickerDelegate>)delegate;

- (void)showInView:(UIView *)view;

- (void)cancelPicker;

@end
