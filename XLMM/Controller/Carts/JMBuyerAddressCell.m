//
//  JMBuyerAddressCell.m
//  XLMM
//
//  Created by zhang on 16/6/21.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMBuyerAddressCell.h"
#import "Masonry.h"
#import "MMClass.h"
#import "JMSelecterButton.h"


@interface JMBuyerAddressCell ()

@property (nonatomic,strong) UIView *baseView;

@property (nonatomic,strong) UIView *lineView;

@property (nonatomic,strong) UIImageView *iconImage;

@property (nonatomic,strong) UILabel *addressLabel;

@property (nonatomic,strong) UILabel *phoneLabel;

@property (nonatomic,strong) UILabel *nameLabel;

@property (nonatomic,strong) JMSelecterButton *changeAddButton;

@end

@implementation JMBuyerAddressCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
        [self layoutUI];
    }
    return self;
}

- (void)createUI {
    
    UIView *baseView = [UIView new];
    [self.contentView addSubview:baseView];
    self.baseView = baseView;
    self.baseView.backgroundColor = [UIColor orangeColor];
    
    UIView *lineView = [UIView new];
    [self.contentView addSubview:lineView];
    self.lineView = lineView;
    self.lineView.backgroundColor = [UIColor lineGrayColor];
    
    UIImageView *iconImage = [UIImageView new];
    [self.baseView addSubview:iconImage];
    self.iconImage = iconImage;
    self.iconImage.image = [UIImage imageNamed:@"address_icon"];
    
    UILabel *addressLabel = [UILabel new];
    [self.baseView addSubview:addressLabel];
    self.addressLabel = addressLabel;
    self.addressLabel.text = @"上海杨浦区内环以外中环以内东纺谷创业园平凉路988号3号楼3421";
    
    UILabel *phoneLabel = [UILabel new];
    [self.baseView addSubview:phoneLabel];
    self.phoneLabel = phoneLabel;
    self.phoneLabel.text = @"13800000088";
    
    UILabel *nameLabel = [UILabel new];
    [self.baseView addSubview:nameLabel];
    self.nameLabel = nameLabel;
    self.nameLabel.text = @"小鹿妈妈";
    
    JMSelecterButton *changeAddButton = [JMSelecterButton new];
    [self.baseView addSubview:changeAddButton];
    self.changeAddButton = changeAddButton;
    [self.changeAddButton setSelecterBorderColor:[UIColor buttonEnabledBackgroundColor] TitleColor:[UIColor buttonEnabledBackgroundColor] Title:@"修改地址" TitleFont:12. CornerRadius:10];
    
    
}
- (void)layoutUI {
    kWeakSelf
    
    [self.baseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(weakSelf.contentView);
        make.bottom.equalTo(weakSelf.contentView).offset(-15);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf.contentView);
        make.top.equalTo(weakSelf.baseView.mas_bottom);
        make.height.mas_equalTo(@15);
    }];
    
    [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.baseView).offset(10);
        make.centerY.equalTo(weakSelf.baseView.mas_centerY);
        make.width.mas_equalTo(@20);
        make.height.mas_equalTo(@30);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.iconImage.mas_right).offset(15);
        make.top.equalTo(weakSelf.baseView).offset(15);
    }];
    
    [self.phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.nameLabel.mas_right).offset(15);
        make.top.equalTo(weakSelf.nameLabel);
    }];
    
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.iconImage.mas_bottom).offset(10);
        make.left.equalTo(weakSelf.nameLabel);
        make.right.equalTo(weakSelf.changeAddButton.mas_left).offset(30);
        make.bottom.equalTo(weakSelf.baseView).offset(-15);
    }];
    
    [self.changeAddButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.baseView).offset(-10);
        make.width.mas_equalTo(@65);
        make.height.mas_equalTo(@25);
    }];
    
    
    
}


@end









































