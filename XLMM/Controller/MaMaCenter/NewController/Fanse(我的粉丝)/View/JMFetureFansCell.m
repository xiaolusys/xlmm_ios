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

@property (nonatomic, strong) UILabel *descLabel;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UILabel *timeLabel;

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
    
    UILabel *descLabel = [UILabel new];
    [self.contentView addSubview:descLabel];
    self.descLabel = descLabel;
    self.descLabel.font = [UIFont systemFontOfSize:12.];
    self.descLabel.textColor = [UIColor timeLabelColor];
    
    UILabel *nameLabel = [UILabel new];
    [self.contentView addSubview:nameLabel];
    self.nameLabel = nameLabel;
    self.nameLabel.font = [UIFont systemFontOfSize:14.];
    
    UILabel *timeLabel = [UILabel new];
    [self.contentView addSubview:timeLabel];
    self.timeLabel = timeLabel;
    self.timeLabel.font = [UIFont systemFontOfSize:13.];
    self.timeLabel.textColor = [UIColor timeLabelColor];
    
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
    
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.nameLabel);
        make.top.equalTo(weakSelf.nameLabel.mas_bottom).offset(15);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.contentView).offset(-10);
        make.centerY.equalTo(weakSelf.nameLabel.mas_centerY);
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
    
    if (model.headimgurl.length == 0) {
        self.iconImage.image = [UIImage imageNamed:@"zhanwei"];
    }else {
        [self.iconImage sd_setImageWithURL:[NSURL URLWithString:[model.headimgurl URLEncodedString]]];
    }
    self.iconImage.layer.cornerRadius = 30;
    self.iconImage.layer.borderWidth = 0.5;
    self.iconImage.layer.borderColor = [UIColor imageViewBorderColor].CGColor;
    self.iconImage.layer.masksToBounds = YES;
    
    if ([model.nick isEqualToString:@""]) {
        self.nameLabel.text = @"匿名用户";
    }else {
        self.nameLabel.text = model.nick;
    }
    
    NSMutableString *String1 = [[NSMutableString alloc] initWithString:model.modified];
    [String1 replaceCharactersInRange:NSMakeRange(10, 1) withString:@" "];
    
    NSString *string2 = [NSString stringWithFormat:@"%@",String1];
    NSString *string3 = [string2 substringWithRange:NSMakeRange(5,11)];

    self.timeLabel.text = [NSString stringWithFormat:@"%@",string3];
    
    self.descLabel.text = @"通过您的分享成为粉丝";
    
}

@end































