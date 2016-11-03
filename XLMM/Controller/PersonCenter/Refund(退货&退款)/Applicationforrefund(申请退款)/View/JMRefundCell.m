//
//  JMRefundCell.m
//  XLMM
//
//  Created by zhang on 16/6/15.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMRefundCell.h"

@interface JMRefundCell ()

@property (nonatomic,strong) UILabel *nameLabel;

@property (nonatomic,strong) UILabel *decLabel;

@property (nonatomic, strong) UIImageView *iconImage;

@end

@implementation JMRefundCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    UIImageView *iconImage = [UIImageView new];
    [self.contentView addSubview:iconImage];
    self.iconImage = iconImage;
    
    UILabel *nameLabel = [UILabel new];
    [self.contentView addSubview:nameLabel];
    self.nameLabel = nameLabel;
    self.nameLabel.font = [UIFont systemFontOfSize:14.];
    
    UILabel *decLabel = [UILabel new];
    [self.contentView addSubview:decLabel];
    self.decLabel = decLabel;
    self.decLabel.numberOfLines = 0;
    self.decLabel.font = [UIFont systemFontOfSize:12.];
    self.decLabel.textColor = [UIColor titleDarkGrayColor];
    
    kWeakSelf
    
    [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView).offset(10);
        make.centerY.equalTo(weakSelf.contentView.mas_centerY);
        make.width.height.mas_equalTo(@30);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.iconImage.mas_right).offset(10);
        make.centerY.equalTo(weakSelf.contentView.mas_centerY);
    }];
    
    [self.decLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.nameLabel.mas_right).offset(10);
        make.centerY.equalTo(weakSelf.contentView.mas_centerY);
//        make.top.equalTo(weakSelf.contentView).offset(10);
        make.right.equalTo(weakSelf.contentView).offset(-10);
    }];
    
    
    
}
- (void)configWithModel:(JMAppForRefundModel *)model Index:(NSInteger)index {
    
    self.nameLabel.text = model.name;
    self.decLabel.text = model.desc;
    
    if (index == 0) {
        self.iconImage.image = [UIImage imageNamed:@"refund_xiaolutuikuanImage"];
    }else if (index == 1) {
        self.iconImage.image = [UIImage imageNamed:@"refund_othertuikuan"];
    }else {
        
    }
    
}
- (void)configWithPayModel:(JMContinuePayModel *)model Index:(NSInteger)index {
    self.nameLabel.text = model.name;
    self.decLabel.text = model.msg;
    if (index == 0) {
        self.iconImage.image = [UIImage imageNamed:@"weixinzhifu"];
    }else if (index == 1) {
        self.iconImage.image = [UIImage imageNamed:@"zhifubao"];
    }else {
        
    }
}
@end






















