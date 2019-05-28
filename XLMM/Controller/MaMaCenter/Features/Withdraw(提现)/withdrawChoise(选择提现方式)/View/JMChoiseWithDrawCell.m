//
//  JMChoiseWithDrawCell.m
//  XLMM
//
//  Created by zhang on 16/9/20.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMChoiseWithDrawCell.h"

@interface JMChoiseWithDrawCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *descTitleLabel;
@property (nonatomic, strong) UIImageView *iconImage;
@property (nonatomic, strong) UIImageView *cellImage;


@end

@implementation JMChoiseWithDrawCell



- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self craetUI];
    }
    return self;
}

- (void)craetUI {
    // rightArrow 宽高 16-25
    
    self.contentView.backgroundColor = [UIColor countLabelColor];
    
    self.titleLabel = [UILabel new];
    self.titleLabel.font = CS_UIFontSize(14.);
    self.titleLabel.textColor = [UIColor buttonTitleColor];
    [self.contentView addSubview:self.titleLabel];
    
    self.descTitleLabel = [UILabel new];
    self.descTitleLabel.font = CS_UIFontSize(12.);
    self.descTitleLabel.textColor = [UIColor dingfanxiangqingColor];
    [self.contentView addSubview:self.descTitleLabel];
    
    self.iconImage = [UIImageView new];
    self.iconImage.image = CS_UIImageName(@"rightArrow");
    [self.contentView addSubview:self.iconImage];
    
    self.cellImage = [UIImageView new];
    self.cellImage.userInteractionEnabled = YES;
    self.cellImage.hidden = YES;
    [self.contentView addSubview:self.cellImage];
    
    kWeakSelf
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.contentView.mas_centerY);
        make.left.equalTo(weakSelf.contentView).offset(15);
    }];
    
    [self.descTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.contentView.mas_centerY);
        make.right.equalTo(weakSelf.contentView).offset(-35);
    }];
    
    [self.cellImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.contentView.mas_centerY);
        make.right.equalTo(weakSelf.iconImage.mas_left).offset(-10);
        make.width.mas_equalTo(@50);
        make.height.mas_equalTo(@50);
    }];
    
    [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.contentView.mas_centerY);
        make.right.equalTo(weakSelf.contentView).offset(-10);
        make.width.mas_equalTo(@16);
        make.height.mas_equalTo(@25);
    }];
    
    
    
    UIView *lineView = [UIView new];
    [self.contentView addSubview:lineView];
    lineView.backgroundColor = [UIColor buttonDisabledBorderColor];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(@1);
        make.left.right.bottom.equalTo(weakSelf.contentView);
    }];
    
}
- (void)setWithDrawDic:(NSDictionary *)withDrawDic {
    _withDrawDic = withDrawDic;
    
    self.titleLabel.text = withDrawDic[@"title"];
    self.descTitleLabel.text = withDrawDic[@"descTitle"];
    
}
- (void)configSettingData:(NSDictionary *)dict Index:(NSInteger)index {
    if (index == 0) {
        self.cellImage.hidden = NO;
        [self.cellImage sd_setImageWithURL:[NSURL URLWithString:dict[@"cellImage"]]];
        self.cellImage.layer.cornerRadius = 25;
        self.cellImage.layer.borderColor = [UIColor touxiangBorderColor].CGColor;
        self.cellImage.layer.masksToBounds = YES;
        self.cellImage.layer.borderWidth = 1;
    }
    
    self.titleLabel.text = dict[@"title"];
    self.descTitleLabel.text = dict[@"descTitle"];
    self.iconImage.image = CS_UIImageName(dict[@"iconImage"]);
    
    if (index == 2) {
        if ([dict[@"descTitle"] isEqualToString:@""] && [[JMUserDefaults objectForKey:kLoginMethod] isEqualToString:kWeiXinLogin]) {
            self.descTitleLabel.textColor = [UIColor redColor];
            self.descTitleLabel.text = @"未绑定手机号";
        }else {
            self.descTitleLabel.textColor = [UIColor dingfanxiangqingColor];
        }
    }
    
}

@end


















































































