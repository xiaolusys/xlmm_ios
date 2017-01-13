//
//  JMRefundDetailController.m
//  XLMM
//
//  Created by zhang on 16/12/21.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMRefundDetailController.h"
#import "JMRefundBaseCell.h"
#import "JMGeneralCell.h"
#import "JMTimeLineView.h"
#import "JMSelecterButton.h"
#import "JMReturnProgressController.h"
#import "JMReturnedGoodsController.h"


@interface JMRefundDetailController () <UITableViewDataSource,UITableViewDelegate> {
    NSArray *generalArr;
//    BOOL _isChoiseLogistics;
    UIView *backView;
    BOOL _isjihuishangpin;
    BOOL _tianxiekuandidan;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIScrollView *timeLineView;
@property (nonatomic, strong) JMSelecterButton *refundOperateButton;

@end

@implementation JMRefundDetailController

- (void)setRefundModelr:(JMRefundModel *)refundModelr {
    _refundModelr = refundModelr;
//     = ((self.refundModelr.sid.length != 0) && (self.refundModelr.company_name.length != 0));
//    if (![NSString isStringEmpty:self.refundModelr.sid] && ![NSString isStringEmpty:self.refundModelr.company_name]) {
//        _isChoiseLogistics = YES;
//    }else {
//        _isChoiseLogistics = NO;
//    }
    
    NSInteger status = [refundModelr.status integerValue];
    NSInteger goodsSatus = [refundModelr.good_status integerValue];
    if (status == REFUND_STATUS_SELLER_AGREED && goodsSatus == 1 && [self.refundModelr.has_good_return boolValue]) {
        _tianxiekuandidan = YES;
    }else {
        _tianxiekuandidan = NO;
    }
    if (status >= REFUND_STATUS_SELLER_AGREED && (goodsSatus == 1 || goodsSatus == 2) && [self.refundModelr.has_good_return boolValue]) {
        _isjihuishangpin = YES;
    }else {
        _isjihuishangpin = NO;
    }
    
    NSString *refundPrice = [NSString stringWithFormat:@"¥%.2f", [self.refundModelr.refund_fee floatValue]];
    generalArr = @[@{@"title":@"申请数量",@"descTitle":refundModelr.refund_num},
                   @{@"title":@"可退金额",@"descTitle":refundPrice},
                   @{@"title":@"退款原因",@"descTitle":refundModelr.reason}];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"RefundDetailsViewController"];
    
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"RefundDetailsViewController"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self createNavigationBarWithTitle:@"退货(款)详情" selecotr:@selector(backClicked:)];
    
    
    [self createTabelView];
    [self createFootView];
    [self timeLine];
    
    backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
    backView.backgroundColor = [UIColor blackColor];
    backView.alpha = 0.5;
    backView.hidden = YES;
    [self.view addSubview:backView];
 
}

- (void)createTabelView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT - 64) style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor countLabelColor];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[JMRefundBaseCell class] forCellReuseIdentifier:JMRefundBaseCellIdentifier];
    [self.tableView registerClass:[JMGeneralCell class] forCellReuseIdentifier:JMGeneralCellIdentifier];
    
    self.timeLineView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 60)];
    self.tableView.tableHeaderView = self.timeLineView;
    
    
}
- (void)createFootView {
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 120)];
    self.tableView.tableFooterView = footView;
    footView.backgroundColor = [UIColor whiteColor];
    
    UIImageView *oneImage = [UIImageView new];
    oneImage.image = [UIImage imageNamed:@"refundSuccessful"];
    [footView addSubview:oneImage];
    
    UILabel *shuxian = [UILabel new];
    shuxian.backgroundColor = [UIColor buttonEnabledBackgroundColor];
    [footView addSubview:shuxian];
    
    UILabel *yuandian = [UILabel new];
    yuandian.backgroundColor = [UIColor buttonEnabledBackgroundColor];
    yuandian.layer.masksToBounds = YES;
    yuandian.layer.cornerRadius = 5;
    [footView addSubview:yuandian];
    
    UILabel *oneTime = [UILabel new];
    oneTime.font = [UIFont systemFontOfSize:12.];
    oneTime.textColor = [UIColor buttonEnabledBackgroundColor];
    [footView addSubview:oneTime];
    
    UILabel *onetitle = [UILabel new];
    onetitle.font = [UIFont systemFontOfSize:14.];
    onetitle.textColor = [UIColor buttonEnabledBackgroundColor];
    [footView addSubview:onetitle];
    
    UILabel *twoTime = [UILabel new];
    twoTime.font = [UIFont systemFontOfSize:12.];
    twoTime.textColor = [UIColor dingfanxiangqingColor];
    [footView addSubview:twoTime];
    
    UILabel *twoTitle = [UILabel new];
    twoTitle.font = [UIFont systemFontOfSize:14.];
    twoTitle.textColor = [UIColor buttonTitleColor];
    [footView addSubview:twoTitle];
    
    [oneImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(footView).offset(10);
        make.width.height.mas_equalTo(@20);
    }];
    [shuxian mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(oneImage.mas_bottom);
        make.centerX.equalTo(oneImage.mas_centerX);
        make.width.mas_equalTo(@1);
        make.height.mas_equalTo(@50);
    }];
    [yuandian mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(shuxian.mas_bottom);
        make.centerX.equalTo(oneImage.mas_centerX);
        make.width.height.mas_equalTo(@10);
    }];
    [oneTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(oneImage.mas_right).offset(15);
        make.centerY.equalTo(oneImage.mas_centerY);
    }];
    [onetitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(oneTime);
        make.top.equalTo(oneTime.mas_bottom).offset(3);
    }];
    
    [twoTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(oneTime);
        make.centerY.equalTo(yuandian.mas_centerY);
    }];
    [twoTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(oneTime);
        make.top.equalTo(twoTime.mas_bottom).offset(3);
    }];
    
    oneTime.text = [NSString jm_deleteTimeWithT:self.refundModelr.modified];
    twoTime.text = [NSString jm_deleteTimeWithT:self.refundModelr.created];
    onetitle.text = self.refundModelr.status_display;
    if ([self.refundModelr.has_good_return integerValue] == 0) {
        twoTitle.text = @"申请退款";
    }else {
        twoTitle.text = @"申请退货";
    }
    
    
    
    
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }else if (section == 1) {
        return 3;
    }else {
        return 0;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 110;
    }else if (indexPath.section == 1) {
        return 45;
    }else {
        return 0;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        JMRefundBaseCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (!cell) {
            cell = [[JMRefundBaseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:JMRefundBaseCellIdentifier];
        }
        [cell configRefundDetail:self.refundModelr];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (indexPath.section == 1) {
        JMGeneralCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (!cell) {
            cell = [[JMGeneralCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:JMGeneralCellIdentifier];
        }
        NSDictionary *dic = generalArr[indexPath.row];
        cell.titleLabel.text = dic[@"title"];
        cell.descTitleLabel.text = dic[@"descTitle"];
        if (indexPath.row == 1) {
            cell.descTitleLabel.textColor = [UIColor buttonEnabledBackgroundColor];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else {
        return nil;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 45;
    }else if (section == 1) {
        if (_isjihuishangpin) {
            return 90;
        }else {
            return 0;
        }
    }else {
        return 15;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        UIView *sectionOneView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 45)];
        sectionOneView.backgroundColor = [UIColor whiteColor];
        UILabel *tuikuanBianhao = [UILabel new];
        [sectionOneView addSubview:tuikuanBianhao];
        tuikuanBianhao.textColor = [UIColor buttonTitleColor];
        tuikuanBianhao.font = [UIFont systemFontOfSize:14.];
        tuikuanBianhao.text = @"退款编号";
        
        UILabel *bianhao = [UILabel new];
        [sectionOneView addSubview:bianhao];
        bianhao.textColor = [UIColor dingfanxiangqingColor];
        bianhao.font = [UIFont systemFontOfSize:14.];
        bianhao.text = self.refundModelr.refund_no;
        
        UILabel *tuikuanStatus = [UILabel new];
        [sectionOneView addSubview:tuikuanStatus];
        tuikuanStatus.textColor = [UIColor buttonEnabledBackgroundColor];
        tuikuanStatus.font = [UIFont systemFontOfSize:14.];
        tuikuanStatus.text = self.refundModelr.status_display;
        
        [tuikuanBianhao mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(sectionOneView.mas_centerY);
            make.left.equalTo(sectionOneView).offset(10);
        }];
        [bianhao mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(tuikuanBianhao.mas_centerY);
            make.left.equalTo(tuikuanBianhao.mas_right).offset(10);
        }];
        [tuikuanStatus mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(tuikuanBianhao.mas_centerY);
            make.right.equalTo(sectionOneView).offset(-10);
        }];
        
        return sectionOneView;
    }else if (section == 1) {
        if (_isjihuishangpin) {
            UIView *sectionTwo = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 90)];
            
            UIView *currentView = [UIView new];
            [sectionTwo addSubview:currentView];
            currentView.backgroundColor = [UIColor lineGrayColor];
            
            UIView *refundInfoView = [UIView new];
            [sectionTwo addSubview:refundInfoView];
            refundInfoView.backgroundColor = [UIColor whiteColor];
            refundInfoView.layer.borderWidth = 1.;
            refundInfoView.layer.borderColor = [UIColor lineGrayColor].CGColor;
            
            UILabel *afterServiceLabel = [UILabel new];
            [refundInfoView addSubview:afterServiceLabel];
//            afterServiceLabel.text = self.afterServiceLabel;
            afterServiceLabel.textColor = [UIColor buttonTitleColor];
            afterServiceLabel.font = [UIFont systemFontOfSize:13.];
            
            UILabel *addressLabel = [UILabel new];
            [refundInfoView addSubview:addressLabel];
            addressLabel.userInteractionEnabled = YES;
            addressLabel.textColor = [UIColor buttonEnabledBackgroundColor];
            addressLabel.font = [UIFont systemFontOfSize:12.];
//            addressLabel.text = self.addressLabel;
            
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addressInfoTap:)];
            [addressLabel addGestureRecognizer:tap];
            
            [refundInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.left.right.equalTo(sectionTwo);
                make.height.mas_equalTo(@75);
            }];
            [currentView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(refundInfoView.mas_bottom);
                make.left.right.equalTo(sectionTwo);
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
                    afterServiceLabel.text = [NSString stringWithFormat:@"%@  %@",nameStr,phoneStr];
                    addressLabel.text = addStr;
                }else {
                    //            return ;
                }
                
            }else {
                afterServiceLabel.text = @"小鹿售后  021-50939326";
                addressLabel.text = @"收货地址: 上海杨市松江区佘山镇吉业路245号5号楼";
            }

            
            
            
            return sectionTwo;
        }else {
            UIView *sectionTwo = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 0)];
            return sectionTwo;
        }
    }else {
        UIView *sectionThree = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 15)];
        sectionThree.backgroundColor = [UIColor lineGrayColor];
        return sectionThree;
    }
}

- (void)refundOperateClick:(UIButton *)button {
    if (_tianxiekuandidan) {
        JMReturnedGoodsController *reGoodsVC = [[JMReturnedGoodsController alloc] init];
        reGoodsVC.refundModelr = self.refundModelr;
        [self.navigationController pushViewController:reGoodsVC animated:YES];
    }else {
        JMReturnProgressController *progressVC = [[JMReturnProgressController alloc] init];
        progressVC.refundModelr = self.refundModelr;
        [self.navigationController pushViewController:progressVC animated:YES];

    }
    
    
    

    
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
            desArr = @[@"申请退货",@"同意申请",@"填写快递单",@"仓库收货",@"等待返款",@"退货成功"];//退货待收
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
//            self.createdLabel.text = @"申请退货";
        }
    }
    
    
    JMTimeLineView *timeLineV = [[JMTimeLineView alloc] initWithTimeArray:nil andTimeDesArray:desArr andCurrentStatus:count andFrame:self.timeLineView.frame];
    [self.timeLineView addSubview:timeLineV];
    
    self.timeLineView.contentSize = CGSizeMake(70 * desArr.count, 60);
    self.timeLineView.showsHorizontalScrollIndicator = NO;
    
    
}
- (void)lianxikefu:(UIButton *)button{
    
}
- (void)removeInfoView:(UIGestureRecognizer *)recognizer{
    //    NSLog(@"move");
    backView.hidden = YES;
//    self.navigationController.navigationBarHidden = NO;
    [recognizer.view removeFromSuperview];
    
}
         
- (void)backClicked:(UIButton *)button {
    [self.navigationController popViewControllerAnimated:YES];
}

         
         
         
         
         
         
         

@end
































































