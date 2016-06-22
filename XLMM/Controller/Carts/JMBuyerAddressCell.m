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

@property (nonatomic,strong) UIView *lineView;

@property (nonatomic,strong) UIImageView *iconImage;

@property (nonatomic,strong) UILabel *addressLabel;

@property (nonatomic,strong) UILabel *phoneLabel;

@property (nonatomic,strong) UILabel *nameLabel;

//@property (nonatomic,strong) JMSelecterButton *changeAddButton;

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
    
    UIView *lineView = [UIView new];
    [self.contentView addSubview:lineView];
    self.lineView = lineView;
    
    UIImageView *iconImage = [UIImageView new];
    [self.contentView addSubview:iconImage];
    self.iconImage = iconImage;
    self.iconImage.image = [UIImage imageNamed:@"address_icon"];
    
    UILabel *phoneLabel = [UILabel new];
    [self.contentView addSubview:phoneLabel];
    self.phoneLabel = phoneLabel;
    self.phoneLabel.text = @"13800000088";
    self.phoneLabel.textColor = [UIColor buttonTitleColor];
    
    UILabel *nameLabel = [UILabel new];
    [self.contentView addSubview:nameLabel];
    self.nameLabel = nameLabel;
    self.nameLabel.textColor = [UIColor buttonTitleColor];
    self.nameLabel.text = @"小鹿妈妈";
    
    UILabel *addressLabel = [UILabel new];
    [self.contentView addSubview:addressLabel];
    self.addressLabel = addressLabel;
    self.addressLabel.numberOfLines = 0;
    self.addressLabel.font = [UIFont systemFontOfSize:12.];
    self.addressLabel.textColor = [UIColor dingfanxiangqingColor];
    self.addressLabel.text = @"上海杨浦区内环以外中环以内东纺谷创业园平凉路988号3号楼3421上海杨浦区内环以外中环以内东纺谷创业园平凉路988号3号楼3421上海杨浦区内环以外中环以内东纺谷创业园平凉路988号3号楼3421";
//    
//    JMSelecterButton *changeAddButton = [JMSelecterButton new];
//    [self.contentView addSubview:changeAddButton];
//    self.changeAddButton = changeAddButton;
//    [self.changeAddButton setSelecterBorderColor:[UIColor buttonEnabledBackgroundColor] TitleColor:[UIColor buttonEnabledBackgroundColor] Title:@"修改地址" TitleFont:12. CornerRadius:10];
//    
    
}
- (void)layoutUI {
    kWeakSelf
    
    [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView).offset(10);
        make.centerY.equalTo(weakSelf.contentView.mas_centerY).offset(-8);
        make.width.mas_equalTo(@20);
        make.height.mas_equalTo(@30);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.iconImage.mas_right).offset(15);
        make.top.equalTo(weakSelf.contentView).offset(15);
    }];
    
    [self.phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.nameLabel.mas_right).offset(15);
        make.top.equalTo(weakSelf.nameLabel);
    }];
    
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.nameLabel.mas_bottom).offset(10);
        make.left.equalTo(weakSelf.nameLabel);
        make.right.equalTo(weakSelf.contentView).offset(-10);
    }];
    
//    [self.changeAddButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(weakSelf.contentView).offset(-10);
//        make.width.mas_equalTo(@65);
//        make.height.mas_equalTo(@25);
//        make.centerY.equalTo(weakSelf.iconImage.mas_centerY);
//    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf.contentView);
        make.top.equalTo(weakSelf.addressLabel.mas_bottom);
        make.height.mas_equalTo(@15);
        make.bottom.equalTo(weakSelf.contentView);
    }];
}


@end









































