//
//  JMGoodsAttributeCell.m
//  XLMM
//
//  Created by zhang on 16/8/8.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMGoodsAttributeCell.h"

NSString *const JMGoodsAttributeCellIdentifier = @"JMGoodsAttributeCellIdentifier";

@interface JMGoodsAttributeCell ()

@property (nonatomic, strong) UILabel *bianmaLabel;
@property (nonatomic, strong) UILabel *descBianmaLabel;

@end

@implementation JMGoodsAttributeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self initUI];
    }
    return self;
}


- (void)initUI {
    
    UILabel *bianmaLabel = [UILabel new];
    [self.contentView addSubview:bianmaLabel];
    bianmaLabel.textColor = [UIColor buttonTitleColor];
    bianmaLabel.font = [UIFont systemFontOfSize:14.];
    self.bianmaLabel = bianmaLabel;

    
    UILabel *descBianmaLabel = [UILabel new];
    [self.contentView addSubview:descBianmaLabel];
    descBianmaLabel.textColor = [UIColor dingfanxiangqingColor];
    descBianmaLabel.font = [UIFont systemFontOfSize:14.];
    descBianmaLabel.numberOfLines = 0;
    self.descBianmaLabel = descBianmaLabel;

    
    kWeakSelf
    

    
    [bianmaLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView).offset(10);
        make.top.equalTo(weakSelf.contentView).offset(10);
    }];

    
    [descBianmaLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bianmaLabel.mas_right).offset(10);
        make.width.mas_equalTo(@(SCREENWIDTH - 90));
        make.top.equalTo(bianmaLabel);
    }];

    
}
- (void)setDescModel:(JMDescLabelModel *)descModel {
    
    kWeakSelf
    if (descModel.name.length == 0) {
        [self.descBianmaLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.bianmaLabel);
            make.left.equalTo(weakSelf.contentView).offset(15);
            make.width.equalTo(@(SCREENWIDTH - 30));
        }];
    }else {
        self.bianmaLabel.text = descModel.name;
    }
    self.descBianmaLabel.text = descModel.value;
    

}

@end

















































































