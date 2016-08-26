//
//  JMServiceEnterCell.m
//  XLMM
//
//  Created by zhang on 16/8/20.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMServiceEnterCell.h"
#import "MMClass.h"

@interface JMServiceEnterCell ()

@property (nonatomic, strong) UIImageView *iconImage;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *descTitleLabel;

@end

@implementation JMServiceEnterCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    self.iconImage = [UIImageView new];
    [self.contentView addSubview:self.iconImage];
    
    self.titleLabel = [UILabel new];
    [self.contentView addSubview:self.titleLabel];
    self.titleLabel.textColor = [UIColor buttonTitleColor];
    self.titleLabel.font = [UIFont systemFontOfSize:18.];
    
    self.descTitleLabel = [UILabel new];
    [self.contentView addSubview:self.descTitleLabel];
    self.descTitleLabel.textColor = [UIColor dingfanxiangqingColor];
    self.descTitleLabel.font = [UIFont systemFontOfSize:14.];

    UIView *lineView = [UIView new];
    [self.contentView addSubview:lineView];
    lineView.backgroundColor = [UIColor lineGrayColor];
    
    kWeakSelf

    [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView).offset(15);
        make.centerY.equalTo(weakSelf.contentView.mas_centerY);
        make.width.mas_equalTo(@65);
        make.height.mas_equalTo(@50);
    }];

    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.iconImage);
        make.left.equalTo(weakSelf.iconImage.mas_right).offset(15);
    }];

    [self.descTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.titleLabel.mas_bottom).offset(15);
        make.left.equalTo(weakSelf.titleLabel);
    }];

    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView).offset(15);
        make.right.bottom.equalTo(weakSelf.contentView);
        make.height.mas_equalTo(@1);
    }];

}

- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
    
    self.iconImage.image = [UIImage imageNamed:dataDic[@"iconImage"]];
    self.titleLabel.text = dataDic[@"title"];
    self.descTitleLabel.text = dataDic[@"descTitle"];
    
    
}



@end
















































