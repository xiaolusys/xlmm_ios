//
//  JMBillDetailController.m
//  XLMM
//
//  Created by zhang on 16/5/12.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMBillDetailController.h"
#import "MMClass.h"
#import "TixianModel.h"
#import "NSString+DeleteT.h"
#import "TixianViewController.h"
#import "JMWithdrawCashController.h"

@interface JMBillDetailController ()<UIAlertViewDelegate>

//头View
@property (nonatomic,strong) UIView *headView;
//出账金额
@property (nonatomic,strong) UILabel *takeoutMoney;
//提取现金金额图片
@property (nonatomic,strong) UILabel *moneyImageView;

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

//@property (nonatomic,strong) UILabel *orderlIDLabel;
//
//@property (nonatomic,strong) UILabel *orderlIDValueLabel;

@property (nonatomic,strong) UILabel *balanceLabel;

@property (nonatomic,strong) UILabel *balanceValueLabel;

@property (nonatomic,strong) UILabel *consumeActiveLabel;

@property (nonatomic,strong) UILabel *consumeActiveValueLabel;

@property (nonatomic,strong) UILabel *surplusActiveLabel;

@property (nonatomic,strong) UILabel *surplusActiveValueLabel;



@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic,copy) NSString *timeStr;

@property (nonatomic,strong) NSDictionary *dict;

//取消按钮
@property (nonatomic,strong) UIButton *cancleButton;

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
- (void)setActiveValue:(NSInteger)activeValue {
    _activeValue = activeValue;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    [self createNavigationBarWithTitle:@"账单明细" selecotr:@selector(backClickedesllect:)];
    [self loadDataSource];

    [self createUI];
    [self createLayout];
    
//    
//    NSString *created = _dict[@"created"];
//    
//    NSString *string = [NSString dateDeleteT:created];
//    
//    NSString *timeStr = [string substringWithRange:NSMakeRange(5, 10)];
//    _iceTimeLabel.text = timeStr;
//    
//    
}


- (void)loadDataSource {
    NSString *nextStr = @"";
    if (self.isActiveValue) {
        nextStr = [NSString stringWithFormat:@"%@/rest/v1/pmt/cashout", Root_URL];
    }else {
        nextStr = [NSString stringWithFormat:@"%@/rest/v1/users/get_budget_detail", Root_URL];
    }
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager GET:nextStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject == nil) {
            return ;
        }else {
            NSArray *results = responseObject[@"results"];
            NSDictionary *dict = results[0];
            self.dict = dict;
            if (self.isActiveValue) {
                [self createDate:dict];
            }else {
                [self createNoActive:dict];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];


}
- (void)createNoActive:(NSDictionary *)dict {
    _iceTimeLabel.text = dict[@"budget_date"];
    _disTimeLabel.text = dict[@"budget_date"];
    _sucTimeLabel.text = dict[@"budget_date"];
    _withdrawToAccountValueLabel.text = @"微信红包";
    _moneyImageView.text = [NSString stringWithFormat:@"%.2f",self.withDrawF];
    _balanceValueLabel.text = [NSString stringWithFormat:@"%.2f",self.withdrawMoney];
    _setUpTimeValueLabel.text = dict[@"budget_date"];
    
    //成功
    _cuccessImageView.image = [UIImage imageNamed:@"success_Image"];
    _rightImageView.image = [UIImage imageNamed:@"left_line_selected"];
    
    
}
- (void)createDate:(NSDictionary *)dict {
    
    NSString *codeState = dict[@"status"];
    
    NSInteger valueMoney = [dict[@"value_money"] integerValue];

    _moneyImageView.text = [NSString stringWithFormat:@"%ld",valueMoney];
    if (valueMoney == 100) {
        //消耗活跃值 --  判断金额
        _consumeActiveValueLabel.text = @"10点";
    }else {
        _consumeActiveValueLabel.text = @"20点";
    }
    
    
    //时间 -- 判断系统的处理时间的格式
    NSString *created = dict[@"created"];
    NSString *string = [NSString dateDeleteT:created];
    NSString *timeStr = [string substringWithRange:NSMakeRange(5, 11)];
//    self.timeStr = timeStr;
    
    //时间 -- 判断创建时间
    _setUpTimeValueLabel.text = string;
    
    //交易单号
    
    
    //剩余零钱 --  从外部传入
    _balanceValueLabel.text = [NSString stringWithFormat:@"%.2f",self.withdrawMoney];
    //剩余活跃值
    _surplusActiveValueLabel.text = [NSString stringWithFormat:@"%ld",(long)_activeValue];
    
    _iceTimeLabel.text = timeStr;
    
    _disTimeLabel.text = timeStr;
    
    _sucTimeLabel.text = timeStr;
    
    if ([codeState isEqualToString:@"approved"]) {
        //成功
        _cuccessImageView.image = [UIImage imageNamed:@"success_Image"];
        _rightImageView.image = [UIImage imageNamed:@"left_line_selected"];
        
        _sucTimeLabel.hidden = NO;
        
        _withdrawToAccountValueLabel.text = @"小鹿钱包";
        
        
    }else {
        //等待
        _cuccessImageView.image = [UIImage imageNamed:@"success_Image_nomal"];
        _rightImageView.image = [UIImage imageNamed:@"left_line_nomal"];
        
        _sucTimeLabel.hidden = YES;
        
        _withdrawToAccountValueLabel.text = @"微信红包";
        
        _sucLabel.text = @"资金返还";
        _sucLabel.textColor = [UIColor lineGrayColor];
        
        //有取消按钮
        [self createRightButonItem];
        
    }
    _sucTimeLabel.text = timeStr;

    NSString *isSuccess = dict[@"get_status_display"];
    //判断取消按钮是否存在
    if ([isSuccess isEqualToString:@"审核通过"]) {
        //没有取消提现按钮
        
    }else if([isSuccess isEqualToString:@"取消"]) {
        //有取消按钮
//        [self createRightButonItem];
        
    }else {
    
    }
    
    
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
    
    UILabel *moneyImageView = [[UILabel alloc] init];
    [self.headView addSubview:moneyImageView];
    self.moneyImageView = moneyImageView;
    self.moneyImageView.font = [UIFont systemFontOfSize:40.];
    self.moneyImageView.textColor = [UIColor buttonEnabledBackgroundColor];
//    self.moneyImageView.image = [UIImage imageNamed:@"oneHunder_Withdraw"];
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
    cuccessImageView.image = [UIImage imageNamed:@"success_Image_nomal"];

    //panduan
    
    
    UIImageView *leftImageView = [[UIImageView alloc] init];
    [self.headView addSubview:leftImageView];
    self.leftImageView = leftImageView;
    leftImageView.image = [UIImage imageNamed:@"left_line_selected"];
    
    UIImageView *rightImageView = [[UIImageView alloc] init];
    [self.headView addSubview:rightImageView];
    self.rightImageView = rightImageView;
    rightImageView.image = [UIImage imageNamed:@"left_line_nomal"];
    
    //panduan
    
    
    
    //--------------------
    UILabel *iceLabel = [[UILabel alloc] init];
    [self.headView addSubview:iceLabel];
    self.iceLabel = iceLabel;
    self.iceLabel.text = @"金额冻结";
    self.iceLabel.font = [UIFont systemFontOfSize:12.];
    self.iceLabel.textAlignment = NSTextAlignmentLeft;
    
    
    UILabel *iceTimeLabel = [[UILabel alloc] init];
    [self.headView addSubview:iceTimeLabel];
    self.iceTimeLabel = iceTimeLabel;
    self.iceTimeLabel.font = [UIFont systemFontOfSize:11.];
    self.iceTimeLabel.textAlignment = NSTextAlignmentLeft;
    


    
    UILabel *disLabel = [[UILabel alloc] init];
    [self.headView addSubview:disLabel];
    self.disLabel = disLabel;
    self.disLabel.text = @"系统处理中";
    self.disLabel.font = [UIFont systemFontOfSize:12.];
    self.disLabel.textAlignment = NSTextAlignmentCenter;

    UILabel *disTimeLabel = [[UILabel alloc] init];
    [self.headView addSubview:disTimeLabel];
    self.disTimeLabel = disTimeLabel;
    self.disTimeLabel.font = [UIFont systemFontOfSize:11.];
    self.disTimeLabel.textAlignment = NSTextAlignmentCenter;

    UILabel *sucLabel = [[UILabel alloc] init];
    [self.headView addSubview:sucLabel];
    self.sucLabel = sucLabel;
    self.sucLabel.text = @"提现成功";
    self.sucLabel.font = [UIFont systemFontOfSize:12.];
    self.sucLabel.textAlignment = NSTextAlignmentRight;

    UILabel *sucTimeLabel = [[UILabel alloc] init];
    [self.headView addSubview:sucTimeLabel];
    self.sucTimeLabel = sucTimeLabel;
    self.sucTimeLabel.font = [UIFont systemFontOfSize:11.];
    self.sucTimeLabel.textAlignment = NSTextAlignmentRight;

    
    //======================== bottonView===============//
    
    UILabel *withdrawToAccountLabel = [[UILabel alloc] init];
    [self.bottomView addSubview:withdrawToAccountLabel];
    self.withdrawToAccountLabel = withdrawToAccountLabel;
    withdrawToAccountLabel.text = @"提现至账户:";
    withdrawToAccountLabel.font = [UIFont systemFontOfSize:12.];

    UILabel *withdrawToAccountValueLabel = [[UILabel alloc] init];
    [self.bottomView addSubview:withdrawToAccountValueLabel];
    self.withdrawToAccountValueLabel = withdrawToAccountValueLabel;
    withdrawToAccountValueLabel.font = [UIFont systemFontOfSize:12.];

    UILabel *setUpTimeLabel = [[UILabel alloc] init];
    [self.bottomView addSubview:setUpTimeLabel];
    self.setUpTimeLabel = setUpTimeLabel;
    setUpTimeLabel.text = @"创 建 时 间:";
    setUpTimeLabel.font = [UIFont systemFontOfSize:12.];

    UILabel *setUpTimeValueLabel = [[UILabel alloc] init];
    [self.bottomView addSubview:setUpTimeValueLabel];
    self.setUpTimeValueLabel = setUpTimeValueLabel;
    setUpTimeValueLabel.font = [UIFont systemFontOfSize:12.];

//    UILabel *orderlIDLabel = [[UILabel alloc] init];
//    [self.bottomView addSubview:orderlIDLabel];
//    self.orderlIDLabel = orderlIDLabel;
//    orderlIDLabel.text = @"交 易 单 号:";
//    orderlIDLabel.font = [UIFont systemFontOfSize:12.];

//    UILabel *orderlIDValueLabel = [[UILabel alloc] init];
//    [self.bottomView addSubview:orderlIDValueLabel];
//    self.orderlIDValueLabel = orderlIDValueLabel;
//    orderlIDValueLabel.font = [UIFont systemFontOfSize:12.];

    UILabel *balanceLabel = [[UILabel alloc] init];
    [self.bottomView addSubview:balanceLabel];
    self.balanceLabel = balanceLabel;
    balanceLabel.text = @"剩 余 零 钱:";
    balanceLabel.font = [UIFont systemFontOfSize:12.];

    UILabel *balanceValueLabel = [[UILabel alloc] init];
    [self.bottomView addSubview:balanceValueLabel];
    self.balanceValueLabel = balanceValueLabel;
    balanceValueLabel.font = [UIFont systemFontOfSize:12.];

    if (self.isActiveValue) {
        UILabel *consumeActiveLabel = [[UILabel alloc] init];
        [self.bottomView addSubview:consumeActiveLabel];
        self.consumeActiveLabel = consumeActiveLabel;
        consumeActiveLabel.text = @"消耗活跃值:";
        consumeActiveLabel.font = [UIFont systemFontOfSize:12.];
        
        UILabel *surplusActiveLabel = [[UILabel alloc] init];
        [self.bottomView addSubview:surplusActiveLabel];
        self.surplusActiveLabel = surplusActiveLabel;
        surplusActiveLabel.text = @"剩余活跃值:";
        surplusActiveLabel.font = [UIFont systemFontOfSize:12.];
        
        UILabel *consumeActiveValueLabel = [[UILabel alloc] init];
        [self.bottomView addSubview:consumeActiveValueLabel];
        self.consumeActiveValueLabel = consumeActiveValueLabel;
        consumeActiveValueLabel.font = [UIFont systemFontOfSize:12.];

        UILabel *surplusActiveValueLabel = [[UILabel alloc] init];
        [self.bottomView addSubview:surplusActiveValueLabel];
        self.surplusActiveValueLabel = surplusActiveValueLabel;
        surplusActiveValueLabel.font = [UIFont systemFontOfSize:12.];
    }
    

    

}

- (void)createLayout {
    
    
    
    [self.headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(64);
        make.left.equalTo(self.view.mas_left).offset(0);
        make.width.mas_equalTo(SCREENWIDTH);
        make.height.mas_equalTo(@220);
    }];
    
    [self.takeoutMoney mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headView.mas_top).offset(35);
        make.centerX.equalTo(self.headView.mas_centerX);
        make.width.mas_equalTo(@80);
        make.height.mas_equalTo(21);
    }];
    
    [self.moneyImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.takeoutMoney.mas_bottom).offset(5);
        make.centerX.equalTo(self.headView.mas_centerX);
    }];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headView.mas_bottom).offset(0);
        make.left.equalTo(self.view.mas_left).offset(0);
        make.width.mas_equalTo(SCREENWIDTH);
        make.height.mas_equalTo(SCREENHEIGHT - 220 - 64);
    }];
    
    //====================   连线视图
    
    [self.iceImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.moneyImageView.mas_bottom).offset(30);
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
        make.top.equalTo(self.iceImageView.mas_bottom).offset(15);
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
        make.top.equalTo(self.iceImageView.mas_bottom).offset(15);
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
        make.top.equalTo(self.iceImageView.mas_bottom).offset(15);
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
        make.top.equalTo(self.bottomView.mas_top).offset(20);
        make.left.equalTo(self.bottomView.mas_left).offset(15);
        make.width.mas_equalTo(@84);
        make.height.mas_equalTo(@14);
    }];
    
    [self.withdrawToAccountValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bottomView.mas_top).offset(20);
        make.left.equalTo(self.withdrawToAccountLabel.mas_right).offset(5);
        make.width.mas_equalTo(SCREENWIDTH - 110);
        make.height.mas_equalTo(@14);
    }];
    
    [self.setUpTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.withdrawToAccountLabel.mas_bottom).offset(20);
        make.left.equalTo(self.withdrawToAccountLabel.mas_left);
        make.width.mas_equalTo(@84);
        make.height.mas_equalTo(@14);
    }];
    
    [self.setUpTimeValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.withdrawToAccountLabel.mas_bottom).offset(20);
        make.left.equalTo(self.withdrawToAccountValueLabel.mas_left);
        make.width.mas_equalTo(SCREENWIDTH - 110);
        make.height.mas_equalTo(@14);
    }];
//    
//    [self.orderlIDLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.setUpTimeLabel.mas_bottom).offset(20);
//        make.left.equalTo(self.withdrawToAccountLabel.mas_left);
//        make.width.mas_equalTo(@84);
//        make.height.mas_equalTo(@14);
//    }];
//    
//    [self.orderlIDValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.setUpTimeLabel.mas_bottom).offset(20);
//        make.left.equalTo(self.withdrawToAccountValueLabel.mas_left);
//        make.width.mas_equalTo(SCREENWIDTH - 110);
//        make.height.mas_equalTo(@14);
//    }];
//    
    [self.balanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.setUpTimeLabel.mas_bottom).offset(20);
        make.left.equalTo(self.withdrawToAccountLabel.mas_left);
        make.width.mas_equalTo(@84);
        make.height.mas_equalTo(@14);
    }];
    
    [self.balanceValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.setUpTimeLabel.mas_bottom).offset(20);
        make.left.equalTo(self.withdrawToAccountValueLabel.mas_left);
        make.width.mas_equalTo(SCREENWIDTH - 110);
        make.height.mas_equalTo(@14);
    }];
    
    if (self.isActiveValue) {
        [self.consumeActiveLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.balanceValueLabel.mas_bottom).offset(20);
            make.left.equalTo(self.withdrawToAccountLabel.mas_left);
            make.width.mas_equalTo(@84);
            make.height.mas_equalTo(@14);
        }];
        
        [self.consumeActiveValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.balanceValueLabel.mas_bottom).offset(20);
            make.left.equalTo(self.withdrawToAccountValueLabel.mas_left);
            make.width.mas_equalTo(SCREENWIDTH - 110);
            make.height.mas_equalTo(@14);
        }];
        
        [self.surplusActiveLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.consumeActiveLabel.mas_bottom).offset(20);
            make.left.equalTo(self.withdrawToAccountLabel.mas_left);
            make.width.mas_equalTo(@84);
            make.height.mas_equalTo(@14);
        }];
        
        [self.surplusActiveValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.consumeActiveLabel.mas_bottom).offset(20);
            make.left.equalTo(self.withdrawToAccountValueLabel.mas_left);
            make.width.mas_equalTo(SCREENWIDTH - 110);
            make.height.mas_equalTo(@14);
        }];
    }
    
}

#pragma mark ---- 取消提现按钮的点击

- (void) createRightButonItem{
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
    [rightBtn addTarget:self action:@selector(rightClicked:) forControlEvents:UIControlEventTouchUpInside];

    [rightBtn setTitle:@"取消提现" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];

    rightBtn.titleLabel.font = [UIFont systemFontOfSize:14.];
    
    self.cancleButton = rightBtn;
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)rightClicked:(UIButton *)button{
    
    _cancleButton.enabled = NO;
    [_cancleButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];

    
    //取消提现的操作 --
    NSString *string = [NSString stringWithFormat:@"%@/rest/v1/pmt/cashout/cancal_cashout", Root_URL];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    //  http://192.168.1.31:9000/rest/v1/cashout
    
    
    NSString *cancleStr = _dict[@"id"];
    
    
    NSDictionary *paramters = @{@"id":cancleStr};
    
    NSLog(@"paramters = %@", paramters);
    [manager POST:string parameters:paramters
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              NSLog(@"response = %@", responseObject);
              if ([[responseObject objectForKey:@"code"] integerValue] == 0) {
                  
                  [self toolTipSuccess];
                  
              } else if ([[responseObject objectForKey:@"code"] integerValue] == 1){
                 
                  [self toolTipFaile];
              }
              
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              
              
              
              NSLog(@"Error: %@", error);
              
          }];
    
    
    
    
    
}

#pragma mark ---- UIAlertView的点击事件

- (void)toolTipSuccess {

    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"取消成功" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//    [self performSelector:@selector(dimissAlert:) withObject:alertView afterDelay:1.0];
    
    [alertView show];

}
- (void)toolTipFaile {
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"取消失败" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
    
}
//- (void)dimissAlert:(UIAlertView *)alert {
//    
////    TixianViewController *tixian = [[TixianViewController alloc] init];
//    
//    
//    if(alert)     {
//        [alert dismissWithClickedButtonIndex:0 animated:YES];
//    }
//    
//    
//    //第一种
////    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:2] animated:YES];
//    //第二种
//    for (UIViewController *temp in self.navigationController.viewControllers) {
//        if ([temp isKindOfClass:[TixianViewController class]]) {
//            [self.navigationController popToViewController:temp animated:YES];
//        }
//    }
//}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0) {
        //点击确定按钮后 需要做的事情
        
        //第一种
        //    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:2] animated:YES];
        //第二种
        for (UIViewController *temp in self.navigationController.viewControllers) {
            if ([temp isKindOfClass:[TixianViewController class]]) {
                [self.navigationController popToViewController:temp animated:YES];
            }
        }

    
    }
    
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
    
//    [self.navigationController popToRootViewControllerAnimated:YES];
    
    
    for (UIViewController *temp in self.navigationController.viewControllers) {
        if ([temp isKindOfClass:[TixianViewController class]] || [temp isKindOfClass:[JMWithdrawCashController class]]) {
            [self.navigationController popToViewController:temp animated:YES];
        }
    }
    
    
}
@end

































