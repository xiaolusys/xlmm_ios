//
//  JMNewcomerTaskCell.m
//  XLMM
//
//  Created by zhang on 16/8/3.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMNewcomerTaskCell.h"
#import "MMClass.h"
#import "JMNewcomerTaskModel.h"

@interface JMNewcomerTaskCell ()

@property (nonatomic, strong) UILabel *descLabel;

@property (nonatomic, strong) UIImageView *showImage;

@property (nonatomic, strong) UIImageView *completeImage;

@end

@implementation JMNewcomerTaskCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    self.descLabel = [UILabel new];
    [self.contentView addSubview:self.descLabel];
    self.descLabel.font = [UIFont systemFontOfSize:16.];
    self.descLabel.textColor = [UIColor dingfanxiangqingColor];
    
    self.showImage = [UIImageView new];
    [self.contentView addSubview:self.showImage];
    
    self.completeImage = [UIImageView new];
    [self.contentView addSubview:self.completeImage];
    self.completeImage.image = [UIImage imageNamed:@"mamaTaskcompleteImage"];
    
    kWeakSelf
    [self.showImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.descLabel.mas_left).offset(-10);
        make.centerY.equalTo(weakSelf.contentView.mas_centerY);
    }];
    
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.contentView.mas_centerX);
        make.centerY.equalTo(weakSelf.contentView.mas_centerY);
    }];
    
    [self.completeImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.descLabel.mas_right).offset(10);
        make.centerY.equalTo(weakSelf.contentView.mas_centerY);
    }];
    
}


- (void)configModel:(JMNewcomerTaskModel *)model {

    self.descLabel.text = [NSString stringWithFormat:@"%@!",model.desc];
    
    if (model.complete) {
        self.showImage.image = [UIImage imageNamed:@"mamaNewcomer_selector"];
        self.completeImage.hidden = YES;
    }else {
        self.showImage.image = [UIImage imageNamed:@"mamaNewcomer_normal"];
        self.completeImage.hidden = NO;
    }
    
    
    
}


@end













































































































