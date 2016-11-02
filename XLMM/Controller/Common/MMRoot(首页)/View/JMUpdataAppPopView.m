//
//  JMUpdataAppPopView.m
//  XLMM
//
//  Created by zhang on 16/7/23.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMUpdataAppPopView.h"

@interface JMUpdataAppPopView ()

@property (nonatomic, strong) UIView *baseView;

@property (nonatomic, strong) UIButton *experienceButton;

@property (nonatomic, strong) UIButton *regretMissButton;

@property (nonatomic, strong) UILabel *firstLabel;

@property (nonatomic, strong) UITextView *textView;

@end

@implementation JMUpdataAppPopView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        [self createUI];
        
    }
    return self;
}

+ (instancetype)defaultUpdataPopView {
    return [[JMUpdataAppPopView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH *0.8 , (SCREENWIDTH * 0.8) * 1.2)];
}
- (void)setReleaseNotes:(NSString *)releaseNotes {
    self.textView.text = releaseNotes;
}
- (void)createUI {
    self.baseView = [UIView new];
    [self addSubview:self.baseView];
    self.baseView.backgroundColor = [UIColor whiteColor];
    self.baseView.alpha = 0.95;
    self.baseView.layer.cornerRadius = 20.;
    
    UIImageView *updataImage = [UIImageView new];
    [self.baseView addSubview:updataImage];
    updataImage.image = [UIImage imageNamed:@"appUpDataImage"];
    
    UILabel *firstLabel = [UILabel new];
    [self.baseView addSubview:firstLabel];
    firstLabel.font = [UIFont systemFontOfSize:16.];
    firstLabel.textColor = [UIColor buttonTitleColor];
    firstLabel.numberOfLines = 0;
    self.firstLabel = firstLabel;
    
    UITextView *textView = [UITextView new];
    [self.baseView addSubview:textView];
    self.textView = textView;
    self.textView.font = [UIFont systemFontOfSize:16.];
    self.textView.textColor = [UIColor buttonTitleColor];
    
//    
//    UILabel *secondLabel = [UILabel new];
//    [self.baseView addSubview:secondLabel];
//    secondLabel.font = [UIFont systemFontOfSize:16.];
//    secondLabel.textColor = [UIColor buttonTitleColor];
//    secondLabel.text = @"2 、订单物流查询更加便捷，";
//    secondLabel.numberOfLines = 0;
//    
//    UILabel *thirdLabel = [UILabel new];
//    [self.baseView addSubview:thirdLabel];
//    thirdLabel.font = [UIFont systemFontOfSize:16.];
//    thirdLabel.textColor = [UIColor buttonTitleColor];
//    thirdLabel.text = @"3 、其它功能的优化。";
//    thirdLabel.numberOfLines = 0;
//    
    self.regretMissButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.baseView addSubview:self.regretMissButton];
    [self.regretMissButton setTitle:@"遗憾错过" forState:UIControlStateNormal];
    self.regretMissButton.titleLabel.font = [UIFont systemFontOfSize:16.];
    [self.regretMissButton setTitleColor:[UIColor buttonTitleColor] forState:UIControlStateNormal];
    self.regretMissButton.tag = 100;
    [self.regretMissButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.experienceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.baseView addSubview:self.experienceButton];
    [self.experienceButton setTitle:@"立即体验" forState:UIControlStateNormal];
    self.experienceButton.titleLabel.font = [UIFont systemFontOfSize:16.];
    [self.experienceButton setTitleColor:[UIColor buttonEnabledBackgroundColor] forState:UIControlStateNormal];
    self.experienceButton.tag = 101;
    [self.experienceButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];

    
    UIView *currentView = [UIView new];
    [self.baseView addSubview:currentView];
    currentView.backgroundColor = [UIColor lineGrayColor];
    
    UIView *verticalCurrentView = [UIView new];
    [self.baseView addSubview:verticalCurrentView];
    verticalCurrentView.backgroundColor = [UIColor lineGrayColor];
    
    kWeakSelf
    
    CGFloat buttonW = weakSelf.frame.size.width;
    
    [self.baseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(@(SCREENWIDTH * 0.8));
        make.height.mas_equalTo(@((SCREENWIDTH * 0.8)*1.2));
        make.centerX.equalTo(weakSelf.mas_centerX);
        make.centerY.equalTo(weakSelf.mas_centerY);
    }];
    
    [updataImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.baseView).offset(-65);
        make.centerX.equalTo(weakSelf.baseView.mas_centerX);
    }];
    
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.baseView).offset(20);
        make.top.equalTo(updataImage.mas_bottom).offset(5);
        make.right.equalTo(weakSelf.baseView).offset(-20);
        make.bottom.equalTo(currentView);
    }];
    
//    [secondLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(weakSelf.baseView).offset(20);
//        make.top.equalTo(firstLabel.mas_bottom).offset(5);
//        make.right.equalTo(weakSelf.baseView).offset(-20);
//    }];
//    
//    [thirdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(weakSelf.baseView).offset(20);
//        make.top.equalTo(secondLabel.mas_bottom).offset(5);
//        make.right.equalTo(weakSelf.baseView).offset(-20);
//    }];
    
    [currentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf.baseView);
        make.bottom.equalTo(weakSelf.baseView).offset(-50);
        make.height.mas_equalTo(@1);
    }];
    
    [verticalCurrentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(currentView);
        make.bottom.equalTo(weakSelf.baseView);
        make.width.mas_equalTo(@1);
        make.centerX.equalTo(weakSelf.baseView.mas_centerX);
    }];
    
    [self.regretMissButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(weakSelf.baseView);
        make.width.mas_equalTo(@(buttonW/2));
        make.height.mas_equalTo(@50);
    }];
    
    [self.experienceButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(weakSelf.baseView);
        make.width.mas_equalTo(@(buttonW/2));
        make.height.mas_equalTo(@50);
    }];
    
    
    
    
    
}

- (void)btnClick:(UIButton *)button {
    if (_delegate && [_delegate respondsToSelector:@selector(composeUpdataAppButton:didClick:)]) {
        [_delegate composeUpdataAppButton:self didClick:button.tag];
    }
}


@end









































































































































































