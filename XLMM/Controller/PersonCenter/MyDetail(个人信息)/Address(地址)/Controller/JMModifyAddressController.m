//
//  JMModifyAddressController.m
//  XLMM
//
//  Created by zhang on 17/2/20.
//  Copyright © 2017年 上海己美. All rights reserved.
//

#import "JMModifyAddressController.h"
#import "UILabel+CustomLabel.h"
#import "JMSelectAddressView.h"
#import "JMAddressModel.h"
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "JMRichTextTool.h"


#define iOS7Later ([UIDevice currentDevice].systemVersion.floatValue >= 7.0f)
#define iOS8Later ([UIDevice currentDevice].systemVersion.floatValue >= 8.0f)
#define iOS9Later ([UIDevice currentDevice].systemVersion.floatValue >= 9.0f)
#define iOS9_1Later ([UIDevice currentDevice].systemVersion.floatValue >= 9.1f)


@interface JMModifyAddressController () <UIGestureRecognizerDelegate, UIActionSheetDelegate, UIAlertViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
    NSString *province;
    NSString *city;
    NSString *county;
    NSMutableArray *_selectedPhotos;
    NSString *sideFace;
    NSString *sideBack;
    NSString *idCardName;
    NSString *idCardNum;
    NSString *sideType;
    
    UIImageView *_sideFaceImage;
    UIImageView *_sideBackImage;
    UILabel *_sideFaceLabel;
    UILabel *_sideBackLabel;
 
    UIImage *_currentImage;
    
    NSString *addressID;                // 地址ID
    NSString *logistic_company_code;
}

@property (nonatomic, strong) UIScrollView *maskScrollView;
@property (nonatomic, strong) UIButton *navRightButton;
@property (nonatomic, strong) UILabel *warningLabel;

@property (nonatomic, strong) UITextField *consigneeField;
@property (nonatomic, strong) UITextField *phoneNumField;
@property (nonatomic, strong) UITextField *idCardField;
@property (nonatomic, strong) UITextField *areaField;

@property (nonatomic, strong) UITextView *addressTextView;
@property (nonatomic, strong) UILabel *placeHolderLabel;

@property (nonatomic, strong) UIView *idCardView;
@property (nonatomic, strong) UIButton *againUpdatabutton;
@property (nonatomic, strong) UIButton *savebutton;

@property (nonatomic, strong) JMSelectAddressView *selectView;

@property (nonatomic, strong) UICollectionView *collecionView;

@end

@implementation JMModifyAddressController

- (UIScrollView *)maskScrollView {
    if (!_maskScrollView) {
        _maskScrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
        
    }
    return _maskScrollView;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"JMModifyAddressController"];
    
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"JMModifyAddressController"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _selectedPhotos = [NSMutableArray array];
    
    NSString *titleString = @"修改收货地址";
    if (self.isAdd) {
        titleString = @"新增收货地址";
    }
    
    addressID = self.orderDict[@"user_adress"][@"id"];
    logistic_company_code = self.orderDict[@"logistic_company_code"];
    
    [self createNavigationBarWithTitle:titleString selecotr:@selector(backClick)];
    self.view.backgroundColor = [UIColor countLabelColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoard:)];
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
//    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endEditing)]];
    [self.view addSubview:self.maskScrollView];
    
    [self createInputBoxView];
    JMSelectAddressView *selectView = [[JMSelectAddressView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.selectView = selectView;
    kWeakSelf
    self.selectView.block = ^(NSString *proviceStr,NSString *cityStr,NSString * disStr) {
        NSLog(@"%@,%@,%@",proviceStr , cityStr , disStr);
        weakSelf.areaField.text = [NSString stringWithFormat:@"%@%@%@",proviceStr,cityStr,disStr];
        province = [proviceStr copy];
        city = [cityStr copy];
        county = [disStr copy];
    };
    
    
//    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:@"http://m.xiaolumeimei.com/rest/v1/address/175223.json" WithParaments:nil WithSuccess:^(id responseObject) {
//        NSLog(@"%@",responseObject);
//    } WithFail:^(NSError *error) {
//        
//    } Progress:^(float progress) {
//    }];
    
    
    
}
#pragma mark 网络请求
// 删除地址
- (void)deleteAddress {
    NSString *string = [NSString stringWithFormat:@"%@/rest/v1/address/%@/delete_address", Root_URL, self.addressModel.addressID];
    [JMHTTPManager requestWithType:RequestTypePOST WithURLString:string WithParaments:nil WithSuccess:^(id responseObject) {
        /*
         {
         code = 1;
         msg = "\U5220\U9664\U51fa\U9519";
         ret = 0;
         }
         */
        [self.navigationController popViewControllerAnimated:YES];
    } WithFail:^(NSError *error) {
        [MBProgressHUD showWarning:@"删除地址失败"];
    } Progress:^(float progress) {
    }];
}




#pragma mark 创建UI
- (void)createNavRightItem {
    NSString *titleStr = @"删除";
    CGFloat titleStrWidth = [titleStr widthWithHeight:0. andFont:14.].width;
    self.navRightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, titleStrWidth, 44)];
    [self.navRightButton addTarget:self action:@selector(rightNavigationClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.navRightButton setTitle:titleStr forState:UIControlStateNormal];
    [self.navRightButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    self.navRightButton.titleLabel.font = [UIFont systemFontOfSize:14.];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.navRightButton];
}
- (void)createInputBoxView {
    CGFloat firstSectionViewH = 100.;
    CGFloat labelWidth = 80.f;
    if (self.cartsPayInfoLevel > 1) {
        firstSectionViewH = 140.;
    }
    UIView *firstSectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, SCREENWIDTH, firstSectionViewH)];
    firstSectionView.backgroundColor = [UIColor whiteColor];
    UILabel *consigneeLabel = [self createLabelWithFrame:CGRectMake(20, 10, labelWidth * HomeCategoryRatio, 40) font:13. textColor:[UIColor buttonTitleColor] text:@"收货人"];
    UILabel *phoneNumLabel = [self createLabelWithFrame:CGRectMake(20, consigneeLabel.mj_max_Y, labelWidth * HomeCategoryRatio, 40) font:13. textColor:[UIColor buttonTitleColor] text:@"手机号"];
    UITextField *consigneeField = [self createTextFieldWithFrame:CGRectMake(labelWidth * HomeCategoryRatio + 20, 15, SCREENWIDTH - consigneeLabel.mj_max_X - 20, 30) PlaceHolder:@"请输入收货人姓名" KeyboardType:UIKeyboardTypeDefault];
    UITextField *phoneNumField = [self createTextFieldWithFrame:CGRectMake(labelWidth * HomeCategoryRatio + 20, consigneeField.mj_max_Y + 10, SCREENWIDTH - consigneeLabel.mj_max_X - 20, 30) PlaceHolder:@"请输入收货人手机号" KeyboardType:UIKeyboardTypeNumberPad];
    self.consigneeField = consigneeField;
    self.phoneNumField = phoneNumField;
    [self.maskScrollView addSubview:firstSectionView];
    [firstSectionView addSubview:consigneeLabel];
    [firstSectionView addSubview:phoneNumLabel];
    [firstSectionView addSubview:consigneeField];
    [firstSectionView addSubview:phoneNumField];
    if (self.cartsPayInfoLevel > 1) {
        UILabel *idCardLabel = [self createLabelWithFrame:CGRectMake(20, phoneNumLabel.mj_max_Y, labelWidth * HomeCategoryRatio, 40) font:13. textColor:[UIColor buttonTitleColor] text:@"身份证号"];
            UITextField *idCardField = [self createTextFieldWithFrame:CGRectMake(labelWidth * HomeCategoryRatio + 20, phoneNumField.mj_max_Y + 10, SCREENWIDTH - consigneeLabel.mj_max_X - 20, 30) PlaceHolder:@"请输入身份证号" KeyboardType:UIKeyboardTypeNumbersAndPunctuation];
        self.idCardField = idCardField;
        [firstSectionView addSubview:idCardLabel];
        [firstSectionView addSubview:idCardField];
    }
    
    UIView *secondSectionView = [[UIView alloc] initWithFrame:CGRectMake(0, firstSectionView.mj_max_Y + 20, SCREENWIDTH, 150)];
    secondSectionView.backgroundColor = [UIColor whiteColor];
    UILabel *areaLabel = [self createLabelWithFrame:CGRectMake(20, 10, labelWidth * HomeCategoryRatio, 40) font:13. textColor:[UIColor buttonTitleColor] text:@"所在地区"];
    UILabel *addressLabel = [self createLabelWithFrame:CGRectMake(20, areaLabel.mj_max_Y, labelWidth * HomeCategoryRatio, 40) font:13. textColor:[UIColor buttonTitleColor] text:@"详细地址"];
    UITextField *areaField = [self createTextFieldWithFrame:CGRectMake(labelWidth * HomeCategoryRatio + 20, 15, SCREENWIDTH - consigneeLabel.mj_max_X - 20, 30) PlaceHolder:@"请选择您所在地区" KeyboardType:UIKeyboardTypeDefault];
    
    self.areaField = areaField;
    [self.maskScrollView addSubview:secondSectionView];
    [secondSectionView addSubview:areaLabel];
    [secondSectionView addSubview:addressLabel];
    [secondSectionView addSubview:areaField];

//    unsigned int count = 0;
//    Ivar *ivars = class_copyIvarList([UITextView class], &count);
//    for (int i = 0; i < count; i++) {
//        Ivar ivar = ivars[i];
//        const char *name = ivar_getName(ivar);
//        NSString *objcName = [NSString stringWithUTF8String:name];
//        NSLog(@"%d : %@",i , objcName);
//    }
    UITextView *addressTextView = [[UITextView alloc] initWithFrame:CGRectMake(labelWidth * HomeCategoryRatio + 20, areaField.mj_max_Y + 10, SCREENWIDTH - consigneeLabel.mj_max_X - 20, 80)];
    addressTextView.backgroundColor = [UIColor whiteColor];
    addressTextView.font = [UIFont systemFontOfSize:13.];
    addressTextView.keyboardType = UIKeyboardTypeDefault;
    addressTextView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    addressTextView.layer.masksToBounds = YES;
    addressTextView.layer.borderColor = [UIColor buttonDisabledBorderColor].CGColor;
    addressTextView.layer.borderWidth = 0.5f;
    addressTextView.layer.cornerRadius = 5.f;
    addressTextView.delegate = self;
    [secondSectionView addSubview:addressTextView];
    self.addressTextView = addressTextView;
    
    UILabel *placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 8, SCREENWIDTH / 2, 20)];
    placeHolderLabel.text = @"请输入您的详细地址";
    placeHolderLabel.font = [UIFont systemFontOfSize:13.];
    placeHolderLabel.numberOfLines = 0;
    placeHolderLabel.textColor = [UIColor titleDarkGrayColor];
    [placeHolderLabel sizeToFit];
    [addressTextView addSubview:placeHolderLabel];
//    [addressTextView setValue:placeHolderLabel forKey:@"_placeholderLabel"];
    self.placeHolderLabel = placeHolderLabel;
    
    
    CGFloat settingViewH = 40.f;
    if (self.isAdd || self.orderEditAddress) {
        settingViewH = 0.f;
    }else {
        UIView *settingView = [[UIView alloc] initWithFrame:CGRectMake(0, secondSectionView.mj_max_Y + 20, SCREENWIDTH, 40)];
        settingView.backgroundColor = [UIColor whiteColor];
        [self.maskScrollView addSubview:settingView];
        
        UILabel *isSettingLabel = [self createLabelWithFrame:CGRectMake(20, 0, SCREENWIDTH / 2, 40) font:13. textColor:[UIColor buttonTitleColor] text:@"是否设为常用地址"];
        [settingView addSubview:isSettingLabel];
        
        UISwitch *addressSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(SCREENWIDTH - 60, 5, 60, 30)];
        [addressSwitch setOn:NO animated:YES];
        [addressSwitch addTarget:self action:@selector(addressSwitchChange:) forControlEvents:UIControlEventValueChanged];
        [settingView addSubview:addressSwitch];
    }
    
    
    
    UILabel *warningLabel = [self createLabelWithFrame:CGRectMake(20, secondSectionView.mj_max_Y + 20 + settingViewH, SCREENWIDTH - 40, 20) font:14. textColor:[UIColor redColor] text:@""];
    [self.maskScrollView addSubview:warningLabel];
    self.warningLabel = warningLabel;
    
    UIButton *againUpdatabutton = [UIButton buttonWithType:UIButtonTypeCustom];
    againUpdatabutton.frame = CGRectMake(15, warningLabel.mj_max_Y + 10, SCREENWIDTH - 30, 40);
    againUpdatabutton.backgroundColor = [UIColor buttonEnabledBackgroundColor];
    [againUpdatabutton setTitle:@"修改上传身份证信息" forState:UIControlStateNormal];
    [againUpdatabutton setTitle:@"不修改上传身份证信息" forState:UIControlStateSelected];
    [againUpdatabutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    againUpdatabutton.titleLabel.font = [UIFont systemFontOfSize:14.];
    againUpdatabutton.layer.masksToBounds = YES;
    againUpdatabutton.layer.cornerRadius = 20.f;
    againUpdatabutton.selected = NO;
    [againUpdatabutton addTarget:self action:@selector(againUpdatabuttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.maskScrollView addSubview:againUpdatabutton];
    self.againUpdatabutton = againUpdatabutton;
    
    
    CGFloat idcardViewHeiht;
    UIView *idCardView = [UIView new];
    idCardView.frame = CGRectMake(0, againUpdatabutton.mj_max_Y + 10, SCREENWIDTH, 110);
    idCardView.backgroundColor = [UIColor whiteColor];
    [self.maskScrollView addSubview:idCardView];
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
    
    
    [sideFacebutton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(idCardView).offset(10);
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
    
    if (self.cartsPayInfoLevel > 2) {
        // 上传身份证
        if (self.addressLevel > 2) {
            // 已经上传,可以修改
            self.idCardView.hidden = YES;
            self.againUpdatabutton.hidden = NO;
            self.idCardView.cs_h = 0.f;
            self.againUpdatabutton.cs_h = 40;
            self.idCardView.cs_y = self.againUpdatabutton.cs_max_Y + 10;
            idcardViewHeiht = 60.f;
        }else {
            // 没有上传
            self.againUpdatabutton.hidden = YES;
            self.againUpdatabutton.cs_h = 0.f;
            self.idCardView.cs_y = self.againUpdatabutton.cs_max_Y + 10;
            idcardViewHeiht = 130.f;
        }
    }else {
        self.againUpdatabutton.hidden = YES;
        self.idCardView.hidden = YES;
        self.idCardView.cs_h = 0.f;
        self.againUpdatabutton.cs_h = 0.f;
        idcardViewHeiht = 0.f;
    }
    
    
    UIButton *savebutton = [UIButton buttonWithType:UIButtonTypeCustom];
    savebutton.frame = CGRectMake(15, warningLabel.mj_max_Y + 10 + idcardViewHeiht, SCREENWIDTH - 30, 40);
    savebutton.backgroundColor = [UIColor buttonEnabledBackgroundColor];
    [savebutton setTitle:@"保存" forState:UIControlStateNormal];
    [savebutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    savebutton.titleLabel.font = [UIFont systemFontOfSize:14.];
    savebutton.layer.masksToBounds = YES;
    savebutton.layer.cornerRadius = 20.f;
    [savebutton addTarget:self action:@selector(saveAddressInfoClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.maskScrollView addSubview:savebutton];
    self.savebutton = savebutton;
    
    if (self.isAdd) {
    }else {
        if (self.orderEditAddress) {
            NSMutableDictionary *addressDict = [NSMutableDictionary dictionary];
            addressDict = self.orderDict[@"user_adress"];
            self.consigneeField.text = addressDict[@"receiver_name"];
            self.phoneNumField.text = addressDict[@"receiver_mobile"];
            self.addressTextView.text = addressDict[@"receiver_address"];
//            self.idCardField.text = _addressModel.identification_no;
            province = addressDict[@"receiver_state"];
            city = addressDict[@"receiver_city"];
            county = addressDict[@"receiver_district"];
            self.areaField.text = [NSString stringWithFormat:@"%@%@%@",province,city,county];
            
        }else {
            [self createNavRightItem];
            self.consigneeField.text = self.addressModel.receiver_name;
            self.phoneNumField.text = self.addressModel.receiver_mobile;
            self.addressTextView.text = self.addressModel.receiver_address;
            self.idCardField.text = _addressModel.identification_no;
            province = self.addressModel.receiver_state;
            city = self.addressModel.receiver_city;
            county = self.addressModel.receiver_district;
            self.areaField.text = [NSString stringWithFormat:@"%@%@%@",province,city,county];
        }
        
    }
    if (self.addressTextView.text.length > 0) {
        self.placeHolderLabel.hidden = YES;
    }
    
    self.maskScrollView.contentSize = CGSizeMake(SCREENWIDTH, savebutton.mj_max_Y + 20);

}

- (UILabel *)createLabelWithFrame:(CGRect)frame font:(CGFloat)font textColor:(UIColor *)textColor text:(NSString *)text {
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.text = text;
    label.textColor = textColor;
    label.font = [UIFont systemFontOfSize:font];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentLeft;
    return label;
}

- (UITextField *)createTextFieldWithFrame:(CGRect)frame PlaceHolder:(NSString *)placeHolder KeyboardType:(UIKeyboardType)keyboardType {
    UITextField *textField = [[UITextField alloc] initWithFrame:frame];
    textField.placeholder = placeHolder;
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.keyboardType = keyboardType;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.font = [UIFont systemFontOfSize:13.];
    textField.delegate = self;
    return textField;
}

- (void)idcardClick:(UIButton *)button {
    if (button.tag == 10) {
        sideType = @"face";
        [self showActionSheet];
    }else {
        sideType = @"back";
        [self showActionSheet];
    }
}
- (void)againUpdatabuttonClick:(UIButton *)button {
    button.selected = !button.selected;
    if (button.selected) {
        self.idCardView.hidden = NO;
        self.idCardView.cs_h = 110.f;
        self.savebutton.cs_y = self.idCardView.cs_max_Y + 10;
        self.maskScrollView.contentSize = CGSizeMake(SCREENWIDTH, self.savebutton.mj_max_Y + 20);
    }else {
        self.idCardView.hidden = YES;
        self.idCardView.cs_h = 0.f;
        self.savebutton.cs_y = self.idCardView.cs_max_Y + 10;
        self.maskScrollView.contentSize = CGSizeMake(SCREENWIDTH, self.savebutton.mj_max_Y + 20);
        
    }
}

- (void)showActionSheet {
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"去相册选择", nil];
    [sheet showInView:self.view];
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self takePhoto:buttonIndex];
}
#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 1 || alertView.tag == 2) {
        if (buttonIndex == 1) { // 去设置界面，开启相机访问权限
            if (iOS8Later) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
            } else {
                NSURL *privacyUrl;
                if (alertView.tag == 1) {
                    privacyUrl = [NSURL URLWithString:@"prefs:root=Privacy&path=CAMERA"];
                } else {
                    privacyUrl = [NSURL URLWithString:@"prefs:root=Privacy&path=PHOTOS"];
                }
                if ([[UIApplication sharedApplication] canOpenURL:privacyUrl]) {
                    [[UIApplication sharedApplication] openURL:privacyUrl];
                } else {
                    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"抱歉" message:@"无法跳转到隐私设置页面，请手动前往设置页面，谢谢" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                    [alert show];
                }
            }
        }
    }else if (alertView.tag == 3) {
        if (buttonIndex == 0) {
            NSLog(@"取消");
        } else if (buttonIndex == 1){
            [self deleteAddress];
        }
    }else if (alertView.tag == 4) {
        if (buttonIndex == 0) {
        }else {
            self.consigneeField.text = [NSString stringWithFormat:@"%@",idCardName];
            self.idCardField.text = [NSString stringWithFormat:@"%@",idCardNum];
        }
        
    }
        
        
}

#pragma mark - UIImagePickerController
- (void)takePhoto:(NSInteger)index {
    if (index == 0) {
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (authStatus == AVAuthorizationStatusNotDetermined) {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {//相机权限
                if (granted) {
                    NSLog(@"Authorized");
                    [self takePhoto:0];
                }else{
                    NSLog(@"Denied or Restricted");
                    
                }
            }];
        }else if ((authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) && iOS7Later) {
            // 无相机权限 做一个友好的提示
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法使用相机" message:@"请在iPhone的""设置-隐私-相机""中允许访问相机" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
            alert.tag = 1;
            [alert show];
            // 拍照之前还需要检查相册权限
        }else if ([self authorizationStatus] == 0) {
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                if (status == PHAuthorizationStatusAuthorized) {
                    NSLog(@"Authorized");
                    [self diaoyongxiangji:UIImagePickerControllerSourceTypeCamera];
                }else{
                    NSLog(@"Denied or Restricted");
                }
            }];
        }else if ([self authorizationStatus] == 2) { // 已被拒绝，没有相册权限，将无法保存拍的照片
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法访问相册" message:@"请在iPhone的""设置-隐私-相册""中允许访问相册" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
            alert.tag = 2;
            [alert show];
        }else {
            [self diaoyongxiangji:UIImagePickerControllerSourceTypeCamera];
        }
        
    }else if (index == 1) {
        if ([self authorizationStatus] == 0) {
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                if (status == PHAuthorizationStatusAuthorized) {
                    NSLog(@"Authorized");
                    [self diaoyongxiangji:UIImagePickerControllerSourceTypePhotoLibrary];
                }else{
                    NSLog(@"Denied or Restricted");
                }
            }];
        }else if ([self authorizationStatus] == 2) { // 已被拒绝，没有相册权限，将无法保存拍的照片
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法访问相册" message:@"请在iPhone的""设置-隐私-相册""中允许访问相册" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
            alert.tag = 2;
            [alert show];
        }else {
            [self diaoyongxiangji:UIImagePickerControllerSourceTypePhotoLibrary];
        }
        
        
    }else {
        
    }
    
    
    
    
    
    
//    if () {
//        
//        
//    }
//    } else if ([self authorizationStatus] == 0) { // 正在弹框询问用户是否允许访问相册，监听权限状态
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
////            return [self takePhoto];
//            
//        });
//    } else { // 调用相机
//        
//        
//       
//    }
}
- (void)diaoyongxiangji:(UIImagePickerControllerSourceType)type {
    
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    /**
     typedef NS_ENUM(NSInteger, UIImagePickerControllerSourceType) {
     UIImagePickerControllerSourceTypePhotoLibrary, // 相册
     UIImagePickerControllerSourceTypeCamera, // 用相机拍摄获取
     UIImagePickerControllerSourceTypeSavedPhotosAlbum // 相簿
     }
     */
    // 3. 设置打开照片相册类型(显示所有相簿)
    ipc.sourceType = type;
    // ipc.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    // 照相机
    // ipc.sourceType = UIImagePickerControllerSourceTypeCamera;
    ipc.delegate = self;
    [self presentViewController:ipc animated:YES completion:nil];
    
    
    
}


#pragma mark -- <UIImagePickerControllerDelegate>--
// 获取图片后的操作
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    [MBProgressHUD showLoading:@""];
    // 设置图片
    _currentImage = info[UIImagePickerControllerOriginalImage];
    CGFloat whRatio = _currentImage.size.width / _currentImage.size.height;
    NSData *data = [self imageWithImage:_currentImage scaledToSize:CGSizeMake(whRatio * 600, 600)];
    NSString *encodedImageStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"card_base64"] = encodedImageStr;
    param[@"side"] = sideType;
    NSString *string = [NSString stringWithFormat:@"%@/rest/v2/ocr/idcard_indentify", Root_URL];
    [JMHTTPManager requestWithType:RequestTypePOST WithURLString:string WithParaments:param WithSuccess:^(id responseObject) {
        NSLog(@"%@",responseObject);
        [self fetchWithData:responseObject];
    } WithFail:^(NSError *error) {
        [MBProgressHUD showError:@"上传失败,请稍后重试"];
    } Progress:^(float progress) {
    }];
}
- (void)fetchWithData:(NSDictionary *)response {
    if ([response[@"code"] integerValue] == 0) {
        NSDictionary *dict = response[@"card_infos"];
        NSString *sideStr = [NSString stringWithFormat:@"%@",dict[@"side"]];
        if ([sideStr isEqualToString:@"back"]) {
            sideBack = dict[@"card_imgpath"];
            _sideBackImage.image = _currentImage;
            [_sideBackImage mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.height.mas_equalTo(@(70));
            }];
            _sideBackLabel.hidden = YES;
        }else {
            _sideFaceImage.image = _currentImage;
            [_sideFaceImage mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.height.mas_equalTo(@(70));
            }];
            _sideFaceLabel.hidden = YES;
            sideFace = dict[@"card_imgpath"];
            idCardNum = [NSString stringWithFormat:@"%@",dict[@"num"]];
            idCardName = dict[@"name"];
            if (![self.consigneeField.text isEqual:idCardName] || ![self.idCardField.text isEqual:idCardNum]) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您上传的身份证信息与当前收货人信息不同,是否修改。(建议手动填写)\n 确定:点击修改; 取消:手动修改" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                alertView.tag = 4;
                [alertView show];
            }
            
            
        }
        [MBProgressHUD hideHUD];
    }else {
        [MBProgressHUD showWarning:response[@"info"]];
    }
    
}
//[_selectedPhotos addObject:newImage];
- (NSData *)imageWithImage:(UIImage*)image
              scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return UIImageJPEGRepresentation(newImage, 0.7);
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    if ([picker isKindOfClass:[UIImagePickerController class]]) {
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}


- (NSInteger)authorizationStatus {
    if (iOS8Later) {
        return [PHPhotoLibrary authorizationStatus];
    } else {
        return [ALAssetsLibrary authorizationStatus];
    }
    return NO;
}

#pragma mark 代理实现
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    self.warningLabel.text = @"";
    if (textField == self.areaField) {
        [self.consigneeField resignFirstResponder];
        [self.phoneNumField resignFirstResponder];
        [self.idCardField resignFirstResponder];
        [self.addressTextView resignFirstResponder];
        [self.selectView show];
        return NO;
    }else {
        return YES;
    }
}
- (void)textViewDidChange:(UITextView *)textView {
    if (!textView.text.length) {
        self.placeHolderLabel.hidden = NO;
    }else {
        self.placeHolderLabel.hidden = YES;
    }
}

#pragma mark 自定义点击事件
- (void)addressSwitchChange:(UISwitch *)addressSwitch {
    if (addressSwitch.on) {
        if (self.addressModel.addressID != nil) {
            [MBProgressHUD showLoading:@""];
            NSString *string = [NSString stringWithFormat:@"%@/rest/v1/address/%@/change_default", Root_URL, self.addressModel.addressID];
            [JMHTTPManager requestWithType:RequestTypePOST WithURLString:string WithParaments:nil WithSuccess:^(id responseObject) {
                NSLog(@"%@",responseObject);
                [MBProgressHUD hideHUD];
            } WithFail:^(NSError *error) {
                [MBProgressHUD hideHUD];
            } Progress:^(float progress) {
            }];
        }
        NSLog(@"打开");
    }else {
        NSLog(@"关闭");
    }
}
- (void)saveAddressInfoClick:(UIButton *)button {
    NSLog(@"收货人%@ \n  手机号 %@ \n  详细地址%@ ",self.consigneeField.text,self.phoneNumField.text,self.addressTextView.text);
    if ([NSString isStringEmpty:self.consigneeField.text]) {
        self.warningLabel.text = @"请填写收货人姓名";
        return ;
    }
    if ([NSString isStringEmpty:self.phoneNumField.text]) {
        self.warningLabel.text = @"请填写手机号码";
        return ;
    }else {
        if (self.phoneNumField.text.length != 11  || ![NSString isStringWithNumber:self.phoneNumField.text]) {
            self.warningLabel.text = @"请填写正确的手机号码";
            return ;
        }
    }
    if (self.cartsPayInfoLevel > 1) {
        if ([NSString isStringEmpty:self.idCardField.text]) {
            self.warningLabel.text = @"请填写身份证号";
            return ;
        }
        if (![[JMGlobal global] validateIdentityCard:self.idCardField.text]) {
            self.warningLabel.text = @"请检查身份证号";
            return ;
        }
    }
    if ([NSString isStringEmpty:self.areaField.text]) {
        self.warningLabel.text = @"请选择所在地区";
        return ;
    }
    if ([NSString isStringEmpty:self.addressTextView.text]) {
        self.warningLabel.text = @"请填写详细地址";
        return ;
    }
    if (self.cartsPayInfoLevel > 2 && self.addressLevel < 3) {
        if ([NSString isStringEmpty:sideFace] && [NSString isStringEmpty:sideBack]) {
            self.warningLabel.text = @"请上传身份证信息";
            return ;
        }
    }
    NSMutableDictionary *parame = [self parame];
    if (self.isAdd) {
        NSString *string = [NSString stringWithFormat:@"%@/rest/v1/address/create_address?format=json", Root_URL];
        [JMHTTPManager requestWithType:RequestTypePOST WithURLString:string WithParaments:parame WithSuccess:^(id responseObject) {
            NSInteger code = [responseObject[@"code"] integerValue];
            if (code == 0) {
                [self.navigationController popViewControllerAnimated:YES];
            }else {
                [MBProgressHUD showWarning:responseObject[@"info"]];
            }
        } WithFail:^(NSError *error) {
            [MBProgressHUD showWarning:@"添加地址失败,请重新添加"];
        } Progress:^(float progress) {
            
        }];
    }else {
        parame[@"id"] = [NSString isStringEmpty:addressID] ? self.addressModel.addressID : addressID;
        NSString *modifyUrlStr = [NSString stringWithFormat:@"%@/rest/v1/address/%@/update", Root_URL,parame[@"id"]];
        [JMHTTPManager requestWithType:RequestTypePOST WithURLString:modifyUrlStr WithParaments:parame WithSuccess:^(id responseObject) {
            NSInteger code = [responseObject[@"code"] integerValue];
            if (code == 0) {
                [self.navigationController popViewControllerAnimated:YES];
            }else {
                [MBProgressHUD showWarning:responseObject[@"info"]];
            }
            
        } WithFail:^(NSError *error) {
            [MBProgressHUD showWarning:@"修改地址失败,请重新修改"];
        } Progress:^(float progress) {
            
        }];

        
        
    }
}
- (NSMutableDictionary *)parame {
    NSMutableDictionary *parame = [NSMutableDictionary dictionary];
    parame[@"receiver_state"] = province;
    parame[@"receiver_city"] = city;
    parame[@"receiver_district"] = county;
    parame[@"receiver_address"] = self.addressTextView.text;
    parame[@"receiver_name"] = self.consigneeField.text;
    parame[@"receiver_mobile"] = self.phoneNumField.text;
    if (self.cartsPayInfoLevel > 1) {
        parame[@"identification_no"] = self.idCardField.text;
    }
    if (self.cartsPayInfoLevel > 2) {
        if (![NSString isStringEmpty:sideFace]) {
            parame[@"card_facepath"] = sideFace;
        }
        if (![NSString isStringEmpty:sideBack]) {
            parame[@"card_backpath"] = sideBack;
        }
    }
    if (self.orderEditAddress) {
        parame[@"logistic_company_code"] = [NSNull null];
        parame[@"referal_trade_id"] = self.orderDict[@"id"];
    }
    return parame;
}
// 删除地址事件
- (void)rightNavigationClick:(UIButton *)button {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"确定要删除吗?" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.tag = 3;
    [alertView show];
}

- (void)hideKeyBoard:(UITapGestureRecognizer *)tap {
    [self.view endEditing:YES];
}
#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    // 输出点击的view的类名
    NSLog(@"%@", NSStringFromClass([touch.view class]));
    // 若为UITableViewCellContentView（即点击了tableViewCell），则不截获Touch事件
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UIImageView"]) {
        return NO;
    }
    return  YES;
}
- (void)backClick {
    [self.navigationController popViewControllerAnimated:YES];
}







@end




















