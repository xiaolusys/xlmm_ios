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

- (void)deleteAddress:(AddressModel*)model;
- (void)modifyAddress:(AddressModel*)medel;


@end



@interface AddressTableCell : UITableViewCell <UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *firstLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondLabel;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (weak, nonatomic) IBOutlet UIButton *modifyBtn;
@property (weak, nonatomic) IBOutlet UIImageView *frontImageView;
- (IBAction)deleteAddress:(id)sender;
- (IBAction)modifyAddress:(id)sender;

@property (strong, nonatomic)AddressModel *addressModel;
@property (assign, nonatomic)id<AddressDelegate>delegate;

@end
