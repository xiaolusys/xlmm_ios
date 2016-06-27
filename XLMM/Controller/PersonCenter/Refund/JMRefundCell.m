//
//  JMRefundCell.m
//  XLMM
//
//  Created by zhang on 16/6/15.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMRefundCell.h"
#import "Masonry.h"
#import "MMClass.h"
#import "UIColor+RGBColor.h"

@interface JMRefundCell ()

@property (nonatomic,strong) UILabel *nameLabel;

@property (nonatomic,strong) UILabel *decLabel;



@end

@implementation JMRefundCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
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
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView).offset(10);
        make.centerY.equalTo(weakSelf.contentView.mas_centerY);
    }];
    
    [self.decLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.nameLabel.mas_right).offset(10);
        make.centerY.equalTo(weakSelf.contentView.mas_centerY);
//        make.top.equalTo(weakSelf.contentView).offset(10);
        make.right.equalTo(weakSelf.contentView).offset(-10);
    }];
    
    
    
}
- (void)configWithModel:(JMAppForRefundModel *)model {
    
    self.nameLabel.text = model.name;
    self.decLabel.text = model.desc;
    
}

@end






















