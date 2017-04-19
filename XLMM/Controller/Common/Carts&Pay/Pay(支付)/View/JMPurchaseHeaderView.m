//
//  JMPurchaseHeaderView.m
//  XLMM
//
//  Created by zhang on 16/7/21.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMPurchaseHeaderView.h"
#import "JMAddressModel.h"
#import "JMRichTextTool.h"


@interface JMPurchaseHeaderView () <UITextFieldDelegate> {
    UIImageView *_sideFaceImage;
    UIImageView *_sideBackImage;
    UILabel *_sideFaceLabel;
    UILabel *_sideBackLabel;
    NSMutableDictionary *parame;
}

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
@property (nonatomic, strong) UITextField *idCardField;
@property (nonatomic, strong) UIButton *idcardSaveButton;
@property (nonatomic, strong) UILabel *idCardLabel;

@property (nonatomic, strong) UIView *idCardView;

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
        self.addressModel = [JMAddressModel mj_objectWithKeyValues:addressDic];
        self.nomalLabel.hidden = YES;
        self.addressNameLabel.text = addressDic[@"receiver_name"];
        self.addressPhoneLabel.text = addressDic[@"receiver_phone"];
        self.addressDetailLabel.text = [NSString stringWithFormat:@"%@%@%@%@",addressDic[@"receiver_state"],addressDic[@"receiver_city"],addressDic[@"receiver_district"],addressDic[@"receiver_address"]];
        NSString *idCardNumber = [NSString stringWithFormat:@"%@",addressDic[@"identification_no"]];
        if (![NSString isStringEmpty:idCardNumber]) {
            self.idCardField.text = idCardNumber;
            self.saveIdcardSuccess = YES;
        }else {
            _saveIdcardSuccess = NO;
            [self.idcardSaveButton setTitle:@"保存" forState:UIControlStateNormal];
            [self.promptView bringSubviewToFront:self.idCardField];
            self.idCardField.text = @"";
        }
        NSDictionary *idCardDic = addressDic[@"idcard"];
        [_sideFaceImage sd_setImageWithURL:[NSURL URLWithString:[idCardDic[@"face"] JMUrlEncodedString]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            self.zhengImage = image;
        }];
        [_sideBackImage sd_setImageWithURL:[NSURL URLWithString:[idCardDic[@"back"] JMUrlEncodedString]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            self.fanImage = image;
        }];
        [self fetAddressModel:self.addressModel];
    }
}
- (void)fetAddressModel:(JMAddressModel *)model {
    parame[@"id"] = model.addressID;
    parame[@"receiver_state"] = model.receiver_state;
    parame[@"receiver_city"] = model.receiver_city;
    parame[@"receiver_district"] = model.receiver_district;
    parame[@"receiver_address"] = model.receiver_address;
    parame[@"receiver_name"] = model.receiver_name;
    parame[@"receiver_mobile"] = model.receiver_mobile;
}
- (void)setAddressModel:(JMAddressModel *)addressModel {
    _addressModel = addressModel;
    self.nomalLabel.hidden = YES;
    self.addressNameLabel.text = addressModel.receiver_name;
    self.addressPhoneLabel.text = addressModel.receiver_mobile;
    self.addressDetailLabel.text = [NSString stringWithFormat:@"%@%@%@%@",addressModel.receiver_state,addressModel.receiver_city,addressModel.receiver_district,addressModel.receiver_address];
    NSString *idCardNumber = addressModel.identification_no;
    if (![NSString isStringEmpty:idCardNumber]) {
        self.idCardField.text = idCardNumber;
        self.saveIdcardSuccess = YES;
    }else {
        _saveIdcardSuccess = NO;
        [self.idcardSaveButton setTitle:@"保存" forState:UIControlStateNormal];
        [self.promptView bringSubviewToFront:self.idCardField];
        self.idCardField.text = @"";
    }
    NSDictionary *idCardDic = addressModel.idcard;
    [_sideFaceImage sd_setImageWithURL:[NSURL URLWithString:[idCardDic[@"face"] JMUrlEncodedString]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.zhengImage = image;
    }];
    [_sideBackImage sd_setImageWithURL:[NSURL URLWithString:[idCardDic[@"back"] JMUrlEncodedString]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.fanImage = image;
    }];
    [self fetAddressModel:self.addressModel];
    
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
    if (cartsInfoLevel >= 2) {
        self.promptView.hidden = NO;
        [self.promptView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(@(50));
        }];
        if (cartsInfoLevel == 3) {
            self.idCardView.hidden = NO;
            [self.idCardView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(@(100));
            }];
        }
    }
    
}
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _saveIdcardSuccess = NO;
        parame = [NSMutableDictionary dictionary];
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
    promptView.backgroundColor = [UIColor countLabelColor];
    [self addSubview:promptView];
    self.promptView = promptView;
    
    UIView *kongbaiView = [UIView new];
    kongbaiView.backgroundColor = [UIColor whiteColor];
    [promptView addSubview:kongbaiView];
    
    UITextField *idCardField = [[UITextField alloc] init];
    idCardField.backgroundColor = [UIColor whiteColor];
    idCardField.placeholder = @"请输入身份证号";
    idCardField.borderStyle = UITextBorderStyleNone;
    idCardField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    idCardField.clearButtonMode = UITextFieldViewModeWhileEditing;
    idCardField.font = [UIFont systemFontOfSize:13.];
    idCardField.delegate = self;
    [promptView addSubview:idCardField];
    [idCardField addTarget:self action:@selector(idcardFieldChange:) forControlEvents:UIControlEventEditingChanged];
    self.idCardField = idCardField;
    
    UILabel *idCardLabel = [UILabel new];
    idCardLabel.backgroundColor = [UIColor whiteColor];
    idCardLabel.font = CS_UIFontSize(14.);
    [promptView addSubview:idCardLabel];
    self.idCardLabel = idCardLabel;
    
    [promptView bringSubviewToFront:self.idCardField];
    
    UIButton *idcardSaveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [idcardSaveButton setTitle:@"保存" forState:UIControlStateNormal];
    [idcardSaveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    idcardSaveButton.titleLabel.font = CS_UIFontSize(12.);
    idcardSaveButton.backgroundColor = [UIColor titleDarkGrayColor];
    [idcardSaveButton addTarget:self action:@selector(saveIDCardClick:) forControlEvents:UIControlEventTouchUpInside];
    idcardSaveButton.enabled = NO;
    [promptView addSubview:idcardSaveButton];
    self.idcardSaveButton = idcardSaveButton;
    
    
    self.promptView.hidden = YES;
    
    UIView *idCardView = [UIView new];
    idCardView.backgroundColor = [UIColor countLabelColor];
    [self addSubview:idCardView];
    self.idCardView = idCardView;
    
    UIButton *sideFacebutton = [UIButton buttonWithType:UIButtonTypeCustom];
    [idCardView addSubview:sideFacebutton];
    sideFacebutton.layer.masksToBounds = YES;
    sideFacebutton.layer.borderColor = [UIColor lineGrayColor].CGColor;
    sideFacebutton.layer.borderWidth = 0.5f;
    sideFacebutton.tag = 10;
    [sideFacebutton addTarget:self action:@selector(idcardClick:) forControlEvents:UIControlEventTouchUpInside];
    UIButton *sideBackbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    [idCardView addSubview:sideBackbutton];
    sideBackbutton.layer.masksToBounds = YES;
    sideBackbutton.layer.borderColor = [UIColor lineGrayColor].CGColor;
    sideBackbutton.layer.borderWidth = 0.5f;
    sideBackbutton.tag = 11;
    [sideBackbutton addTarget:self action:@selector(idcardClick:) forControlEvents:UIControlEventTouchUpInside];
    
    _sideFaceImage = [UIImageView new];
    [sideFacebutton addSubview:_sideFaceImage];
    _sideFaceImage.contentMode = UIViewContentModeScaleAspectFit;
    _sideFaceImage.image = [UIImage imageNamed:@"idCardSideFace"];
    _sideBackImage = [UIImageView new];
    [sideBackbutton addSubview:_sideBackImage];
    _sideBackImage.contentMode = UIViewContentModeScaleAspectFit;
    _sideBackImage.image = [UIImage imageNamed:@"idCardSideBack"];
    
    _sideFaceLabel = [UILabel new];
    _sideFaceLabel.font = [UIFont systemFontOfSize:10.];
    _sideFaceLabel.textColor = [UIColor buttonTitleColor];
    _sideFaceLabel.numberOfLines = 0;
    _sideFaceLabel.textAlignment = NSTextAlignmentCenter;
    //    _sideFaceLabel.text = @"请上传身份证\n正面照";
    [sideFacebutton addSubview:_sideFaceLabel];
    _sideBackLabel = [UILabel new];
    _sideBackLabel.font = [UIFont systemFontOfSize:10.];
    _sideBackLabel.textColor = [UIColor buttonTitleColor];
    _sideBackLabel.numberOfLines = 0;
    _sideBackLabel.textAlignment = NSTextAlignmentCenter;
    //    _sideBackLabel.text = @"请上传身份证\n反面照";
    [sideBackbutton addSubview:_sideBackLabel];
    
    _sideFaceLabel.attributedText = [JMRichTextTool cs_changeFontAndColorWithSubFont:[UIFont systemFontOfSize:12.] SubColor:[UIColor redColor] AllString:@"请上传身份证\n正面照" SubStringArray:@[@"正面照"]];
    _sideBackLabel.attributedText = [JMRichTextTool cs_changeFontAndColorWithSubFont:[UIFont systemFontOfSize:12.] SubColor:[UIColor redColor] AllString:@"请上传身份证\n反面照" SubStringArray:@[@"反面照"]];
    
    self.idCardView.hidden = YES;
    
//    UILabel *promptLabel = [UILabel new];
//    [promptView addSubview:promptLabel];
//    promptLabel = promptLabel;
//    promptLabel.font = [UIFont systemFontOfSize:12.];
//    promptLabel.textColor = [UIColor redColor];
//    promptLabel.numberOfLines = 0;
////    self.promptLabel.textAlignment = NSTextAlignmentCenter;
//    self.promptLabel = promptLabel;
//    
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
        make.height.mas_equalTo(@(0));
    }];
//    [promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.left.equalTo(promptView).offset(5);
//        make.width.mas_equalTo(@(SCREENWIDTH - 10));
//        make.height.mas_equalTo(0.5);
//    }];
    [kongbaiView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(promptView);
        make.centerY.equalTo(promptView.mas_centerY);
        make.width.mas_equalTo(@(10));
        make.height.mas_equalTo(@(35));
    }];
    [idCardField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(kongbaiView.mas_right);
        make.right.equalTo(idcardSaveButton.mas_left);
        make.centerY.equalTo(promptView.mas_centerY);
        make.height.mas_equalTo(@(35));
    }];
    [idCardLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(kongbaiView.mas_right);
        make.right.equalTo(idcardSaveButton.mas_left);
        make.centerY.equalTo(promptView.mas_centerY);
        make.height.mas_equalTo(@(35));
    }];
    [idcardSaveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(promptView);
        make.centerY.equalTo(promptView.mas_centerY);
        make.width.mas_equalTo(@(60));
        make.height.mas_equalTo(@(35));
    }];
    
    [idCardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(promptView.mas_bottom);
        make.centerX.equalTo(weakSelf.mas_centerX);
        make.width.mas_equalTo(@(SCREENWIDTH));
        make.height.mas_equalTo(@(0));
    }];
    [sideFacebutton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(idCardView).offset(5);
        make.left.equalTo(idCardView).offset(10);
        make.width.height.mas_equalTo(@(90));
    }];
    [sideBackbutton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(sideFacebutton.mas_centerY);
        make.left.equalTo(sideFacebutton.mas_right).offset(20);
        make.width.height.mas_equalTo(@(90));
    }];
    [_sideFaceImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(sideFacebutton).offset(10);
        make.centerX.equalTo(sideFacebutton.mas_centerX);
        make.width.mas_equalTo(@(51));
        make.height.mas_equalTo(@(32));
    }];
    [_sideBackImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(sideBackbutton).offset(10);
        make.centerX.equalTo(sideBackbutton.mas_centerX);
        make.width.mas_equalTo(@(51));
        make.height.mas_equalTo(@(32));
    }];
    [_sideFaceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(sideFacebutton.mas_centerX);
        make.bottom.equalTo(sideFacebutton).offset(-5);
    }];
    [_sideBackLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(sideBackbutton.mas_centerX);
        make.bottom.equalTo(sideBackbutton).offset(-5);
    }];
    
    
    
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf).offset(-45);
        make.left.right.equalTo(weakSelf);
        make.height.mas_equalTo(@15);
    }];
    
    // == 物流信息视图 == //
    [fourView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView.mas_bottom);
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
    
//    [self.promptView removeFromSuperview];
}
- (void)idcardClick:(UIButton *)button {
    if (_delegate && [_delegate respondsToSelector:@selector(composeHeaderIdcardActionSheetClick:Button:params:)]) {
        [_delegate composeHeaderIdcardActionSheetClick:self Button:button params:parame];
    }
}


- (void)tapClick:(UITapGestureRecognizer *)tap {
    UIView *tapView = [tap view];
    NSInteger tag = tapView.tag;
    
    if (_delegate && [_delegate respondsToSelector:@selector(composeHeaderTapView:TapClick:)]) {
        [_delegate composeHeaderTapView:self TapClick:tag];
    }
}
#pragma mark 代理实现
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}
- (void)idcardFieldChange:(UITextField *)textField {
    NSLog(@"%@",textField.text);
//    if (textField.text.length > 18) {
//        [MBProgressHUD showWarning:@"身份证号最多18位"];
//        textField.text = [textField.text substringToIndex:18];
//        self.idcardSaveButton.enabled = YES;
//        self.idcardSaveButton.backgroundColor = [UIColor buttonEnabledBackgroundColor];
//    }else {
//        self.idcardSaveButton.enabled = NO;
//        self.idcardSaveButton.backgroundColor = [UIColor titleDarkGrayColor];
//    }
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSMutableString *muString = [[NSMutableString alloc] initWithString:textField.text];
    [muString appendString:string];
    [muString deleteCharactersInRange:range];
    NSLog(@"%@",muString);
    if (muString.length > 18) {
        [MBProgressHUD showWarning:@"身份证号最多18位"];
        return NO;
    }else if (muString.length == 18) {
        self.idcardSaveButton.enabled = YES;
        self.idcardSaveButton.backgroundColor = [UIColor buttonEnabledBackgroundColor];
        self.idCardField.text = [NSString stringWithFormat:@"%@",muString];
        return NO;
    }else {
        self.idcardSaveButton.enabled = NO;
        self.idcardSaveButton.backgroundColor = [UIColor titleDarkGrayColor];
    }
    return YES;
}
- (void)saveIDCardClick:(UIButton *)button {
    [self.idCardField resignFirstResponder];
    if (_saveIdcardSuccess) {
        _saveIdcardSuccess = NO;
        [self.idcardSaveButton setTitle:@"保存" forState:UIControlStateNormal];
        [self.promptView bringSubviewToFront:self.idCardField];
        self.idCardField.text = @"";
        return;
    }
    if (![[JMGlobal global] validateIdentityCard:self.idCardField.text]) {
        [MBProgressHUD showWarning:@"请核对身份证号"];
        return ;
    }
    parame[@"identification_no"] = self.idCardField.text;
    if (self.delegate && [self.delegate respondsToSelector:@selector(composeHeaderSaveIdcard:Button:params:)]) {
        [self.delegate composeHeaderSaveIdcard:self Button:button params:parame];
    }

    
}

- (void)setSaveIdcardSuccess:(BOOL)saveIdcardSuccess {
    _saveIdcardSuccess = saveIdcardSuccess;
    [self.idcardSaveButton setTitle:@"修改" forState:UIControlStateNormal];
    self.idcardSaveButton.enabled = YES;
    self.idcardSaveButton.backgroundColor = [UIColor buttonEnabledBackgroundColor];
    [self.promptView bringSubviewToFront:self.idCardLabel];
    NSString *idCardStr = @"身份证号   ";
    NSMutableString * mutablePhoneNumber = [self.idCardField.text mutableCopy];
    NSRange range = {4,10};
    if (mutablePhoneNumber.length == 18) {
        [mutablePhoneNumber replaceCharactersInRange:range withString:@"**********"];
    }
    self.idCardLabel.attributedText = [JMRichTextTool cs_changeFontAndColorWithSubFont:[UIFont systemFontOfSize:14.] SubColor:[UIColor textDarkGrayColor] AllString:[NSString stringWithFormat:@"%@%@",idCardStr,mutablePhoneNumber] SubStringArray:@[mutablePhoneNumber]];
    
}
- (void)setZhengImage:(UIImage *)zhengImage {
    _zhengImage = zhengImage;
    if (zhengImage == nil) {
        _sideFaceImage.image = [UIImage imageNamed:@"idCardSideFace"];
        _sideFaceLabel.hidden = NO;
        [_sideFaceImage mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(@(51));
            make.height.mas_equalTo(@(32));
        }];
        return;
    }
    _sideFaceImage.image = zhengImage;
    [_sideFaceImage mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(@(70));
    }];
    _sideFaceLabel.hidden = YES;
    
}
- (void)setFanImage:(UIImage *)fanImage {
    _fanImage = fanImage;
    if (fanImage == nil) {
        [_sideBackImage mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(@(51));
            make.height.mas_equalTo(@(32));
        }];
        _sideBackLabel.hidden = NO;
        _sideBackImage.image = [UIImage imageNamed:@"idCardSideBack"];
        return;
    }
    [_sideBackImage mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(@(70));
    }];
    _sideBackLabel.hidden = YES;
    _sideBackImage.image = fanImage;
}



@end
























































