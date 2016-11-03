//
//  JMToolTimeLineView.m
//  XLMM
//
//  Created by zhang on 16/9/20.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMToolTimeLineView.h"

@interface JMToolTimeLineView () {
    NSArray *imageNomal;
    NSArray *imageSelected;
}

@property (nonatomic, strong) UIView *progressView;
@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) UIView *descTitleView;


@end

@implementation JMToolTimeLineView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}

- (id)initWithTimeArray:(NSArray *)time andTimeDesArray:(NSArray *)timeDes ImageArray:(NSArray *)imageArr andCurrentStatus:(NSInteger)status andFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        imageNomal = imageArr[0];
        imageSelected = imageArr[1];
        
        self.progressView = [UIView new];
        self.titleView = [UIView new];
        self.descTitleView = [UIView new];
        [self addSubview:self.progressView];
        [self addSubview:self.titleView];
        [self addSubview:self.descTitleView];
        
        
        [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(self);
            make.width.mas_equalTo(frame.size.width);
            make.height.mas_equalTo(@30);
        }];
        
        [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.top.equalTo(self.progressView.mas_bottom);
            make.width.mas_equalTo(frame.size.width);
            make.height.mas_equalTo(@30);
        }];
        [self.descTitleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.top.equalTo(self.titleView.mas_bottom);
            make.width.mas_equalTo(frame.size.width);
            make.height.mas_equalTo(@30);
        }];
        
        
        
        [self createDescTitle:timeDes TitleArr:time Status:status];
        
        
        
    }
    return self;
    
}

- (void)createDescTitle:(NSArray *)descTitleArr TitleArr:(NSArray *)titleArr Status:(NSInteger)status {
    NSInteger countNum = descTitleArr.count;
    CGFloat toolWidth = SCREENWIDTH / countNum;
    for (int i = 0; i < countNum; i++) {
        UIView *baseView = [UIView new];
        [self.progressView addSubview:baseView];
        [baseView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.progressView);
            make.left.equalTo(self.progressView).offset(i * toolWidth);
            make.width.mas_equalTo(toolWidth);
            make.height.mas_equalTo(@30);
        }];
        
        UIView *baseView1 = [UIView new];
        [self.titleView addSubview:baseView1];
        [baseView1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleView);
            make.left.equalTo(self.titleView).offset(i * toolWidth);
            make.width.mas_equalTo(toolWidth);
            make.height.mas_equalTo(@30);
        }];
        
        UIView *baseView2 = [UIView new];
        [self.descTitleView addSubview:baseView2];
        [baseView2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.descTitleView);
            make.left.equalTo(self.descTitleView).offset(i * toolWidth);
            make.width.mas_equalTo(toolWidth);
            make.height.mas_equalTo(@30);
        }];
        UIImageView *iconImage = [UIImageView new];
        [baseView addSubview:iconImage];
        iconImage.image = i < status ? [UIImage imageNamed:imageSelected[i]] : [UIImage imageNamed:imageNomal[i]];
        
        UILabel *titleLabel = [UILabel new];
        [baseView1 addSubview:titleLabel];
        titleLabel.font = [UIFont systemFontOfSize:13.];
        titleLabel.text = titleArr[i];
        titleLabel.textColor = i < status ? [UIColor buttonEnabledBackgroundColor] : [UIColor dingfanxiangqingColor];
        
        UILabel *descTitleLabel = [UILabel new];
        [baseView2 addSubview:descTitleLabel];
        descTitleLabel.font = [UIFont systemFontOfSize:13.];
        descTitleLabel.text = descTitleArr[i];
        descTitleLabel.textColor = i < status ? [UIColor buttonEnabledBackgroundColor] : [UIColor dingfanxiangqingColor];
        
        
        
        if (i == 0) {
            [iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(baseView.mas_centerY);
                make.left.equalTo(baseView).offset(30);
                make.width.height.mas_equalTo(@30);
            }];
            [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(baseView1.mas_centerY);
                make.left.equalTo(baseView1).offset(15);
            }];
            [descTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(baseView2.mas_centerY);
                make.left.equalTo(baseView2).offset(15);
            }];
        }else if (i == (countNum - 1)) {
            [iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(baseView.mas_centerY);
                make.right.equalTo(baseView).offset(-30);
                make.width.height.mas_equalTo(@30);
            }];
            [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(baseView1.mas_centerY);
                make.right.equalTo(baseView1).offset(-15);
            }];
            [descTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(baseView2.mas_centerY);
                make.right.equalTo(baseView2).offset(-15);
            }];
        }else {
            [iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(baseView);
                make.width.height.mas_equalTo(@30);
            }];
            [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(baseView1);
            }];
            [descTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(baseView2);
            }];
            
        }
        UILabel *lineLabel = [UILabel new];
        [iconImage addSubview:lineLabel];
        lineLabel.backgroundColor = i < (status - 1) ? [UIColor buttonEnabledBackgroundColor] : [UIColor titleDarkGrayColor];
        if (i == (countNum - 1)) {
            lineLabel.hidden = YES;
        }
        CGFloat lineW = (SCREENWIDTH - 60 - countNum * 20) / (countNum - 1);
        [lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(iconImage.mas_centerY);
            make.left.equalTo(iconImage.mas_right);
            make.width.mas_equalTo(lineW);
            make.height.mas_equalTo(@2);
        }];
        
  
        
        
    }
    
    
    
    
    
}





















@end































































































