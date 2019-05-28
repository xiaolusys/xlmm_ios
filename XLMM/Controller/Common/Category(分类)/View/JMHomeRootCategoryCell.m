//
//  JMHomeRootCategoryCell.m
//  XLMM
//
//  Created by zhang on 16/9/23.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMHomeRootCategoryCell.h"

@interface JMHomeRootCategoryCell ()

@property (nonatomic, strong) UILabel *nameLabel;


@end


@implementation JMHomeRootCategoryCell



- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self initUI];
        
    }
    return self;
}



- (void)initUI {
    self.nameLabel = [UILabel new];
    [self.contentView addSubview:self.nameLabel];
    self.nameLabel.textColor = [UIColor buttonTitleColor];
    self.nameLabel.highlightedTextColor = [UIColor buttonEnabledBackgroundColor];
    self.nameLabel.font = CS_UIFontSize(16.);
    
    
    
    UIView *lineView = [UIView new];
    [self.contentView addSubview:lineView];
    lineView.backgroundColor = [UIColor lineGrayColor];
    kWeakSelf
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.contentView.mas_centerX);
        make.centerY.equalTo(weakSelf.contentView.mas_centerY);
    }];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(weakSelf.contentView);
        make.height.mas_equalTo(@1);
    }];
    
}
- (void)setNameString:(NSString *)nameString {
    
    self.contentView.backgroundColor = [UIColor countLabelColor];
    UIView *aView = [[UIView alloc]initWithFrame:self.contentView.frame];
    aView.backgroundColor = [UIColor whiteColor];
    self.selectedBackgroundView = aView;
    
    _nameString = nameString;
    self.nameLabel.text = nameString;
    
}


- (void)configName:(NSString *)nameString Index:(NSInteger)index SelectedIndex:(NSInteger)selectedIndex {
    if (index == selectedIndex) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.nameLabel.textColor = [UIColor buttonEnabledBackgroundColor];
    }else {
        self.contentView.backgroundColor = [UIColor countLabelColor];
        self.nameLabel.textColor = [UIColor buttonTitleColor];
    }

    self.nameLabel.text = nameString;
    
    
}


@end







































































