//
//  JMChoiseWithDrawCell.m
//  XLMM
//
//  Created by zhang on 16/9/20.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMChoiseWithDrawCell.h"
#import "MMClass.h"

@interface JMChoiseWithDrawCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *descTitleLabel;
@property (nonatomic, strong) UIImageView *iconImage;


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
    self.titleLabel.font = CS_SYSTEMFONT(12.);
    self.titleLabel.textColor = [UIColor buttonTitleColor];
    [self.contentView addSubview:self.titleLabel];
    
    self.descTitleLabel = [UILabel new];
    self.descTitleLabel.font = CS_SYSTEMFONT(12.);
    self.descTitleLabel.textColor = [UIColor dingfanxiangqingColor];
    [self.contentView addSubview:self.descTitleLabel];
    
    self.iconImage = [UIImageView new];
    self.iconImage.image = CS_IMAGE(@"rightArrow");
    [self.contentView addSubview:self.iconImage];
    
    kWeakSelf
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.contentView.mas_centerY);
        make.left.equalTo(weakSelf.contentView).offset(15);
    }];
    
    [self.descTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.contentView.mas_centerY);
        make.right.equalTo(weakSelf.contentView).offset(-35);
    }];
    
    [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.contentView.mas_centerY);
        make.right.equalTo(weakSelf.contentView).offset(-10);
        make.width.mas_equalTo(@16);
        make.height.mas_equalTo(@25);
    }];
    
    
    
    UIView *lineView = [UIView new];
    [self.contentView addSubview:lineView];
    lineView.backgroundColor = [UIColor lineGrayColor];
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

@end


















































































