//
//  AddressView.h
//  XLMM
//
//  Created by younishijie on 15/8/22.
//  Copyright (c) 2015年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AddressView;

@protocol BuyAddressDelegate <NSObject>

- (void)selectAddress:(AddressView *)addView;
- (void)modifyAddress:(AddressView *)addView;


@end

@interface AddressView : UIView
@property (strong, nonatomic) IBOutlet UIView *view;
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@property (strong, nonatomic) IBOutlet UIButton *modifyBtn;

@property (strong, nonatomic) IBOutlet UIButton *selectBtn;

@property (weak, nonatomic)id<BuyAddressDelegate>delegate;


- (IBAction)selectClicked:(id)sender;
- (IBAction)modifyClicked:(id)sender;


@end
