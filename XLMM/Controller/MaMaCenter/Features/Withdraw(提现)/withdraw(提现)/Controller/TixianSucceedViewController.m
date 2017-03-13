//
//  TixianSucceedViewController.m
//  XLMM
//
//  Created by younishijie on 16/1/11.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "TixianSucceedViewController.h"
#import "JMPushingDaysController.h"
#import "JMBillDetailController.h"
#import "JMWithDrawDetailController.h"

@interface TixianSucceedViewController ()

{
    NSInteger _numValue;
}
/*
    头视图
 */
@property (nonatomic,strong) UIView *headView;
@property (nonatomic,strong) UIImageView *successImageView;
@property (nonatomic,strong) UILabel *cuccessLabel;
@property (nonatomic,strong) UILabel *promptLabel;
/*
    下侧视图
 */
@property (nonatomic,strong) UIView *bottomView;
@property (nonatomic,strong) UILabel *activeLabel;
@property (nonatomic,strong) UIButton *completeBtn;

//@property (nonatomic,assign) NSInteger numValue;

@end

@implementation TixianSucceedViewController

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
    [self createNavigationBarWithTitle:@"提现" selecotr:@selector(backClicked:)];
    if (self.tixianjine == 100) {
        _numValue = 10;
    } else if (self.tixianjine == 200){
        _numValue = 20;
    }else {
    }

    [self createLayout];
    [self createRightButonItem];
}

- (void)backClicked:(UIButton *)button{
//    [self.navigationController popViewControllerAnimated:YES];
    NSInteger count = 0;
    count = [[self.navigationController viewControllers] indexOfObject:self];
    if (count >= 2) {
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:(count - 2)] animated:YES];
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)setActiveNum:(float)activeNum {
    
//    activeNum = _activeNum;
    _activeNum = activeNum;
}

- (void)setSurplusMoney:(float)surplusMoney {
    
    _surplusMoney = surplusMoney;
    
}
#pragma mark -- 布局
- (void)createLayout {
    UIView *headView = [[UIView alloc] init];
    [self.view addSubview:headView];
    self.headView = headView;
    
    UIImageView *successImageView = [[UIImageView alloc] init];
    [self.headView addSubview:successImageView];
    self.successImageView = successImageView;
    successImageView.image = [UIImage imageNamed:@"apply_for_success"];
    
    
    
    UILabel *cuccessLabel = [[UILabel alloc] init];
    [self.headView addSubview:cuccessLabel];
    self.cuccessLabel = cuccessLabel;
    self.cuccessLabel.font = [UIFont boldSystemFontOfSize:18.];
    self.cuccessLabel.text = @"申请成功！";
    self.cuccessLabel.textAlignment = NSTextAlignmentCenter;
    
    
    UILabel *promptLabel = [[UILabel alloc] init];
    [self.headView addSubview:promptLabel];
    self.promptLabel = promptLabel;
    self.promptLabel.font = [UIFont systemFontOfSize:12.];
    self.promptLabel.text = @"提现成功，24小时之内到账";
    self.promptLabel.textAlignment = NSTextAlignmentCenter;

    
    UIView *bottomView = [[UIView alloc] init];
    [self.view addSubview:bottomView];
    self.bottomView = bottomView;
    bottomView.backgroundColor = [UIColor lineGrayColor];
    
    if (self.isActiveValue) {
        UILabel *activeLabel = [[UILabel alloc] init];
        [self.bottomView addSubview:activeLabel];
        self.activeLabel = activeLabel;
        self.activeLabel.textAlignment = NSTextAlignmentCenter;
        self.activeLabel.font = [UIFont systemFontOfSize:12.];
        
    }else {
        
    }
    
    
    
    
//    self.activeLabel.text = [NSString stringWithFormat:@"消耗%ld点活跃值，剩余%ld点活跃值",(long)_numValue,(long)_activeValueNum];
    self.promptLabel.font = [UIFont systemFontOfSize:12.];

    
    UIButton *completeBtn = [[UIButton alloc] init];
    [self.bottomView addSubview:completeBtn];
    self.completeBtn = completeBtn;
    [completeBtn setBackgroundImage:[UIImage imageNamed:@"success_purecolor"] forState:UIControlStateNormal];
    [completeBtn setTitle:@"完成" forState:UIControlStateNormal];
    [completeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [completeBtn addTarget:self action:@selector(finishButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(64);
        make.left.equalTo(self.view.mas_left).offset(0);
        make.width.mas_offset(SCREENWIDTH);
        make.bottom.equalTo(self.promptLabel.mas_bottom).offset(30);
//        make.height.mas_offset(@(571/2));
    }];
    
    [self.successImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headView.mas_top).offset(116/2);
        make.centerX.equalTo(self.headView.mas_centerX);
        make.width.mas_offset(@60);
        make.height.mas_offset(@(79/2));
    }];
    
    [self.cuccessLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.successImageView.mas_bottom).offset(28);
        make.centerX.equalTo(self.headView.mas_centerX);
        make.width.mas_offset(@160);
        make.height.mas_offset(@32);
    }];
    
    [self.promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cuccessLabel.mas_bottom).offset(26);
        make.centerX.equalTo(self.headView.mas_centerX);
        make.width.mas_offset(SCREENWIDTH);
        make.height.mas_offset(@14);
    }];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headView.mas_bottom).offset(0);
        make.left.equalTo(self.view.mas_left).offset(0);
        make.width.mas_offset(SCREENWIDTH);
        make.bottom.equalTo(self.view.mas_bottom).offset(0);
    }];
    
    if (self.isActiveValue) {
        [self.activeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.bottomView.mas_top).offset(21/2);
            make.centerX.equalTo(self.bottomView.mas_centerX);
            make.width.mas_offset(SCREENWIDTH);
        }];
    }

    
    [self.completeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bottomView).offset(55);
        make.left.equalTo(self.bottomView.mas_left).offset(15);
        make.width.mas_offset(SCREENWIDTH - 30);
        make.height.mas_offset(40);
//        make.bottom.equalTo(self.bottomView.mas_bottom).offset(70);
    }];
    
    
    
}

#pragma mark ----- 提现详情界面 

- (void) createRightButonItem{
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 40)];
    [rightBtn addTarget:self action:@selector(rightClicked:) forControlEvents:UIControlEventTouchUpInside];
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 40)];
//    label.textColor = [UIColor textDarkGrayColor];
//    label.font = [UIFont systemFontOfSize:14];
//    label.textAlignment = NSTextAlignmentRight;
//    [rightBtn addSubview:label];
//    label.text = @"查看详情";
    [rightBtn setTitle:@"查看详情" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:14.];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    
}

- (void)rightClicked:(UIButton *)button{

//    JMBillDetailController *billDetail = [[JMBillDetailController alloc] init];
//    billDetail.withdrawMoney = _surplusMoney; // 剩余金额
//    billDetail.activeValue = _activeValueNum; // 剩余活跃值
//    billDetail.withDrawF = self.tixianjine;
//    billDetail.isActiveValue = self.isActiveValue;
    
    JMWithDrawDetailController *billDetail = [[JMWithDrawDetailController alloc] init];
    billDetail.isActiveValue = self.isActiveValue;
    [self.navigationController pushViewController:billDetail animated:YES];
    
    
    
    
}
- (void)setActiveValueNum:(NSInteger)activeValueNum {
    
    _activeValueNum = activeValueNum;

}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)finishButton:(UIButton *)btn {
    NSInteger count = 0;
    count = [[self.navigationController viewControllers] indexOfObject:self];
    if (count >= 2) {
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:(count - 2)] animated:YES];
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

- (IBAction)fabuClicked:(id)sender {
    
 //NSLog(@"发布产品");
    
    JMPushingDaysController *publish = [[JMPushingDaysController alloc] init];
    [self.navigationController pushViewController:publish animated:YES];
}
@end





















