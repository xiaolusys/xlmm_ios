//
//  JMPurchaseFooterView.m
//  XLMM
//
//  Created by zhang on 16/7/21.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMPurchaseFooterView.h"
#import "JMRichTextTool.h"

@interface JMPurchaseFooterView ()

@property (nonatomic, strong) UIButton *xiaoluCoinButton;

@end

@implementation JMPurchaseFooterView

- (void)setIsShowXiaoluCoinView:(BOOL)isShowXiaoluCoinView {
    _isShowXiaoluCoinView = isShowXiaoluCoinView;
    if (!_isShowXiaoluCoinView) {
        self.mj_h = 385;
        [self.xiaoluCoinButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(@0);
        }];
        self.xiaoluCoinButton.hidden = YES;
        self.xiaoluCoinLabel.hidden = YES;
    }
    
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUpFootUI];
    }
    return self;
}
- (void)setUpFootUI {
    // == 第一个分割线 == //
    UIView *currentOneView = [UIView new];
    [self addSubview:currentOneView];
    currentOneView.backgroundColor = [UIColor lineGrayColor];
    
    UIButton *couponeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:couponeButton];
    couponeButton.tag = 100;
//    couponeButton.layer.borderColor = [UIColor lineGrayColor].CGColor;
//    couponeButton.layer.borderWidth = 1.f;

    [couponeButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *couponL = [UILabel new];
    [couponeButton addSubview:couponL];
    couponL.font = [UIFont systemFontOfSize:14.];
    couponL.text = @"优惠券";
    couponL.textColor = [UIColor buttonTitleColor];
    
    UILabel *couponLabel = [UILabel new];
    [couponeButton addSubview:couponLabel];
    couponLabel.font = [UIFont systemFontOfSize:13.];
//    couponLabel.textColor = [UIColor dingfanxiangqingColor];
    couponLabel.text = @"没有使用优惠券";
    self.couponLabel = couponLabel;
    
    UIImageView *rightImage = [UIImageView new];
    rightImage.image = [UIImage imageNamed:@"rightArrow"];
    [couponeButton addSubview:rightImage];
    
//    NSArray *arr = @[@"零钱",@"小鹿币"];
    
    UIButton *walletButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:walletButton];
    walletButton.layer.borderColor = [UIColor lineGrayColor].CGColor;
    walletButton.layer.borderWidth = 0.5f;
    [walletButton setTitle:@"零钱" forState:UIControlStateNormal];
    walletButton.titleLabel.font = [UIFont systemFontOfSize:14.];
    [walletButton setTitleColor:[UIColor buttonTitleColor] forState:UIControlStateNormal];
    [walletButton setImage:[UIImage imageNamed:@"circle_wallet_Normal"] forState:UIControlStateNormal];
    [walletButton setImage:[UIImage imageNamed:@"circle_wallet_Selected"] forState:UIControlStateSelected];
    walletButton.titleEdgeInsets = UIEdgeInsetsMake(0, -SCREENWIDTH + 40, 0, 0);
    walletButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -SCREENWIDTH + 10);
    walletButton.tag = 101;
    [walletButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];

    UILabel *walletLabel = [UILabel new];
    [walletButton addSubview:walletLabel];
    walletLabel.font = [UIFont systemFontOfSize:14.];
    walletLabel.textColor = [UIColor buttonTitleColor];
    self.walletLabel = walletLabel;
    
    UIButton *xiaoluCoinButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:xiaoluCoinButton];
    xiaoluCoinButton.layer.borderColor = [UIColor lineGrayColor].CGColor;
    xiaoluCoinButton.layer.borderWidth = 0.5f;
    [xiaoluCoinButton setTitle:@"小鹿币" forState:UIControlStateNormal];
    xiaoluCoinButton.titleLabel.font = [UIFont systemFontOfSize:14.];
    [xiaoluCoinButton setTitleColor:[UIColor buttonTitleColor] forState:UIControlStateNormal];
    [xiaoluCoinButton setImage:[UIImage imageNamed:@"circle_wallet_Normal"] forState:UIControlStateNormal];
    [xiaoluCoinButton setImage:[UIImage imageNamed:@"circle_wallet_Selected"] forState:UIControlStateSelected];
    xiaoluCoinButton.titleEdgeInsets = UIEdgeInsetsMake(0, -SCREENWIDTH + 58, 0, 0);
    xiaoluCoinButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -SCREENWIDTH - 6);
    xiaoluCoinButton.tag = 102;
    [xiaoluCoinButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.xiaoluCoinButton = xiaoluCoinButton;
    
    UILabel *xiaoluCoinLabel = [UILabel new];
    [xiaoluCoinButton addSubview:xiaoluCoinLabel];
    xiaoluCoinLabel.font = [UIFont systemFontOfSize:14.];
    xiaoluCoinLabel.textColor = [UIColor buttonTitleColor];
    self.xiaoluCoinLabel = xiaoluCoinLabel;
    
    

    UIView *appPayView = [UIView new];
    [self addSubview:appPayView];
    
    UILabel *appPayL = [UILabel new];
    [appPayView addSubview:appPayL];
    appPayL.font = [UIFont systemFontOfSize:14.];
    appPayL.text = @"APP支付优惠";
    appPayL.textColor = [UIColor buttonTitleColor];
    
    UILabel *appPayLabel = [UILabel new];
    [appPayView addSubview:appPayLabel];
    appPayLabel.font = [UIFont systemFontOfSize:14.];
    appPayLabel.textColor = [UIColor buttonTitleColor];
    self.appPayLabel = appPayLabel;
    
    // == 第二个分割线 == //
    UIView *currentTwoView = [UIView new];
    [self addSubview:currentTwoView];
    currentTwoView.backgroundColor = [UIColor lineGrayColor];
    
    
    UIView *termsView = [UIView new];
    [self addSubview:termsView];
    
    UIButton *termsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [termsView addSubview:termsButton];
    [termsButton setImage:[UIImage imageNamed:@"right_button"] forState:UIControlStateNormal];
    [termsButton setImage:[UIImage imageNamed:@"termsImage"] forState:UIControlStateSelected];
//    termsButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -SCREENWIDTH + 40);
    termsButton.tag = 103;
    [termsButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.termsButton = termsButton;
    
    UILabel *termsLabel = [UILabel new];
    [termsView addSubview:termsLabel];
    termsLabel.font = [UIFont systemFontOfSize:13.];
    NSString *termStr = @"我已阅读并同意小鹿美美购买条款";
    termsLabel.attributedText = [JMRichTextTool cs_changeColorWithColor:[UIColor buttonEnabledBackgroundColor] AllString:termStr SubStringArray:@[@"小鹿美美购买条款"]];
    termsLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *termsTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(termsTapClick:)];
    [termsLabel addGestureRecognizer:termsTap];

    // == 第三个分割线 == //
    UIView *goodsMoneyView = [UIView new];
    [self addSubview:goodsMoneyView];
    goodsMoneyView.backgroundColor = [UIColor countLabelColor];
    
    UILabel *goodsL = [UILabel new];
    [goodsMoneyView addSubview:goodsL];
    goodsL.font = [UIFont systemFontOfSize:14.];
    goodsL.textColor = [UIColor buttonTitleColor];
    goodsL.text = @"商品金额";
    UILabel *postL = [UILabel new];
    [goodsMoneyView addSubview:postL];
    postL.font = [UIFont systemFontOfSize:14.];
    postL.textColor = [UIColor buttonTitleColor];
    postL.text = @"运费";
    UILabel *goodsLabel = [UILabel new];
    [goodsMoneyView addSubview:goodsLabel];
    goodsLabel.font = [UIFont systemFontOfSize:14.];
    goodsLabel.textColor = [UIColor buttonEnabledBackgroundColor];
    self.goodsLabel = goodsLabel;
    
    UILabel *postLabel = [UILabel new];
    [goodsMoneyView addSubview:postLabel];
    postLabel.font = [UIFont systemFontOfSize:14.];
    postLabel.textColor = [UIColor buttonTitleColor];
    self.postLabel = postLabel;
    
    UIView *bottomView = [UIView new];
    [self addSubview:bottomView];

    UILabel *paymenLabel = [UILabel new];
    [bottomView addSubview:paymenLabel];
    paymenLabel.font = [UIFont systemFontOfSize:13.];
    paymenLabel.textColor = [UIColor buttonTitleColor];
    self.paymenLabel = paymenLabel;
    
    UIButton *goPayButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [bottomView addSubview:goPayButton];
    goPayButton.backgroundColor = [UIColor buttonEnabledBackgroundColor];
    [goPayButton setTitle:@"去结算" forState:UIControlStateNormal];
    goPayButton.layer.cornerRadius = 20;
    goPayButton.tag = 104;

    [goPayButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.goPayButton = goPayButton;
    
    kWeakSelf
    
    [currentOneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(weakSelf);
        make.height.mas_equalTo(@15);
    }];

    [couponeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(currentOneView.mas_bottom);
        make.left.right.equalTo(weakSelf);
        make.height.mas_equalTo(@45);
    }];
    [couponL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(couponeButton).offset(15);
        make.centerY.equalTo(couponeButton.mas_centerY);
    }];
    [couponLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(couponeButton).offset(-35);
        make.centerY.equalTo(couponeButton.mas_centerY);
    }];
    [rightImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(couponeButton).offset(-15);
        make.centerY.equalTo(couponeButton.mas_centerY);
        make.height.mas_equalTo(@25);
        make.width.mas_equalTo(@16);
    }];
    
    
    [walletButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(couponeButton.mas_bottom);
        make.left.right.equalTo(weakSelf);
        make.height.mas_equalTo(@45);
    }];

    [walletLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(walletButton).offset(-35);
        make.centerY.equalTo(walletButton.mas_centerY);
    }];
    
    [xiaoluCoinButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(walletButton.mas_bottom);
        make.left.right.equalTo(weakSelf);
        make.height.mas_equalTo(@45);
    }];
    
    [xiaoluCoinLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(xiaoluCoinButton).offset(-35);
        make.centerY.equalTo(xiaoluCoinButton.mas_centerY);
    }];
    
    
    
    [appPayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(xiaoluCoinButton.mas_bottom);
        make.left.right.equalTo(weakSelf);
        make.height.mas_equalTo(@45);
    }];
    [appPayL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(appPayView).offset(15);
        make.centerY.equalTo(appPayView.mas_centerY);
    }];
    [appPayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(appPayView).offset(-15);
        make.centerY.equalTo(appPayView.mas_centerY);
    }];
    
    [currentTwoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(appPayView.mas_bottom);
        make.left.right.equalTo(weakSelf);
        make.height.mas_equalTo(@15);
    }];
    
    [termsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(currentTwoView.mas_bottom);
        make.left.right.equalTo(weakSelf);
        make.height.mas_equalTo(@45);
    }];
    [termsButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(termsView);
        make.width.height.mas_equalTo(@45);
        make.centerY.equalTo(termsView.mas_centerY);
    }];
    [termsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(termsView).offset(15);
        make.centerY.equalTo(termsButton.mas_centerY);
    }];
    
    [goodsMoneyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(termsButton.mas_bottom);
        make.left.right.equalTo(weakSelf);
        make.height.mas_equalTo(@80);
    }];
    [goodsL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(goodsMoneyView).offset(15);
        make.top.equalTo(goodsMoneyView).offset(20);
    }];
    [postL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(goodsMoneyView).offset(15);
        make.top.equalTo(goodsL.mas_bottom).offset(15);
    }];
    [goodsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(goodsMoneyView).offset(-15);
        make.centerY.equalTo(goodsL.mas_centerY);
    }];
    [postLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(goodsMoneyView).offset(-15);
        make.centerY.equalTo(postL.mas_centerY);
    }];
    
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf);
        make.top.equalTo(goodsMoneyView.mas_bottom);
        make.height.mas_equalTo(@90);
    }];

    [paymenLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bottomView).offset(10);
        make.centerX.equalTo(bottomView.mas_centerX);
    }];
    [goPayButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(bottomView).offset(-10);
        make.centerX.equalTo(bottomView.mas_centerX);
        make.width.mas_equalTo(@(SCREENWIDTH - 30));
        make.height.mas_equalTo(@40);
    }];

}
//- (void)changeButtonStatus:(UIButton *)button {
//    NSLog(@"button ======= 222222222222");
//    button.userInteractionEnabled = YES;
//}
- (void)buttonClick:(UIButton *)button {
//    button.userInteractionEnabled = NO;
    if (_delegate && [_delegate respondsToSelector:@selector(composeFooterButtonView:UIButton:)]) {
        [_delegate composeFooterButtonView:self UIButton:button];
    }
//    [self performSelector:@selector(changeButtonStatus:) withObject:button afterDelay:0.3f];//防止重复点击
}
- (void)termsTapClick:(UITapGestureRecognizer *)tap {
    if (_delegate && [_delegate respondsToSelector:@selector(composeFooterTapView:)]) {
        [_delegate composeFooterTapView:self];
    }
}
@end

































































