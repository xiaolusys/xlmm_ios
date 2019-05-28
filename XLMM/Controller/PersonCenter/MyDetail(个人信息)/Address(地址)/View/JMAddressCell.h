//
//  JMAddressCell.h
//  XLMM
//
//  Created by zhang on 17/2/21.
//  Copyright © 2017年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JMAddressModel;
@protocol JMAddressCellDelegate <NSObject>
- (void)modifyAddress:(JMAddressModel*)medel;

@end

@interface JMAddressCell : UITableViewCell

@property (assign, nonatomic)id <JMAddressCellDelegate> delegate;

@property (nonatomic, strong) JMAddressModel *addressModel;

@property (nonatomic, strong) UIButton *modifyButton;
@property (nonatomic, strong) UIImageView *selectedImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *phoneLabel;
@property (nonatomic, strong) UILabel *descAddressLabel;
@property (nonatomic, strong) UILabel *defaultLabel;
@property (nonatomic, strong) UIImageView *rightImageView;


@end
