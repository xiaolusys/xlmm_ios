//
//  JMFIneCouponCell.m
//  XLMM
//
//  Created by zhang on 16/11/24.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMFIneCouponCell.h"
#import "JMFineCouponModel.h"

@interface JMFIneCouponCell ()

@property (nonatomic, strong) UIImageView *iconImage;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation JMFIneCouponCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    UIImageView *iconImage = [UIImageView new];
    [self.contentView addSubview:iconImage];
    self.iconImage = iconImage;
    self.iconImage.userInteractionEnabled = YES;
    self.iconImage.contentMode = UIViewContentModeScaleAspectFill;
    self.iconImage.layer.masksToBounds = YES;
    self.iconImage.layer.borderWidth = 0.5;
    self.iconImage.layer.borderColor = [UIColor buttonDisabledBorderColor].CGColor;
    self.iconImage.layer.cornerRadius = 5;
    
    UILabel *titleLabel = [UILabel new];
    [self.contentView addSubview:titleLabel];
    self.titleLabel = titleLabel;
    self.titleLabel.font = [UIFont systemFontOfSize:13.];
    self.titleLabel.numberOfLines = 0;
    
    kWeakSelf
    [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView).offset(10);
        make.top.equalTo(weakSelf.contentView).offset(5);
        make.width.height.mas_equalTo(@(80));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.iconImage.mas_right).offset(10);
        make.centerY.equalTo(weakSelf.iconImage.mas_centerY);
        make.right.equalTo(weakSelf.contentView).offset(-5);
    }];
    
    
    
}

- (void)setModel:(JMFineCouponModel *)model {
    _model = model;
    
    [self.iconImage sd_setImageWithURL:[NSURL URLWithString:[[model.head_img imageGoodsOrderCompression] JMUrlEncodedString]] placeholderImage:[UIImage imageNamed:@"placeHolderImage"]];
    self.titleLabel.text = model.name;
    
    
}



@end











































































