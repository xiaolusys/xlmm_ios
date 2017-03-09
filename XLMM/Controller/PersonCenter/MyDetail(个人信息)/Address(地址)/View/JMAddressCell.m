//
//  JMAddressCell.m
//  XLMM
//
//  Created by zhang on 17/2/21.
//  Copyright © 2017年 上海己美. All rights reserved.
//

#import "JMAddressCell.h"
#import "JMAddressModel.h"


@interface JMAddressCell ()

@end

@implementation JMAddressCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
}
- (void)initUI {
    self.contentView.layer.masksToBounds = YES;
    self.contentView.layer.borderColor = [UIColor lineGrayColor].CGColor;
    self.contentView.layer.borderWidth = 0.5f;
    
    self.nameLabel = [self createLabelWithFont:14. TextColor:[UIColor buttonTitleColor]];
    self.phoneLabel = [self createLabelWithFont:14. TextColor:[UIColor buttonTitleColor]];
    self.descAddressLabel = [self createLabelWithFont:13. TextColor:[UIColor dingfanxiangqingColor]];
    self.descAddressLabel.numberOfLines = 3;
    
    self.defaultLabel = [self createLabelWithFont:13. TextColor:[UIColor buttonEnabledBackgroundColor]];
    self.defaultLabel.layer.masksToBounds = YES;
    self.defaultLabel.layer.cornerRadius = 1.f;
    self.defaultLabel.layer.borderColor = [UIColor buttonEnabledBackgroundColor].CGColor;
    self.defaultLabel.layer.borderWidth = 0.5f;
    self.defaultLabel.text = @"默认地址";
    self.defaultLabel.hidden = YES;
    
    self.rightImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"rightArrow"]];
    self.rightImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    self.selectedImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mamaNewcomer_normal"]];
    self.selectedImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.selectedImageView.hidden = YES;
    
    self.modifyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.modifyButton.layer.masksToBounds = YES;
    self.modifyButton.layer.borderColor = [UIColor buttonEnabledBackgroundColor].CGColor;
    self.modifyButton.layer.borderWidth = 0.5f;
    self.modifyButton.layer.cornerRadius = 15.f;
    [self.modifyButton setTitle:@"修改" forState:UIControlStateNormal];
    [self.modifyButton setTitleColor:[UIColor buttonEnabledBackgroundColor] forState:UIControlStateNormal];
    self.modifyButton.titleLabel.font = [UIFont systemFontOfSize:14.];
    self.modifyButton.hidden = YES;
    [self.modifyButton addTarget:self action:@selector(modifyClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.phoneLabel];
    [self.contentView addSubview:self.descAddressLabel];
    [self.contentView addSubview:self.defaultLabel];
    [self.contentView addSubview:self.rightImageView];
    [self.contentView addSubview:self.selectedImageView];
    [self.contentView addSubview:self.modifyButton];
    
    kWeakSelf
    [self.defaultLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.contentView).offset(15);
        make.left.equalTo(weakSelf.contentView).offset(10);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.contentView).offset(15);
        make.left.equalTo(weakSelf.contentView).offset(10);
    }];
    [self.phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.nameLabel.mas_centerY);
        make.left.equalTo(weakSelf.nameLabel.mas_right).offset(10);
    }];
    [self.descAddressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView).offset(10);
        make.top.equalTo(weakSelf.nameLabel.mas_bottom).offset(10);
        make.width.mas_equalTo(SCREENWIDTH - 40);
    }];
    [self.rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.contentView.mas_centerY);
        make.right.equalTo(weakSelf.contentView).offset(-10);
        make.width.mas_equalTo(@(12));
        make.height.mas_equalTo(@(18));
    }];
    [self.selectedImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.descAddressLabel.mas_centerY);
        make.left.equalTo(weakSelf.contentView).offset(10);
        make.width.mas_equalTo(@(20));
        make.height.mas_equalTo(@(20));
    }];
    [self.modifyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.contentView.mas_centerY);
        make.right.equalTo(weakSelf.contentView).offset(-10);
        make.width.mas_equalTo(@(80));
        make.height.mas_equalTo(@(30));
    }];
    
    
    
}
- (UILabel *)createLabelWithFont:(CGFloat)font TextColor:(UIColor *)color {
    UILabel *label = [UILabel new];
    label.font = [UIFont systemFontOfSize:font];
    label.textColor = color;
    return label;
}


- (void)setAddressModel:(JMAddressModel *)addressModel {
    _addressModel = addressModel;

}
- (void)modifyClick {
    if (_delegate && [_delegate respondsToSelector:@selector(modifyAddress:)]) {
        [_delegate modifyAddress:self.addressModel];
    }
    
}





@end
























































