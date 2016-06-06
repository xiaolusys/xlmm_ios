//
//  JMReturnedGoodsController.m
//  XLMM
//
//  Created by 崔人帅 on 16/6/6.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMReturnedGoodsController.h"
#import "JMReGoodsAddView.h"
#import "Masonry.h"
#import "MMClass.h"
#import "JMSelecterButton.h"
#import "UIColor+RGBColor.h"
#import "JMChooseLogisticsController.h"

@interface JMReturnedGoodsController ()<JMChooseLogisticsControllerDelegate>

@property (nonatomic,strong) JMReGoodsAddView *reGoodsV;
/**
 *  快递公司
 */
@property (nonatomic,strong) UIButton *expressBtn;
@property (nonatomic,strong) UILabel *expressL;
@property (nonatomic,strong) UIImageView *expressImageV;
/**
 *  快递单号
 */
@property (nonatomic,strong) UITextField *expressListTF;
/**
 *  确定按钮
 */
@property (nonatomic,strong) JMSelecterButton *sureButton;

@end

@implementation JMReturnedGoodsController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createUI];
    
    
}


- (void)createUI {
    kWeakSelf
    JMReGoodsAddView *reGoodsV = [JMReGoodsAddView new];
    [self.view addSubview:reGoodsV];
    self.reGoodsV =reGoodsV;
    
    [self.reGoodsV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(weakSelf.view);
        make.width.mas_equalTo(SCREENWIDTH);
        make.height.mas_equalTo(@380);
    }];
    
    UIButton *expressBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:expressBtn];
    self.expressBtn = expressBtn;
    [self.expressBtn addTarget:self action:@selector(choiseClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.expressBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.reGoodsV.mas_bottom);
        make.left.right.equalTo(weakSelf.view);
        make.height.mas_equalTo(@60);
    }];
    
    UILabel *expressL = [UILabel new];
    [self.expressBtn addSubview:expressL];
    self.expressL = expressL;
    self.expressL.text = @"请选择快递公司";
    self.expressL.textColor = [UIColor titleDarkGrayColor];
    
    [self.expressL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.expressBtn.mas_centerY);
        make.left.equalTo(weakSelf.expressBtn).offset(10);
    }];
    
    UIImageView *expressImageV = [UIImageView new];
    [self.expressBtn addSubview:expressImageV];
    self.expressImageV = expressImageV;
    self.expressImageV.image = [UIImage imageNamed:@"rightArrow"];
    
    [self.expressImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.expressBtn.mas_centerY);
        make.right.equalTo(weakSelf.expressBtn).offset(-15);
        make.height.mas_equalTo(@30);
        make.width.mas_equalTo(@20);
    }];
    
    UITextField *expressListTF = [UITextField new];
    [self.view addSubview:expressListTF];
    self.expressListTF = expressListTF;
    self.expressListTF.placeholder = @"点击输入快递单号";
    self.expressListTF.textColor = [UIColor titleDarkGrayColor];
    
    [self.expressListTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.expressBtn.mas_bottom);
        make.left.right.equalTo(weakSelf.view);
        make.height.mas_equalTo(@60);
    }];
    
    JMSelecterButton *sureButton = [JMSelecterButton buttonWithType:UIButtonTypeCustom];
    [sureButton setSelecterBorderColor:[UIColor buttonEnabledBackgroundColor] TitleColor:[UIColor whiteColor] Title:nil TitleFont:0. CornerRadius:20];
    [self.view addSubview:sureButton];
    self.sureButton = sureButton;
    [self.sureButton addTarget:self action:@selector(sureButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.expressListTF.mas_bottom).offset(20);
        make.left.equalTo(weakSelf.view).offset(15);
        make.width.mas_equalTo(SCREENWIDTH - 30);
        make.height.mas_equalTo(@40);
    }];
    
    
    
    
}
- (void)choiseClick:(UIButton *)btn {
    JMChooseLogisticsController *logisticsVC = [[JMChooseLogisticsController alloc] init];
    logisticsVC.delegate = self;
    [self.navigationController pushViewController:logisticsVC animated:YES];

}
- (void)ClickChoiseLogis:(JMChooseLogisticsController *)click Title:(NSString *)title {
    
    self.expressL.text = title;
}
- (void)sureButtonClick:(UIButton *)btn {

    [self.navigationController popViewControllerAnimated:YES];
    
}




@end









































