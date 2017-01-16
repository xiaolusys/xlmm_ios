//
//  RefundDetailsViewController.m
//  XLMM
//
//  Created by younishijie on 15/11/26.
//  Copyright © 2015年 上海己美. All rights reserved.
//

#import "RefundDetailsViewController.h"
#import "JMReturnedGoodsController.h"
#import "JMTimeLineView.h"
#import "JMRefundModel.h"
#import "JMSelecterButton.h"
#import "JMReturnProgressController.h"


@interface RefundDetailsViewController (){
    UIView *backView;
    
    
}


@property (weak, nonatomic) IBOutlet UILabel *bianhaoLabel;
@property (weak, nonatomic) IBOutlet UILabel *displayLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *sizeLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UIView *circleView;
@property (weak, nonatomic) IBOutlet UILabel *modifyTimeLabel;

@property (weak, nonatomic) IBOutlet UILabel *refundPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *reasonLabel;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UIView *detailsView;

@property (weak, nonatomic) IBOutlet UILabel *createTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@property (weak, nonatomic) IBOutlet UILabel *createdLabel;

@property (nonatomic, strong) JMSelecterButton *refundOperateButton;

@property (nonatomic, copy) NSString *afterServiceLabel;
@property (nonatomic, copy) NSString *addressLabel;

@end

@implementation RefundDetailsViewController {
    BOOL _isChoiseLogistics;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [MobClick beginLogPageView:@"RefundDetailsViewController"];
    
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
    [MobClick endLogPageView:@"RefundDetailsViewController"];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self createNavigationBarWithTitle:@"退货(款)详情" selecotr:@selector(backClicked:)];
    [self setHeadInfo];
    [self setFootInfo];
    self.addressInfoButton.layer.cornerRadius = 13;
    self.addressInfoButton.layer.borderWidth = 0.5;
    self.addressInfoButton.layer.borderColor = [UIColor buttonEmptyBorderColor
                                                ].CGColor;
    self.headViewWidth.constant = SCREENWIDTH;
    backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
    backView.backgroundColor = [UIColor blackColor];
    backView.alpha = 0.5;
    backView.hidden = YES;
    
    [self.view addSubview:backView];
    
    //没有订单号显示填写退货地址
    if (self.refundModelr.sid.length == 0 || [self.refundModelr.sid isEqualToString:@""]) {
//        self.topToRefundHeight.constant = 0;
    }
    _isChoiseLogistics = ((self.refundModelr.sid.length != 0) && (self.refundModelr.company_name.length != 0));
    
    NSLog(@"return status=%ld good_status=%ld address=%@", (long)self.refundModelr.status, [self.refundModelr.good_status integerValue], self.refundModelr.return_address);
    [self createShowRefundView];
    [self timeLine];
}
- (void)createShowRefundView {
    UIView *currentView = [UIView new];
    [self.showRefundView addSubview:currentView];
    currentView.backgroundColor = [UIColor lineGrayColor];
    
    UIView *refundInfoView = [UIView new];
    [self.showRefundView addSubview:refundInfoView];
    refundInfoView.backgroundColor = [UIColor whiteColor];
    refundInfoView.layer.borderWidth = 1.;
    refundInfoView.layer.borderColor = [UIColor lineGrayColor].CGColor;
    
    UILabel *afterServiceLabel = [UILabel new];
    [refundInfoView addSubview:afterServiceLabel];
    afterServiceLabel.text = self.afterServiceLabel;
    afterServiceLabel.textColor = [UIColor buttonTitleColor];
    afterServiceLabel.font = [UIFont systemFontOfSize:13.];
    
    UILabel *addressLabel = [UILabel new];
    [refundInfoView addSubview:addressLabel];
    addressLabel.userInteractionEnabled = YES;
    addressLabel.textColor = [UIColor buttonEnabledBackgroundColor];
    addressLabel.font = [UIFont systemFontOfSize:12.];
    addressLabel.text = self.addressLabel;
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addressInfoTap:)];
    [addressLabel addGestureRecognizer:tap];
    
    [refundInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.showRefundView);
        make.height.mas_equalTo(@75);
    }];
    [currentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(refundInfoView.mas_bottom);
        make.left.right.equalTo(self.showRefundView);
        make.height.mas_equalTo(@17);
    }];
    [afterServiceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(refundInfoView).offset(15);
        make.top.equalTo(refundInfoView).offset(15);
        make.width.mas_equalTo(@(SCREENWIDTH - 120));
    }];
    [addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(refundInfoView).offset(15);
        make.top.equalTo(afterServiceLabel.mas_bottom).offset(10);
        make.width.mas_equalTo(@(SCREENWIDTH - 120));
    }];
    
    NSInteger statusCount = [self.refundModelr.status integerValue];
    NSString *buttonTitle = @"";
    self.refundOperateButton = [[JMSelecterButton alloc] init];
    
    if (statusCount == REFUND_STATUS_SELLER_AGREED) {
        buttonTitle = @"填写快递单";
    }else if (statusCount == REFUND_STATUS_REFUND_SUCCESS) {
        buttonTitle = @"已验收";
    }else {
        buttonTitle = @"查看进度";
    }
    [self.refundOperateButton setSelecterBorderColor:[UIColor buttonEnabledBackgroundColor] TitleColor:[UIColor buttonEnabledBackgroundColor] Title:buttonTitle TitleFont:13. CornerRadius:15];
    [refundInfoView addSubview:self.refundOperateButton];
    [self.refundOperateButton addTarget:self action:@selector(refundOperateClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.refundOperateButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(refundInfoView).offset(-15);
        make.centerY.equalTo(refundInfoView.mas_centerY);
        make.width.mas_equalTo(@90);
        make.height.mas_equalTo(@30);
    }];
}
- (void)addressInfoTap:(UITapGestureRecognizer *)tap {
    NSLog(@"退货地址信息");
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"RefundAddressInfoView" owner:nil options:nil];
    UIView *infoView = views[0];
    infoView.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT);
    UIView *bgView = [infoView viewWithTag:100];
    bgView.layer.cornerRadius = 10;
    
    self.navigationController.navigationBarHidden = YES;
    backView.hidden = NO;
    backView.alpha = 0.6;
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeInfoView:)];
    [infoView addGestureRecognizer:tap1];
    
    UILabel *addressLabel = [infoView viewWithTag:500];
    UIButton *kefuButton = [infoView viewWithTag:800];
    [kefuButton addTarget:self action:@selector(lianxikefu:) forControlEvents:UIControlEventTouchUpInside];
    
    addressLabel.text = self.refundModelr.return_address;
    
    [self.view addSubview:infoView];
    

}
- (void)setHeadInfo{
    self.bianhaoLabel.text = self.refundModelr.refund_no;

    self.displayLabel.text = self.refundModelr.status_display;
    self.titleLabel.text = self.refundModelr.title;
    self.sizeLabel.text = self.refundModelr.sku_name;
    self.priceLabel.text = [NSString stringWithFormat:@"¥%.2f", [self.refundModelr.payment floatValue]];
    NSInteger refundNum = [self.refundModelr.refund_num integerValue];
    self.numberLabel.text = [NSString stringWithFormat:@"%ld", refundNum];
    self.refundPriceLabel.text = [NSString stringWithFormat:@"¥%.2f", [self.refundModelr.refund_fee floatValue]];
    
    
    self.reasonLabel.text = self.refundModelr.reason;
    if ([self.refundModelr.pic_path isKindOfClass:[NSString class]] ) {
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:[[self.refundModelr.pic_path imageGoodsOrderCompression] JMUrlEncodedString]]];
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    self.imageView.layer.masksToBounds = YES;
    self.imageView.layer.cornerRadius = 5;
    self.imageView.layer.borderWidth = 0.5;
    self.imageView.layer.borderColor = [UIColor buttonDisabledBorderColor].CGColor;
    self.circleView.layer.cornerRadius = 5;
    if ([self.refundModelr.has_good_return integerValue] == 0) {
        self.createdLabel.text = @"申请退款";
    }else{
        self.createdLabel.text = @"申请退货";
        NSInteger statusCount = [self.refundModelr.status integerValue];
        if(statusCount >= REFUND_STATUS_SELLER_AGREED){
            self.topToRefundHeight.constant = 0;
        }else {
            self.topToRefundHeight.constant = -90;
        }
    }
    
    self.statusLabel.text = self.refundModelr.status_display;
    self.createTimeLabel.text = [NSString jm_deleteTimeWithT:self.refundModelr.created];
    self.modifyTimeLabel.text = [NSString jm_deleteTimeWithT:self.refundModelr.modified];
    
//    NSString *douhaoStr = @"，";
    NSString *addressStr = self.refundModelr.return_address;
    if ([addressStr rangeOfString:@"，"].location != NSNotFound) {
        NSArray *arr = [self.refundModelr.return_address componentsSeparatedByString:@"，"];
        NSString *addStr = @"";
        NSString *nameStr = @"";
        NSString *phoneStr = @"";
        if (arr.count > 0) {
            addStr = arr[0];
            nameStr = arr[2];
            phoneStr = arr[1];
            self.afterServiceLabel = [NSString stringWithFormat:@"%@  %@",nameStr,phoneStr];
            self.addressLabel = addStr;
        }else {
//            return ;
        }

    }else {
        self.afterServiceLabel = @"小鹿售后  021-50939326";
        self.addressLabel = @"收货地址: 上海杨市松江区佘山镇吉业路245号5号楼";
    }
    
    
    
}
- (void)setFootInfo{
    //设置详情信息。。。。
}
- (void)backClicked:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)lianxikefu:(UIButton *)button{

}
- (void)removeInfoView:(UIGestureRecognizer *)recognizer{
//    NSLog(@"move");
    backView.hidden = YES;
    self.navigationController.navigationBarHidden = NO;
    [recognizer.view removeFromSuperview];
    
}
- (void)refundOperateClick:(UIButton *)button {
    if (_isChoiseLogistics) {
        JMReturnProgressController *progressVC = [[JMReturnProgressController alloc] init];
        progressVC.refundModelr = self.refundModelr;
        [self.navigationController pushViewController:progressVC animated:YES];
    }else {
        JMReturnedGoodsController *reGoodsVC = [[JMReturnedGoodsController alloc] init];
        reGoodsVC.refundModelr = self.refundModelr;
        
        [self.navigationController pushViewController:reGoodsVC animated:YES];
    }
    
    
    
}


- (void)timeLine {
    NSInteger countNum = [self.refundModelr.status integerValue];
    NSArray *desArr = [NSArray array];
    NSInteger count = 0;
    int i = 0;
    if (countNum == REFUND_STATUS_REFUND_CLOSE || countNum == REFUND_STATUS_SELLER_REJECTED || countNum == REFUND_STATUS_NO_REFUND) {
        NSString *str = self.refundModelr.status_display;
        if (self.refundModelr.has_good_return == 0) {
            //            self.createdLabel.text = @"申请退款";
            desArr = @[@"申请退款",str];
        }else{
            //            self.createdLabel.text = @"申请退货";
            desArr = @[@"申请退货",str];
        }
        
        count = desArr.count;
    }else {
        if ([self.refundModelr.has_good_return integerValue] == 0) {
//            self.createdLabel.text = @"申请退款";
            desArr = @[@"申请退款",@"同意申请",@"等待返款",@"退款成功"];
            countNum -= 3;
            for (i = 0; i < desArr.count; i++) {
                if (countNum == i) {
                    if (countNum >= 2) {
                        i-- ;
                    }
                    break ;
                }else {
                    continue ;
                }
            }
            count = i + 1;
        }else{
            desArr = @[@"申请退货",@"同意申请",@"填写快递单",@"仓库收货",@"等待返货",@"退货成功"];//退货待收
            countNum -= 3;
            for (i = 0; i < desArr.count; i++) {
                if (countNum == i) {
                    if (countNum >= 2) {
                        i++;
                    }
                    break ;
                }else {
                    continue ;
                }
            }
            count = i + 1;
            self.createdLabel.text = @"申请退货";
        }
    }
    

    JMTimeLineView *timeLineV = [[JMTimeLineView alloc] initWithTimeArray:nil andTimeDesArray:desArr andCurrentStatus:count andFrame:self.timeLineView.frame];
    timeLineV.backgroundColor = [UIColor lineGrayColor];
    [self.timeLineView addSubview:timeLineV];
    
    self.timeLineView.contentSize = CGSizeMake(70 * desArr.count, 60);
    self.timeLineView.showsHorizontalScrollIndicator = NO;


}



@end

/**
 
 //
 //
 //
 //    NSString *desStr = self.model.status_display;
 //    for (i = 0; i < desArr.count; i++) {
 //        if ([desStr isEqualToString:desArr[i]]) {
 //            break ;
 //        }else {
 //            continue ;
 //        }
 //    }
 //    count = i + 1;
 *  #define REFUND_STATUS_NO_REFUND  0
 #define REFUND_STATUS_BUYER_APPLY  3
 #define REFUND_STATUS_SELLER_AGREED  4
 #define REFUND_STATUS_BUYER_RETURNED_GOODS  5
 #define REFUND_STATUS_REFUND_CLOSE  1
 #define REFUND_STATUS_SELLER_REJECTED  2
 #define REFUND_STATUS_WAIT_RETURN_FEE  6
 #define REFUND_STATUS_REFUND_SUCCESS 7
 */






















