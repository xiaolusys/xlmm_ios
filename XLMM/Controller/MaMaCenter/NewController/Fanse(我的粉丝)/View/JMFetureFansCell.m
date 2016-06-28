//
//  JMFetureFansCell.m
//  XLMM
//
//  Created by zhang on 16/6/27.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMFetureFansCell.h"
#import "Masonry.h"
#import "MMClass.h"
#import "JMFetureFansModel.h"
#import "NSString+URL.h"

@interface JMFetureFansCell ()

@property (nonatomic, strong) UIImageView *iconImage;

@property (nonatomic, strong) UILabel *phoneLabel;

@property (nonatomic, strong) UILabel *nameLabel;

@end

@implementation JMFetureFansCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
        [self layoutUI];
    }
    return self;
}

- (void)initUI {
    UIImageView *iconImage = [UIImageView new];
    [self.contentView addSubview:iconImage];
    self.iconImage = iconImage;
    
    UILabel *phoneLabel = [UILabel new];
    [self.contentView addSubview:phoneLabel];
    self.phoneLabel = phoneLabel;
    
    UILabel *nameLabel = [UILabel new];
    [self.contentView addSubview:nameLabel];
    self.nameLabel = nameLabel;
    
    
    
    
}
- (void)layoutUI {
    kWeakSelf
    
    [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(weakSelf.contentView).offset(10);
        make.width.height.mas_equalTo(@60);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.iconImage.mas_right).offset(10);
        make.top.equalTo(weakSelf.iconImage.mas_top).offset(10);
    }];
    
    [self.phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.nameLabel);
        make.top.equalTo(weakSelf.nameLabel.mas_bottom).offset(15);
    }];
    
    
    
    
}
/**
 *      if (model.fans_thumbnail.length == 0) {
 self.picImageView.image = [UIImage imageNamed:@"zhanwei"];
 }else {
 [self.picImageView sd_setImageWithURL:[NSURL URLWithString:[model.fans_thumbnail URLEncodedString]]];
 }
 
 self.picImageView.layer.cornerRadius = 30;
 self.picImageView.layer.borderWidth = 0.5;
 self.picImageView.layer.borderColor = [UIColor imageViewBorderColor].CGColor;
 self.picImageView.layer.masksToBounds = YES;
 self.name.text = model.fans_nick;
 
 self.desLabel.text = model.fans_description;
 self.timeLabel.text = [self dealTime:model.created];
 *
 */
- (void)fillData:(JMFetureFansModel *)model {
    
    if (model.headimgurl.length == 0 ) {
        self.iconImage.image = [UIImage imageNamed:@"zhanwei"];
    }else {
        [self.iconImage sd_setImageWithURL:[NSURL URLWithString:[model.headimgurl URLEncodedString]]];
    }
    
//    if (model.nick.length == 0) {
//        self.nameLabel.text = @"来自手机客户端";
//    }else {
//        self.nameLabel.text = model.nick;
//    }
    self.nameLabel.text = model.nick;
    
    self.phoneLabel.text = model.mobile;
    
    
}

@end































