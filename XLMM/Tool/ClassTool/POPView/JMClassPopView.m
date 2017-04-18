//
//  JMClassPopView.m
//  XLMM
//
//  Created by zhang on 16/9/24.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMClassPopView.h"
#import "JMSelecterButton.h"

#define ButtonWidth SCREENWIDTH * 0.6

@interface JMClassPopView ()

@property (nonatomic, strong) UIButton *cancelSelectedButton;

@property (nonatomic, strong) UIButton *sureSelectedButton;

@property (nonatomic, strong) UILabel *cancelTitleLabel;

@property (nonatomic, strong) UILabel *descTitleLabel;

@property (nonatomic, assign) BOOL isCancel;

@end

@implementation JMClassPopView

+ (instancetype)shareManager {
    static JMClassPopView *popView = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        popView = [[JMClassPopView alloc] init];
    });
    return popView;
    
}

- (void)setMessageTitle:(NSString *)messageTitle {
    _messageTitle = messageTitle;
    self.descTitleLabel.text = messageTitle;
    
}



- (instancetype)initWithFrame:(CGRect)frame Title:(NSString *)title DescTitle:(NSString *)descTitle Cancel:(NSString *)cancel Sure:(NSString *)sure {
    if (self == [super initWithFrame:frame]) {
        if (cancel == nil || [cancel isEqual:@""] || [cancel isKindOfClass:[NSNull class]]) {
            self.isCancel = YES;
        }else {
            self.isCancel = NO;
        }
        CGFloat infoStringH = [descTitle heightWithWidth:(ButtonWidth - 30) andFont:14.].height;
        CGFloat cornerR = ButtonWidth / 2;
        UIView *baseView = [UIView new];
        [self addSubview:baseView];
        baseView.backgroundColor = [UIColor whiteColor];
        baseView.layer.masksToBounds = YES;
        baseView.layer.cornerRadius = 10;
        
        UILabel *titleLabel = [UILabel new];
        [baseView addSubview:titleLabel];
        titleLabel.font = CS_UIFontBoldSize(18.);
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.numberOfLines = 0;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.text = title;
        
        UIView *descView = [UIView new];
        [baseView addSubview:descView];
        descView.backgroundColor = [UIColor whiteColor];

        UIView *lineView = [UIView new];
        [baseView addSubview:lineView];
        lineView.backgroundColor = [UIColor lineGrayColor];
        
        UILabel *descTitleLabel = [UILabel new];
        [descView addSubview:descTitleLabel];
        descTitleLabel.font = CS_UIFontSize(14.);
        descTitleLabel.textColor = [UIColor buttonTitleColor];
        descTitleLabel.numberOfLines = 0;
        descTitleLabel.text = descTitle;
        self.descTitleLabel = descTitleLabel;
        descTitleLabel.textAlignment = NSTextAlignmentCenter;
        
        UIView *buttonView = [UIView new];
        buttonView.backgroundColor = [UIColor clearColor];
        [baseView addSubview:buttonView];
        
        UIView *lineView2 = [UIView new];
        [buttonView addSubview:lineView2];
        lineView2.backgroundColor = [UIColor lineGrayColor];
        
        
        
        
        self.sureSelectedButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.sureSelectedButton.backgroundColor = [UIColor clearColor];
        [buttonView addSubview:self.sureSelectedButton];
        self.sureSelectedButton.tag = 101;
        [self.sureSelectedButton setTitle:@"确定" forState:UIControlStateNormal];
        [self.sureSelectedButton setTitleColor:[UIColor colorWithBlueColor] forState:UIControlStateNormal];
        self.sureSelectedButton.titleLabel.font = [UIFont systemFontOfSize:16.];
        [self.sureSelectedButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        if (self.isCancel) {
            lineView2.hidden = YES;
            self.sureSelectedButton.titleLabel.font = [UIFont systemFontOfSize:18.];
        }else {
            self.cancelSelectedButton = [UIButton buttonWithType:UIButtonTypeCustom];
            self.cancelSelectedButton.backgroundColor = [UIColor clearColor];
            [buttonView addSubview:self.cancelSelectedButton];
            self.cancelSelectedButton.tag = 100;
            [self.cancelSelectedButton setTitle:cancel forState:UIControlStateNormal];
            [self.cancelSelectedButton setTitleColor:[UIColor colorWithBlueColor] forState:UIControlStateNormal];
            self.cancelSelectedButton.titleLabel.font = [UIFont systemFontOfSize:16.];
            [self.cancelSelectedButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        }
        [baseView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.width.mas_equalTo(@(ButtonWidth));
            make.height.mas_equalTo(@(infoStringH + 110));
        }];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(baseView.mas_centerX);
            make.top.left.right.equalTo(baseView);
            make.height.mas_equalTo(@40);
        }];
        
        [descView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(titleLabel.mas_bottom);
            make.centerX.equalTo(baseView.mas_centerX);
            make.left.right.equalTo(baseView);
            make.height.mas_equalTo(@(infoStringH + 30));
        }];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(descView);
            make.height.mas_equalTo(@1);
        }];
    
        [descTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(descView).offset(5);
            make.centerX.equalTo(descView.mas_centerX);
            make.width.mas_equalTo(@(ButtonWidth - 30));
        }];
        
        [buttonView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(descView.mas_bottom);
            make.left.right.equalTo(baseView);
            make.height.mas_equalTo(@(40));
        }];
        [lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(buttonView.mas_centerX);
            make.top.equalTo(buttonView);
            make.width.mas_equalTo(@1);
            make.height.mas_equalTo(@40);
        }];
        
        if (self.isCancel) {
            [self.sureSelectedButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.top.equalTo(buttonView);
                make.width.mas_equalTo(@(ButtonWidth));
                make.height.mas_equalTo(@(40));
            }];
        }else {
            [self.cancelSelectedButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.top.equalTo(buttonView);
                make.width.mas_equalTo(@(cornerR));
                make.height.mas_equalTo(@(40));
            }];
            [self.sureSelectedButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.top.equalTo(buttonView);
                make.width.mas_equalTo(@(cornerR));
                make.height.mas_equalTo(@(40));
            }];
        }
    }
    
    
    return self;
}


- (void)btnClick:(UIButton *)button {
    if (self.block) {
        self.block(button.tag);
    }
}


@end





















































