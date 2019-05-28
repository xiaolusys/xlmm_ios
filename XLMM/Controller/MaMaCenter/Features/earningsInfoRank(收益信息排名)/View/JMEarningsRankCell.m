//
//  JMEarningsRankCell.m
//  XLMM
//
//  Created by zhang on 16/7/27.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMEarningsRankCell.h"
#import "JMEarningsRankModel.h"
#import "JMMaMaTeamModel.h"

@interface JMEarningsRankCell ()

@property (nonatomic, strong) UILabel *rankLabel;

@property (nonatomic, strong) UIImageView *iconImage;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UILabel *numLabel;

@property (nonatomic, strong) UIImageView *rankImage;

@end

@implementation JMEarningsRankCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    UIView *view = [UIView new];
    [self.contentView addSubview:view];
    
    UIView *lineView = [UIView new];
    [self.contentView addSubview:lineView];
    lineView.backgroundColor = [UIColor countLabelColor];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(10);
        make.right.equalTo(self.contentView).offset(-10);
        make.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(@1);
    }];
    
    self.rankLabel = [UILabel new];
    [view addSubview:self.rankLabel];
    self.rankLabel.textColor = [UIColor buttonTitleColor];
    self.rankLabel.font = [UIFont systemFontOfSize:16.];
    
    self.iconImage = [UIImageView new];
    [self.contentView addSubview:self.iconImage];
    
    self.rankImage = [UIImageView new];
    [view addSubview:self.rankImage];
    
    self.nameLabel = [UILabel new];
    [self.contentView addSubview:self.nameLabel];
    self.nameLabel.font = [UIFont systemFontOfSize:13.];
    self.nameLabel.textColor = [UIColor buttonTitleColor];
    
    
    self.numLabel = [UILabel new];
    [self.contentView addSubview:self.numLabel];
    self.numLabel.font = [UIFont systemFontOfSize:16.];
    self.numLabel.textColor = [UIColor buttonEnabledBackgroundColor];
    
    kWeakSelf

    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView).offset(10);
        make.centerY.equalTo(weakSelf.contentView.mas_centerY);
        make.width.height.mas_equalTo(@25);
    }];
    [self.rankImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view.mas_centerX);
        make.centerY.equalTo(view.mas_centerY);
        make.width.mas_equalTo(@21);
        make.height.mas_equalTo(@24);
    }];
    [self.rankLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view.mas_centerX);
        make.centerY.equalTo(view.mas_centerY);
    }];
    
    [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_right).offset(10);
        make.centerY.equalTo(weakSelf.contentView.mas_centerY);
        make.width.height.mas_equalTo(@36);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.iconImage.mas_right).offset(10);
        make.centerY.equalTo(weakSelf.contentView.mas_centerY);
        make.width.mas_equalTo(@(SCREENWIDTH / 2));
    }];
    
    [self.numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.contentView).offset(-10);
        make.centerY.equalTo(weakSelf.contentView.mas_centerY);
    }];

}
- (void)config:(JMEarningsRankModel *)model Index:(NSInteger)index {
    if (index == 0) {
        self.rankImage.image = [UIImage imageNamed:@"mamaGoldMedal"];
    }else if (index == 1) {
        self.rankImage.image = [UIImage imageNamed:@"mamaSilverMedal"];
    }else if (index == 2) {
        self.rankImage.image = [UIImage imageNamed:@"mamaBronzeMedal"];
    }else {
        self.rankImage.hidden = YES;
        self.rankLabel.text = model.rank;
    }
    
    [self.iconImage sd_setImageWithURL:[NSURL URLWithString:[model.thumbnail JMUrlEncodedString]] placeholderImage:[UIImage imageNamed:@"profiles"]];
    self.iconImage.layer.cornerRadius = 18.;
    self.iconImage.layer.masksToBounds = YES;
    
    self.nameLabel.text = model.mama_nick;
    CGFloat total = [model.total floatValue] / 100.00;
    self.numLabel.text = [NSString stringWithFormat:@"%.2f",total];
    
}
- (void)configTeamModel:(JMMaMaTeamModel *)model Index:(NSInteger)index {
    if (index == 0) {
        self.rankImage.image = [UIImage imageNamed:@"mamaGoldMedal"];
    }else if (index == 1) {
        self.rankImage.image = [UIImage imageNamed:@"mamaSilverMedal"];
    }else if (index == 2) {
        self.rankImage.image = [UIImage imageNamed:@"mamaBronzeMedal"];
    }else {
        self.rankImage.hidden = YES;
        self.rankLabel.text = model.rank;
    }
    
    [self.iconImage sd_setImageWithURL:[NSURL URLWithString:[model.thumbnail JMUrlEncodedString]] placeholderImage:[UIImage imageNamed:@"profiles"]];
    self.iconImage.layer.cornerRadius = 18.;
    self.iconImage.layer.masksToBounds = YES;
    
    self.nameLabel.text = model.mama_nick;
    CGFloat total = [model.total floatValue] / 100.00;
    self.numLabel.text = [NSString stringWithFormat:@"%.2f",total];

}


@end
















































