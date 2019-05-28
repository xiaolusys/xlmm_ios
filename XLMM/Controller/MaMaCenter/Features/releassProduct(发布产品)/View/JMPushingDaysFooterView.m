//
//  JMPushingDaysFooterView.m
//  XLMM
//
//  Created by zhang on 17/3/10.
//  Copyright © 2017年 上海己美. All rights reserved.
//

#import "JMPushingDaysFooterView.h"
#import "JMSharePicModel.h"

@interface JMPushingDaysFooterView ()

@property (nonatomic, strong) UIButton *savePhotoBtn;
@property (nonatomic, strong) UIButton *saveWenanBtn;
@property (nonatomic, strong) UIButton *likeButton;
@property (nonatomic, strong) UIButton *shareButton;


@end

@implementation JMPushingDaysFooterView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {

        self.likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.likeButton setImage:[UIImage imageNamed:@"pushingDays_saveImage"] forState:UIControlStateNormal];
        [self.likeButton setTitleColor:[UIColor dingfanxiangqingColor] forState:UIControlStateNormal];
        self.likeButton.titleLabel.font = CS_UIFontSize(12.);
        self.likeButton.enabled = NO;
        self.likeButton.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
        
        self.shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.shareButton setImage:[UIImage imageNamed:@"pushingDays_shareImage"] forState:UIControlStateNormal];
        [self.shareButton setTitleColor:[UIColor dingfanxiangqingColor] forState:UIControlStateNormal];
        self.shareButton.titleLabel.font = CS_UIFontSize(12.);
        self.shareButton.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
        self.shareButton.enabled = NO;
        
        
        self.savePhotoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.savePhotoBtn.layer.borderColor = [UIColor buttonEmptyBorderColor].CGColor;
        self.savePhotoBtn.layer.borderWidth = 1.0;
        self.savePhotoBtn.layer.cornerRadius = 15;
        [self.savePhotoBtn setTitle:@"立即分享" forState:UIControlStateNormal];
        [self.savePhotoBtn setTitleColor:[UIColor buttonEmptyBorderColor] forState:UIControlStateNormal];
        self.savePhotoBtn.titleLabel.font = [UIFont systemFontOfSize:14.];
        self.savePhotoBtn.tag = 100;
        
        self.saveWenanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.saveWenanBtn.layer.borderColor = [UIColor buttonEmptyBorderColor].CGColor;
        self.saveWenanBtn.layer.borderWidth = 1.0;
        self.saveWenanBtn.layer.cornerRadius = 15;
        [self.saveWenanBtn setTitle:@"复制文案" forState:UIControlStateNormal];
        [self.saveWenanBtn setTitleColor:[UIColor buttonEmptyBorderColor] forState:UIControlStateNormal];
        self.saveWenanBtn.titleLabel.font = [UIFont systemFontOfSize:14.];
        self.saveWenanBtn.tag = 101;
        
        [self.savePhotoBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.saveWenanBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.savePhotoBtn];
        [self addSubview:self.likeButton];
        [self addSubview:self.shareButton];
        [self addSubview:self.saveWenanBtn];
        
        UIView *lineView = [UIView new];
        lineView.backgroundColor = [UIColor lineGrayColor];
        [self addSubview:lineView];
        
        kWeakSelf
        [self.likeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(weakSelf.shareButton.mas_left);
            make.top.equalTo(weakSelf);
            make.width.mas_equalTo(@(70));
            make.height.mas_equalTo(@(30));
        }];
        [self.shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(weakSelf);
            make.top.equalTo(weakSelf);
            make.width.mas_equalTo(@(70));
            make.height.mas_equalTo(@(30));
        }];
        [self.savePhotoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf).offset(15);
            make.bottom.equalTo(weakSelf).offset(-10);
            make.width.mas_equalTo(@(SCREENWIDTH / 2 - 30));
            make.height.mas_equalTo(@(30));
        }];
        [self.saveWenanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(weakSelf).offset(-15);
            make.bottom.equalTo(weakSelf).offset(-10);
            make.width.mas_equalTo(@(SCREENWIDTH / 2 - 30));
            make.height.mas_equalTo(@(30));
        }];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(weakSelf).offset(-1);
            make.right.equalTo(weakSelf);
            make.width.mas_equalTo(@(SCREENWIDTH));
            make.height.mas_equalTo(@(1));
        }];
    }
    return self;
}

- (void)setModel:(JMSharePicModel *)model {
    _model = model;
    [self.likeButton setTitle:model.save_times forState:UIControlStateNormal];
    [self.shareButton setTitle:model.save_times forState:UIControlStateNormal];
}
- (void)buttonClick:(UIButton *)button {
    if (_delegate && [_delegate respondsToSelector:@selector(composeWithShareModel:Button:)]) {
        [_delegate composeWithShareModel:self.model Button:button];
    }
}




@end



























