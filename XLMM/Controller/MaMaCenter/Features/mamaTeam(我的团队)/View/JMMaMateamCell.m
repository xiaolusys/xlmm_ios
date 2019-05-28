//
//  JMMaMateamCell.m
//  XLMM
//
//  Created by zhang on 16/7/27.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMMaMateamCell.h"
#import "JMMaMaSelfTeamModel.h"


@interface JMMaMateamCell ()

@property (nonatomic, strong) UILabel *earningsLabel;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UILabel *numLabel;


@end

@implementation JMMaMateamCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    
    UIView *lineView = [UIView new];
    [self.contentView addSubview:lineView];
    lineView.backgroundColor = [UIColor countLabelColor];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.right.equalTo(self.contentView).offset(-15);
        make.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(@1);
    }];
    
    NSInteger count = 3;
    for (int i = 0; i < count; i++) {
        UILabel *label = [UILabel new];
        label.tag = 100 + i;
        if (i == 0) {
            label.font = [UIFont systemFontOfSize:12.];
        }else {
            label.font = [UIFont systemFontOfSize:14.];
        }
        
        label.textAlignment = NSTextAlignmentCenter;
        if (i == 2) {
            label.textColor = [UIColor buttonEnabledBackgroundColor];
        }else {
            label.textColor = [UIColor buttonTitleColor];
        }
        [self.contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(@(SCREENWIDTH / 3));
            make.height.mas_equalTo(@60);
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.centerX.equalTo(self.contentView.mas_right).multipliedBy(((CGFloat)i + 0.5) / ((CGFloat)count + 0));
        }];
    }
    self.nameLabel = (UILabel *)[self.contentView viewWithTag:100];
    self.numLabel = (UILabel *)[self.contentView viewWithTag:101];
    self.earningsLabel = (UILabel *)[self.contentView viewWithTag:102];


}

- (void)config:(JMMaMaSelfTeamModel *)model {
    self.nameLabel.text = model.mama_nick;
    self.numLabel.text = [NSString stringWithFormat:@"%@件",model.num];
    CGFloat total = [model.total floatValue] / 100.00;
    self.earningsLabel.text = [NSString stringWithFormat:@"%.2f",total];
    
}




@end



























