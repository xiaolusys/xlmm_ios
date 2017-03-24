//
//  JMReGoodsAddView.m
//  XLMM
//
//  Created by 崔人帅 on 16/6/6.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMReGoodsAddView.h"
#import "JMRichTextTool.h"

@interface JMReGoodsAddView ()
/**
 *  退货地址头部
 */
@property (nonatomic,strong) UIView *topLineView;
/**
 *  背景视图
 */
@property (nonatomic,strong) UIView *masBackView;
/**
 *  退货地址
 */
@property (nonatomic,strong) UILabel *reGoodsAddressL;

@property (nonatomic,strong) UILabel *nameL;
@property (nonatomic,strong) UILabel *PhoneL;
@property (nonatomic,strong) UILabel *addressL;
/**
 *  分割线
 */
@property (nonatomic,strong) UIView *cutOffView;

@property (nonatomic,strong) UILabel *titleL;
@property (nonatomic,strong) UILabel *firstL;
@property (nonatomic,strong) UILabel *firstRightL;
@property (nonatomic,strong) UILabel *secondL;
@property (nonatomic,strong) UILabel *thirdL;
@property (nonatomic,strong) UILabel *fourthL;

@end

@implementation JMReGoodsAddView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self preporaUI];
        [self prepreaLaypout];
    }
    return self;
}
- (void)setReGoodsDic:(NSDictionary *)reGoodsDic {
    _reGoodsDic = reGoodsDic;
    
//    self.nameL.text = [NSString stringWithFormat:@"收件人:%@",reGoodsDic[@"buyer_nick"]];
//    self.PhoneL.text = [NSString stringWithFormat:@"联系电话:%@",reGoodsDic[@"mobile"]];
//    NSString *douhaoStr = @"，";
    NSString *addressStr = reGoodsDic[@"return_address"];
    if ([NSString isStringEmpty:addressStr]) {
        self.nameL.text = @"";
        self.PhoneL.text = @"";
        self.addressL.text = @"退货地址请咨询小鹿美美客服哦";
        self.addressL.textColor = [UIColor redColor];
        return ;
    }
    if ([addressStr rangeOfString:@"，"].location != NSNotFound) {
        NSArray *arr = [addressStr componentsSeparatedByString:@"，"];
        NSString *addStr = @"";
        NSString *nameStr = @"";
        NSString *phoneStr = @"";
        if (arr.count > 0) {
            addStr = arr[0];
            nameStr = arr[2];
            phoneStr = arr[1];
            self.nameL.text = [NSString stringWithFormat:@"收件人:%@",nameStr];
            self.PhoneL.text = [NSString stringWithFormat:@"联系电话:%@",phoneStr];
            self.addressL.text = [NSString stringWithFormat:@"退货地址:%@",addStr];
        }else {
            //            return ;
        }
        
    }else {
        self.nameL.text = @"";
        self.PhoneL.text = @"";
        self.addressL.text = @"退货地址请咨询小鹿美美客服哦";
        self.addressL.textColor = [UIColor redColor];
    }
    
//    NSArray *arr = [reGoodsDic[@"return_address"] componentsSeparatedByString:@"，"];
//    NSString *addStr = @"";
//    NSString *nameStr = @"";
//    NSString *phoneStr = @"";
//    if (arr.count > 0) {
//        addStr = arr[0];
//        nameStr = arr[1];
//        phoneStr = arr[2];
//    }else {
//        return ;
//    }
    
}
- (void)preporaUI {
    UIView *topLineView = [UIView new];
    [self addSubview:topLineView];
    self.topLineView = topLineView;
    self.topLineView.layer.masksToBounds = YES;
    self.topLineView.layer.cornerRadius = 3.;
    self.topLineView.backgroundColor = [UIColor buttonEnabledBackgroundColor];
    
    UIView *masBackView = [UIView new];
    [self addSubview:masBackView];
    self.masBackView = masBackView;
    self.masBackView.backgroundColor = [UIColor whiteColor];
    
    UIView *cutOffView = [UIView new];
    [self.masBackView addSubview:cutOffView];
    self.cutOffView = cutOffView;
    self.cutOffView.backgroundColor = [UIColor titleDarkGrayColor];
    
    UILabel *reGoodsAddressL = [UILabel new];
    [self.masBackView addSubview:reGoodsAddressL];
    self.reGoodsAddressL = reGoodsAddressL;
    self.reGoodsAddressL.font = [UIFont boldSystemFontOfSize:15.];
    self.reGoodsAddressL.text = @"退货地址";
    
    UILabel *nameL = [UILabel new];
    [self.masBackView addSubview:nameL];
    self.nameL = nameL;
    self.nameL.font = [UIFont systemFontOfSize:12.];

    UILabel *PhoneL = [UILabel new];
    [self.masBackView addSubview:PhoneL];
    self.PhoneL = PhoneL;
    self.PhoneL.font = [UIFont systemFontOfSize:12.];
    self.PhoneL.textAlignment = NSTextAlignmentRight;
    
    UILabel *addressL = [UILabel new];
    [self.masBackView addSubview:addressL];
    self.addressL = addressL;
    self.addressL.font = [UIFont systemFontOfSize:12.];
    self.addressL.numberOfLines = 0;
    
    UILabel *titleL = [UILabel new];
    [self.masBackView addSubview:titleL];
    self.titleL = titleL;
    self.titleL.text = @"为提高您的退货退款效率,请注意以下事项";
    self.titleL.font = [UIFont systemFontOfSize:12.];
//    
//    UILabel *firstRightL = [UILabel new];
//    [self.masBackView addSubview:firstRightL];
//    self.firstRightL = firstRightL;
//    self.firstRightL.textColor = [UIColor buttonEnabledBackgroundColor];
//    self.firstRightL.numberOfLines = 0;
//    self.firstRightL.text = @"微信昵称、联系电话、退换货原因";
//    self.firstRightL.font = [UIFont systemFontOfSize:12.];
    
    UILabel *firstL = [UILabel new];
    [self.masBackView addSubview:firstL];
    self.firstL = firstL;
    NSString *colorTitle = @"微信昵称、联系电话、退换货原因";
    NSString *allString = [NSString stringWithFormat:@"1.填写退货单or小纸条一并寄回写明您的%@。请务必在退货申请里填写退货物流信息，以方便我们最快给您退款",colorTitle];
    self.firstL.attributedText = [JMRichTextTool cs_changeFontAndColorWithSubFont:[UIFont boldSystemFontOfSize:12.] SubColor:[UIColor buttonEnabledBackgroundColor] AllString:allString SubStringArray:@[colorTitle]];
    self.firstL.numberOfLines = 0;
    self.firstL.font = [UIFont systemFontOfSize:12.];

    UILabel *secondL = [UILabel new];
    [self.masBackView addSubview:secondL];
    self.secondL = secondL;
    self.secondL.numberOfLines = 0;
    self.secondL.font = [UIFont systemFontOfSize:12.];
    self.secondL.text = @"2.勿发顺丰或EMS高等邮费快递";
    
    UILabel *thirdL = [UILabel new];
    [self.masBackView addSubview:thirdL];
    self.thirdL = thirdL;
    self.thirdL.numberOfLines = 0;
    self.thirdL.font = [UIFont systemFontOfSize:12.];
    self.thirdL.text = @"3.质量问题退货请事先拍照并联系在线客服，客服审核通过后会包邮退，但请您先支付邮费，仓库拒收到付件，到货验收后，货款和邮费将分开退还至您相应的账户";
    
    UILabel *fourthL = [UILabel new];
    [self.masBackView addSubview:fourthL];
    self.fourthL = fourthL;
    self.fourthL.numberOfLines = 0;
    self.fourthL.font = [UIFont systemFontOfSize:12.];
    self.fourthL.text = @"4.请保持衣服吊牌完整,不影响商品后续处理";
    
    
}

- (void)prepreaLaypout { // 360
    kWeakSelf
    
    [self.topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf).offset(20);
        make.left.equalTo(weakSelf).offset(15);
        make.width.mas_equalTo(SCREENWIDTH - 30);
        make.height.mas_equalTo(@5);
    }];
    
    [self.masBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.topLineView).offset(3);
        make.left.equalTo(weakSelf).offset(17);
        make.width.mas_equalTo(SCREENWIDTH - 34);
        make.bottom.equalTo(weakSelf).offset(-20);
    }];
    
    [self.reGoodsAddressL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.masBackView).offset(15);
        make.centerX.equalTo(weakSelf.masBackView.mas_centerX);
    }];

    [self.nameL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.reGoodsAddressL.mas_bottom).offset(20);
        make.left.equalTo(weakSelf.masBackView).offset(15);
    }];
    
    [self.PhoneL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.masBackView).offset(15);
        make.top.equalTo(weakSelf.nameL.mas_bottom).offset(5);
    }];
    
    [self.addressL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.PhoneL.mas_bottom).offset(5);
        make.left.equalTo(weakSelf.nameL);
        make.right.equalTo(weakSelf.masBackView).offset(-10);
    }];
    
    [self.cutOffView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.addressL.mas_bottom).offset(15);
        make.left.equalTo(weakSelf.nameL);
        make.right.equalTo(weakSelf.masBackView);
        make.height.mas_equalTo(@1);
    }];
    
    [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.cutOffView).offset(20);
        make.left.equalTo(weakSelf.nameL);
    }];
    
    [self.firstL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.titleL.mas_bottom).offset(15);
        make.left.equalTo(weakSelf.nameL);
        make.right.equalTo(weakSelf.masBackView).offset(-10);
    }];
    
//    [self.firstRightL mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(weakSelf.firstL.mas_right);
//        make.top.equalTo(weakSelf.titleL.mas_bottom).offset(15);
//        make.right.equalTo(weakSelf.masBackView).offset(-10);
//    }];
//    
    [self.secondL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.firstL.mas_bottom).offset(15);
        make.left.equalTo(weakSelf.nameL);
    }];
    
    [self.thirdL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.secondL.mas_bottom).offset(15);
        make.left.equalTo(weakSelf.nameL);
        make.right.equalTo(weakSelf.masBackView).offset(-10);
    }];
    
    [self.fourthL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.thirdL.mas_bottom).offset(15);
        make.left.equalTo(weakSelf.nameL);
    }];
    
    
    
}



@end




























































