//
//  JMBillDetailController.m
//  XLMM
//
//  Created by zhang on 16/5/12.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMBillDetailController.h"
#import "Masonry.h"
#import "MMClass.h"
#import "UIViewController+NavigationBar.h"



@interface JMBillDetailController ()

//头View
@property (nonatomic,strong) UIView *headView;
//出账金额
@property (nonatomic,strong) UILabel *takeoutMoney;
//提取现金金额图片
@property (nonatomic,strong) UIImageView *moneyImageView;

/*
    金额冻结--系统处理中--提现成功
 */
@property (nonatomic,strong) UIImageView *iceImageView;

@property (nonatomic,strong) UIImageView *disposeImageView;

@property (nonatomic,strong) UIImageView *cuccessImageView;

@property (nonatomic,strong) UIImageView *leftImageView;

@property (nonatomic,strong) UIImageView *rightImageView;

//=======

@property (nonatomic,strong) UILabel *iceLabel;

@property (nonatomic,strong) UILabel *disLabel;

@property (nonatomic,strong) UILabel *sucLabel;

@property (nonatomic,strong) UILabel *iceTimeLabel;

@property (nonatomic,strong) UILabel *disTimeLabel;

@property (nonatomic,strong) UILabel *sucTimeLabel;

//=========

@property (nonatomic,strong) UIView *bottomView;

@property (nonatomic,strong) UILabel *withdrawToAccountLabel;

@property (nonatomic,strong) UILabel *withdrawToAccountValueLabel;

@property (nonatomic,strong) UILabel *setUpTimeLabel;

@property (nonatomic,strong) UILabel *setUpTimeValueLabel;

@property (nonatomic,strong) UILabel *orderlIDLabel;

@property (nonatomic,strong) UILabel *orderlIDValueLabel;

@property (nonatomic,strong) UILabel *balanceLabel;

@property (nonatomic,strong) UILabel *balanceValueLabel;

@property (nonatomic,strong) UILabel *consumeActiveLabel;

@property (nonatomic,strong) UILabel *consumeActiveValueLabel;

@property (nonatomic,strong) UILabel *surplusActiveLabel;

@property (nonatomic,strong) UILabel *surplusActiveValueLabel;







@end


@implementation JMBillDetailController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    [self createNavigationBarWithTitle:@"账单明细" selecotr:@selector(backClickedesllect:)];
    
    [self createUI];
    [self createLayout];
    
//    [self createRightButonItem];
}



- (void)createUI {
    UIView *headView = [[UIView alloc] init];
    self.headView = headView;
    [self.view addSubview:headView];
    
    UIView *bottomView = [[UIView alloc] init];
    self.bottomView = bottomView;
    [self.view addSubview:bottomView];
    self.bottomView.backgroundColor = [UIColor lineGrayColor];
    
    UILabel *takeoutMoney = [[UILabel alloc] init];
    [self.headView addSubview:takeoutMoney];
    self.takeoutMoney = takeoutMoney;
    self.takeoutMoney.text = @"出账余额(元)";
    self.takeoutMoney.font = [UIFont systemFontOfSize:13.];
    self.takeoutMoney.textAlignment = NSTextAlignmentCenter;
    
    UIImageView *moneyImageView = [[UIImageView alloc] init];
    [self.headView addSubview:moneyImageView];
    self.moneyImageView = moneyImageView;
    self.moneyImageView.image = [UIImage imageNamed:@"oneHunder_Withdraw"];
    //---判断是100的图片还是200得图片
    
   //=======================================
    
    UIImageView *iceImageView = [[UIImageView alloc] init];
    [self.headView addSubview:iceImageView];
    self.iceImageView = iceImageView;
    iceImageView.image = [UIImage imageNamed:@"ice_Image"];
    
    
    UIImageView *disposeImageView = [[UIImageView alloc] init];
    [self.headView addSubview:disposeImageView];
    self.disposeImageView = disposeImageView;
    disposeImageView.image = [UIImage imageNamed:@"dispose_Image"];
    
    UIImageView *cuccessImageView = [[UIImageView alloc] init];
    [self.headView addSubview:cuccessImageView];
    self.cuccessImageView = cuccessImageView;
    //panduan
    
    
    UIImageView *leftImageView = [[UIImageView alloc] init];
    [self.headView addSubview:leftImageView];
    self.leftImageView = leftImageView;
    leftImageView.image = [UIImage imageNamed:@"left_line_selected"];
    
    UIImageView *rightImageView = [[UIImageView alloc] init];
    [self.headView addSubview:rightImageView];
    self.rightImageView = rightImageView;
    //panduan
    
    
    
    //--------------------
    UILabel *iceLabel = [[UILabel alloc] init];
    [self.headView addSubview:iceLabel];
    self.iceLabel = iceLabel;
    self.iceLabel.text = @"金额冻结";
    self.iceLabel.font = [UIFont systemFontOfSize:12.];
    self.iceLabel.textAlignment = NSTextAlignmentCenter;
    self.iceLabel.backgroundColor = [UIColor yellowColor];
    
    UILabel *iceTimeLabel = [[UILabel alloc] init];
    [self.headView addSubview:iceTimeLabel];
    self.iceTimeLabel = iceTimeLabel;
    self.iceTimeLabel.font = [UIFont systemFontOfSize:11.];
    self.iceTimeLabel.textAlignment = NSTextAlignmentLeft;
    self.iceTimeLabel.backgroundColor = [UIColor yellowColor];

    UILabel *disLabel = [[UILabel alloc] init];
    [self.headView addSubview:disLabel];
    self.disLabel = disLabel;
    self.disLabel.text = @"系统处理中";
    self.disLabel.font = [UIFont systemFontOfSize:12.];
    self.disLabel.textAlignment = NSTextAlignmentCenter;
    self.disLabel.backgroundColor = [UIColor yellowColor];

    UILabel *disTimeLabel = [[UILabel alloc] init];
    [self.headView addSubview:disTimeLabel];
    self.disTimeLabel = disTimeLabel;
    self.disTimeLabel.font = [UIFont systemFontOfSize:11.];
    self.disTimeLabel.textAlignment = NSTextAlignmentCenter;
    self.disTimeLabel.backgroundColor = [UIColor yellowColor];

    UILabel *sucLabel = [[UILabel alloc] init];
    [self.headView addSubview:sucLabel];
    self.sucLabel = sucLabel;
    self.sucLabel.text = @"提现成功";
    self.sucLabel.font = [UIFont systemFontOfSize:12.];
    self.sucLabel.textAlignment = NSTextAlignmentCenter;
    self.sucLabel.backgroundColor = [UIColor yellowColor];

    UILabel *sucTimeLabel = [[UILabel alloc] init];
    [self.headView addSubview:sucTimeLabel];
    self.sucTimeLabel = sucTimeLabel;
    self.sucTimeLabel.font = [UIFont systemFontOfSize:11.];
    self.sucTimeLabel.textAlignment = NSTextAlignmentRight;
    self.sucTimeLabel.backgroundColor = [UIColor yellowColor];

    
    //======================== bottonView===============//
    UILabel *withdrawToAccountLabel = [[UILabel alloc] init];
    [self.bottomView addSubview:withdrawToAccountLabel];
    self.withdrawToAccountLabel = withdrawToAccountLabel;
    self.withdrawToAccountLabel.backgroundColor = [UIColor yellowColor];

    UILabel *withdrawToAccountValueLabel = [[UILabel alloc] init];
    [self.bottomView addSubview:withdrawToAccountValueLabel];
    self.withdrawToAccountValueLabel = withdrawToAccountValueLabel;
    self.withdrawToAccountValueLabel.backgroundColor = [UIColor yellowColor];

    UILabel *setUpTimeLabel = [[UILabel alloc] init];
    [self.bottomView addSubview:setUpTimeLabel];
    self.setUpTimeLabel = setUpTimeLabel;
    self.setUpTimeLabel.backgroundColor = [UIColor yellowColor];

    UILabel *setUpTimeValueLabel = [[UILabel alloc] init];
    [self.bottomView addSubview:setUpTimeValueLabel];
    self.setUpTimeValueLabel = setUpTimeValueLabel;
    self.setUpTimeValueLabel.backgroundColor = [UIColor yellowColor];

    UILabel *orderlIDLabel = [[UILabel alloc] init];
    [self.bottomView addSubview:orderlIDLabel];
    self.orderlIDLabel = orderlIDLabel;
    self.orderlIDLabel.backgroundColor = [UIColor yellowColor];

    UILabel *orderlIDValueLabel = [[UILabel alloc] init];
    [self.bottomView addSubview:orderlIDValueLabel];
    self.orderlIDValueLabel = orderlIDValueLabel;
    self.orderlIDValueLabel.backgroundColor = [UIColor yellowColor];

    UILabel *balanceLabel = [[UILabel alloc] init];
    [self.bottomView addSubview:balanceLabel];
    self.balanceLabel = balanceLabel;
    self.balanceLabel.backgroundColor = [UIColor yellowColor];

    UILabel *balanceValueLabel = [[UILabel alloc] init];
    [self.bottomView addSubview:balanceValueLabel];
    self.balanceValueLabel = balanceValueLabel;
    self.balanceValueLabel.backgroundColor = [UIColor yellowColor];

    UILabel *consumeActiveLabel = [[UILabel alloc] init];
    [self.bottomView addSubview:consumeActiveLabel];
    self.consumeActiveLabel = consumeActiveLabel;
    self.consumeActiveLabel.backgroundColor = [UIColor yellowColor];

    UILabel *consumeActiveValueLabel = [[UILabel alloc] init];
    [self.bottomView addSubview:consumeActiveValueLabel];
    self.consumeActiveValueLabel = consumeActiveValueLabel;
    self.consumeActiveValueLabel.backgroundColor = [UIColor yellowColor];

    UILabel *surplusActiveLabel = [[UILabel alloc] init];
    [self.bottomView addSubview:surplusActiveLabel];
    self.surplusActiveLabel = surplusActiveLabel;
    self.surplusActiveLabel.backgroundColor = [UIColor yellowColor];

    UILabel *surplusActiveValueLabel = [[UILabel alloc] init];
    [self.bottomView addSubview:surplusActiveValueLabel];
    self.surplusActiveValueLabel = surplusActiveValueLabel;
    self.surplusActiveValueLabel.backgroundColor = [UIColor yellowColor];

}

- (void)createLayout {
    
    
    
    [self.headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(64);
        make.left.equalTo(self.view.mas_left).offset(0);
        make.width.mas_equalTo(SCREENWIDTH);
        make.height.mas_equalTo(@255);
    }];
    
    [self.takeoutMoney mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headView.mas_top).offset(50);
        make.centerX.equalTo(self.headView.mas_centerX);
        make.width.mas_equalTo(@80);
        make.height.mas_equalTo(21);
    }];
    
    [self.moneyImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.takeoutMoney.mas_bottom).offset(5);
        make.centerX.equalTo(self.headView.mas_centerX);
        make.width.mas_equalTo(@(191/2));
        make.height.mas_equalTo(@(98/2));
    }];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headView.mas_bottom).offset(0);
        make.left.equalTo(self.view.mas_left).offset(0);
        make.width.mas_equalTo(SCREENWIDTH);
        make.height.mas_equalTo(SCREENHEIGHT - 225 - 64);
    }];
    
    //====================   连线视图
    
    [self.iceImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.moneyImageView.mas_bottom).offset(40);
        make.left.equalTo(self.headView.mas_left).offset(30);
        make.width.height.mas_equalTo(@25);
    }];
    
    [self.disposeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.headView.mas_centerX);
        make.centerY.equalTo(self.iceImageView.mas_centerY);
        make.width.height.mas_equalTo(@25);
    }];
    
    [self.cuccessImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.iceImageView.mas_centerY);
        make.width.height.mas_equalTo(@25);
        make.right.equalTo(self.headView.mas_right).offset(-30);
    }];
    
    [self.leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.iceImageView.mas_centerY);
        make.left.equalTo(self.iceImageView.mas_right).offset(0);
        make.right.equalTo(self.disposeImageView.mas_left).offset(0);
    }];
    
    [self.rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.iceImageView.mas_centerY);
        make.left.equalTo(self.disposeImageView.mas_right).offset(0);
        make.right.equalTo(self.cuccessImageView.mas_left).offset(0);
    }];
    
    // 连线视图下面数据控件
    [self.iceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iceImageView.mas_bottom).offset(18);
        make.left.equalTo(self.iceImageView.mas_left);
        make.width.mas_equalTo((SCREENWIDTH - 60)/3);
        make.height.mas_equalTo(@12);
    }];
    
    [self.iceTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iceLabel.mas_bottom).offset(5);
        make.left.equalTo(self.iceImageView.mas_left);
        make.width.mas_equalTo((SCREENWIDTH - 60)/3);
        make.height.mas_equalTo(@16);
    }];
    
    [self.disLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iceImageView.mas_bottom).offset(18);
        make.centerX.equalTo(self.headView.mas_centerX);
        make.width.mas_equalTo((SCREENWIDTH - 60)/3);
        make.height.mas_equalTo(@12);
    }];
    
    [self.disTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iceLabel.mas_bottom).offset(5);
        make.centerX.equalTo(self.headView.mas_centerX);
        make.width.mas_equalTo((SCREENWIDTH - 60)/3);
        make.height.mas_equalTo(@16);
    }];
    
    [self.sucLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iceImageView.mas_bottom).offset(18);
        make.right.equalTo(self.cuccessImageView.mas_right);
        make.width.mas_equalTo((SCREENWIDTH - 60)/3);
        make.height.mas_equalTo(@12);
    }];
    
    [self.sucTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iceLabel.mas_bottom).offset(5);
        make.right.equalTo(self.cuccessImageView.mas_right);
        make.width.mas_equalTo((SCREENWIDTH - 60)/3);
        make.height.mas_equalTo(@16);
    }];
    
    
    //bottomView的视图控件
    
    [self.withdrawToAccountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bottomView.mas_top).offset(24);
        make.left.equalTo(self.bottomView.mas_left).offset(15);
        make.width.mas_equalTo(@84);
        make.height.mas_equalTo(@14);
    }];
    
    [self.withdrawToAccountValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bottomView.mas_top).offset(24);
        make.left.equalTo(self.withdrawToAccountLabel.mas_right).offset(5);
        make.width.mas_equalTo(SCREENWIDTH - 210);
        make.height.mas_equalTo(@14);
    }];
    
    [self.setUpTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.withdrawToAccountLabel.mas_bottom).offset(24);
        make.left.equalTo(self.withdrawToAccountLabel.mas_left);
        make.width.mas_equalTo(@84);
        make.height.mas_equalTo(@14);
    }];
    
    [self.setUpTimeValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.withdrawToAccountLabel.mas_bottom).offset(24);
        make.left.equalTo(self.withdrawToAccountValueLabel.mas_left);
        make.width.mas_equalTo(SCREENWIDTH - 210);
        make.height.mas_equalTo(@14);
    }];
    
    [self.orderlIDLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.setUpTimeLabel.mas_bottom).offset(24);
        make.left.equalTo(self.withdrawToAccountLabel.mas_left);
        make.width.mas_equalTo(@84);
        make.height.mas_equalTo(@14);
    }];
    
    [self.orderlIDValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.setUpTimeLabel.mas_bottom).offset(24);
        make.left.equalTo(self.withdrawToAccountValueLabel.mas_left);
        make.width.mas_equalTo(SCREENWIDTH - 210);
        make.height.mas_equalTo(@14);
    }];
    
    [self.balanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.orderlIDLabel.mas_bottom).offset(24);
        make.left.equalTo(self.withdrawToAccountLabel.mas_left);
        make.width.mas_equalTo(@84);
        make.height.mas_equalTo(@14);
    }];
    
    [self.balanceValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.orderlIDLabel.mas_bottom).offset(24);
        make.left.equalTo(self.withdrawToAccountValueLabel.mas_left);
        make.width.mas_equalTo(SCREENWIDTH - 210);
        make.height.mas_equalTo(@14);
    }];
    
    
    [self.consumeActiveLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.balanceValueLabel.mas_bottom).offset(24);
        make.left.equalTo(self.withdrawToAccountLabel.mas_left);
        make.width.mas_equalTo(@84);
        make.height.mas_equalTo(@14);
    }];
    
    [self.consumeActiveValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.balanceValueLabel.mas_bottom).offset(24);
        make.left.equalTo(self.withdrawToAccountValueLabel.mas_left);
        make.width.mas_equalTo(SCREENWIDTH - 210);
        make.height.mas_equalTo(@14);
    }];
    
    [self.surplusActiveLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.consumeActiveLabel.mas_bottom).offset(24);
        make.left.equalTo(self.withdrawToAccountLabel.mas_left);
        make.width.mas_equalTo(@84);
        make.height.mas_equalTo(@14);
    }];
    
    [self.surplusActiveValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.consumeActiveLabel.mas_bottom).offset(24);
        make.left.equalTo(self.withdrawToAccountValueLabel.mas_left);
        make.width.mas_equalTo(SCREENWIDTH - 210);
        make.height.mas_equalTo(@14);
    }];
    
}


//- (void) createRightButonItem{
//    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 40)];
//    [rightBtn addTarget:self action:@selector(rightClicked:) forControlEvents:UIControlEventTouchUpInside];
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 40)];
//    label.textColor = [UIColor textDarkGrayColor];
//    label.font = [UIFont systemFontOfSize:14];
//    label.textAlignment = NSTextAlignmentRight;
//    [rightBtn addSubview:label];
//    label.text = @"查看详情";
//    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
//    self.navigationItem.rightBarButtonItem = rightItem;
//}
//
//- (void)rightClicked:(UIButton *)button{
//    
////    JMBillDetailController *billDetail = [[JMBillDetailController alloc] init];
////    
////    [self.navigationController pushViewController:billDetail animated:YES];
//    
//    
//}

- (void)backClickedesllect:(id)sender {
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end

































