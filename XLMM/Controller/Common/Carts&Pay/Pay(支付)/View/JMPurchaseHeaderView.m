//
//  JMPurchaseHeaderView.m
//  XLMM
//
//  Created by zhang on 16/7/21.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMPurchaseHeaderView.h"
#import "JMAddressModel.h"


@interface JMPurchaseHeaderView ()

/**
 *  地址_姓名
 */
@property (nonatomic, strong) UILabel *addressNameLabel;
/**
 *  地址_手机号
 */
@property (nonatomic, strong) UILabel *addressPhoneLabel;
/**
 *  地址_详细地址
 */
@property (nonatomic, strong) UILabel *addressDetailLabel;
/// 地址信息提示
@property (nonatomic, strong) UIView *promptView;
@property (nonatomic, strong) UILabel *promptLabel;

@property (nonatomic, strong) UILabel *nomalLabel;

@end

@implementation JMPurchaseHeaderView

- (void)setAddressArr:(NSArray *)addressArr {
    _addressArr = addressArr;
    if ((addressArr == nil) || (addressArr.count == 0)) {
        self.addressNameLabel.text = @"";
        self.addressPhoneLabel.text = @"";
        self.addressDetailLabel.text = @"";
        self.nomalLabel.hidden = NO;
        self.nomalLabel.text = @"请填写收货地址";
    }else {
        NSDictionary *addressDic = addressArr[0];
        self.nomalLabel.hidden = YES;
        self.addressNameLabel.text = addressDic[@"receiver_name"];
        self.addressPhoneLabel.text = addressDic[@"receiver_phone"];
        self.addressDetailLabel.text = [NSString stringWithFormat:@"%@%@%@%@",addressDic[@"receiver_state"],addressDic[@"receiver_city"],addressDic[@"receiver_district"],addressDic[@"receiver_address"]];
        
    }
}
- (void)setAddressModel:(JMAddressModel *)addressModel {
    _addressModel = addressModel;
    self.nomalLabel.hidden = YES;
    self.addressNameLabel.text = addressModel.receiver_name;
    self.addressPhoneLabel.text = addressModel.receiver_mobile;
    self.addressDetailLabel.text = [NSString stringWithFormat:@"%@%@%@%@",addressModel.receiver_state,addressModel.receiver_city,addressModel.receiver_district,addressModel.receiver_address];
}
- (void)setIsVirtualCoupone:(BOOL)isVirtualCoupone {
    _isVirtualCoupone = isVirtualCoupone;
    if (isVirtualCoupone) {
        if (self.addressView) {
            [self.addressView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(@0);
            }];
            [self.addressView removeFromSuperview];
            self.addressView = nil;
        }
    }
}
- (void)setCartsInfoLevel:(NSInteger)cartsInfoLevel {
    _cartsInfoLevel = cartsInfoLevel;
    if (cartsInfoLevel > 1) {
        self.promptLabel.text = @"温馨提示：保税区和直邮发货根据海关要求需要提供身份证号码，为了避免清关失败，提供的身份证必须和收货人一致。";
        CGFloat promptLabelHeight = [self promptInfoStrHeight:self.promptLabel.text];
        [self.promptView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(@(promptLabelHeight));
        }];
        [self.promptLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(@(promptLabelHeight - 10));
        }];
    }else {

    }
    
}
- (CGFloat)promptInfoStrHeight:(NSString *)string {
    CGFloat contentW = [UIScreen mainScreen].bounds.size.width - 10;
    CGFloat contentH = [string boundingRectWithSize:CGSizeMake(contentW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.]} context:nil].size.height;
    return contentH + 20;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUpTopUI];
    }
    return self;
}
- (void)setUpTopUI {
    
    // == 地址信息视图 == //
    UIView *addressView = [UIView new];
    [self addSubview:addressView];
    self.addressView = addressView;
    self.addressView.backgroundColor = [UIColor whiteColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
    [self.addressView addGestureRecognizer:tap];
    UIView *threeTapView = [tap view];
    threeTapView.tag = 100;
    
    UIImageView *addressImage = [UIImageView new];
    [self.addressView addSubview:addressImage];
    addressImage.image = [UIImage imageNamed:@"address_icon"];
    
    UILabel *addressNameLabel = [UILabel new];
    [self.addressView addSubview:addressNameLabel];
    self.addressNameLabel = addressNameLabel;
    self.addressNameLabel.font = [UIFont systemFontOfSize:13.];
    self.addressNameLabel.textColor = [UIColor buttonTitleColor];
    
    UILabel *addressPhoneLabel = [UILabel new];
    [self.addressView addSubview:addressPhoneLabel];
    self.addressPhoneLabel = addressPhoneLabel;
    self.addressPhoneLabel.font = [UIFont systemFontOfSize:12.];
    self.addressPhoneLabel.textColor = [UIColor dingfanxiangqingColor];
    
    UILabel *addressDetailLabel = [UILabel new];
    [self.addressView addSubview:addressDetailLabel];
    self.addressDetailLabel = addressDetailLabel;
    self.addressDetailLabel.font = [UIFont systemFontOfSize:12.];
    self.addressDetailLabel.textColor = [UIColor dingfanxiangqingColor];
    self.addressDetailLabel.numberOfLines = 0;
    
    UIView *promptView = [UIView new];
    promptView.backgroundColor = [UIColor sectionViewColor];
    [self addSubview:promptView];
    self.promptView = promptView;
    
    UILabel *promptLabel = [UILabel new];
    [promptView addSubview:promptLabel];
    promptLabel = promptLabel;
    promptLabel.font = [UIFont systemFontOfSize:12.];
    promptLabel.textColor = [UIColor redColor];
    promptLabel.numberOfLines = 0;
//    self.promptLabel.textAlignment = NSTextAlignmentCenter;
    self.promptLabel = promptLabel;
    
    UIView *lineView = [UIView new];
    [self addSubview:lineView];
    lineView.backgroundColor = [UIColor lineGrayColor];
    
    
    // == 物流信息视图 == //
    UIView *fourView = [UIView new];
    [self addSubview:fourView];
    self.logisticsView = fourView;
    self.logisticsView.backgroundColor = [UIColor whiteColor];
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
    [self.logisticsView addGestureRecognizer:tap1];
    UIView *fourTapView = [tap1 view];
    fourTapView.tag = 101;
    
    UILabel *logistics = [UILabel new];
    [fourView addSubview:logistics];
    logistics.font = [UIFont systemFontOfSize:13.];
    logistics.textColor = [UIColor buttonTitleColor];
    logistics.text = @"物流配送";
    
    UIImageView *logisticeImage = [UIImageView new];
    [fourView addSubview:logisticeImage];
    logisticeImage.image = [UIImage imageNamed:@"rightArrow"];
    
    UILabel *logisticsLabel = [UILabel new];
    [fourView addSubview:logisticsLabel];
    self.logisticsLabel = logisticsLabel;
    self.logisticsLabel.font = [UIFont systemFontOfSize:13.];
    self.logisticsLabel.textColor = [UIColor buttonTitleColor];
    self.logisticsLabel.text = @"小鹿推荐";
    
    kWeakSelf
    // == 地址信息视图 == //
    [self.addressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(weakSelf);
        make.height.mas_equalTo(@90);
    }];
    [addressImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.addressView).offset(10);
        make.centerY.equalTo(weakSelf.addressView.mas_centerY);
        make.height.mas_equalTo(@30);
        make.width.mas_equalTo(@20);
    }];
    [self.addressNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(addressImage.mas_right).offset(10);
        make.top.equalTo(weakSelf.addressView).offset(15);
    }];
    [self.addressPhoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.addressNameLabel.mas_right).offset(20);
        make.centerY.equalTo(weakSelf.addressNameLabel.mas_centerY);
    }];
    [self.addressDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(addressImage.mas_right).offset(10);
        make.right.equalTo(weakSelf.addressView).offset(-10);
        make.bottom.equalTo(weakSelf.addressView).offset(-15);
    }];
    [promptView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.addressView.mas_bottom);
        make.centerX.equalTo(weakSelf.mas_centerX);
        make.width.mas_equalTo(@(SCREENWIDTH));
        make.height.mas_equalTo(@(0.5));
    }];
    [promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(promptView).offset(5);
        make.width.mas_equalTo(@(SCREENWIDTH - 10));
        make.height.mas_equalTo(0.5);
    }];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf).offset(-45);
        make.left.right.equalTo(weakSelf);
        make.height.mas_equalTo(@15);
    }];
    
    // == 物流信息视图 == //
    [fourView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView.mas_bottom).offset(0);
        make.left.right.equalTo(weakSelf);
        make.height.mas_equalTo(@45);
    }];
    [logistics mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(fourView).offset(10);
        make.centerY.equalTo(fourView.mas_centerY);
    }];
    [logisticeImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(fourView).offset(-10);
        make.centerY.equalTo(fourView.mas_centerY);
        make.width.mas_equalTo(@16);
        make.height.mas_equalTo(@25);
    }];
    [self.logisticsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(logisticeImage.mas_left).offset(-10);
        make.centerY.equalTo(fourView.mas_centerY);
    }];
    
    UIView *fourLineV = [UIView new];
    [fourView addSubview:fourLineV];
    fourLineV.backgroundColor = [UIColor countLabelColor];
    [fourLineV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(@1);
        make.left.right.bottom.equalTo(fourView);
    }];

    self.nomalLabel = [UILabel new];
    [self.addressView addSubview:self.nomalLabel];
    self.nomalLabel.font = [UIFont systemFontOfSize:18.];
    self.nomalLabel.textColor = [UIColor dingfanxiangqingColor];
    [self.nomalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.addressView.mas_centerY);
        make.centerX.equalTo(weakSelf.addressView.mas_centerX);
    }];
    
    
}
- (void)tapClick:(UITapGestureRecognizer *)tap {
    UIView *tapView = [tap view];
    NSInteger tag = tapView.tag;
    
    if (_delegate && [_delegate respondsToSelector:@selector(composeHeaderTapView:TapClick:)]) {
        [_delegate composeHeaderTapView:self TapClick:tag];
    }
}


@end
























































