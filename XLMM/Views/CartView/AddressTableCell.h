//
//  AddressTableCell.h
//  XLMM
//
//  Created by younishijie on 15/8/20.
//  Copyright (c) 2015年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AddressModel;

@protocol AddressDelegate <NSObject>

- (void)modifyAddress:(AddressModel*)medel;


@end



@interface AddressTableCell : UITableViewCell <UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *firstLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondLabel;
@property (weak, nonatomic) IBOutlet UIButton *modifyAddressButton;
- (IBAction)modifyAddressClicked:(id)sender;

@property (weak, nonatomic) IBOutlet UIImageView *frontImageView;
- (IBAction)modifyAddress:(id)sender;

@property (strong, nonatomic)AddressModel *addressModel;
@property (assign, nonatomic)id<AddressDelegate>delegate;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leadingWidth;
@property (weak, nonatomic) IBOutlet UIImageView *addressImageView;

@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UILabel *morenLabel;

@property (weak, nonatomic) IBOutlet UIButton *selectedButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *selectedLayout;

@end
