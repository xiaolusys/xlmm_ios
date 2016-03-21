//
//  WithdrawCashViewController.m
//  XLMM
//
//  Created by apple on 16/2/23.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "WithdrawCashViewController.h"
#import "MMClass.h"
#import "UIViewController+NavigationBar.h"
#import "WXApi.h"
#import "AFHTTPRequestOperationManager.h"
#import "GuanzhuViewController.h"


#define RED 8.88


@interface WithdrawCashViewController ()

@property (weak, nonatomic) IBOutlet UIView *bindView;
@property (weak, nonatomic) IBOutlet UILabel *accountMoney;

//redNum
@property (nonatomic, strong)UILabel *redNumLabel;
@property (nonatomic, strong)UIButton *addBtn;
@property (nonatomic, strong)UIButton *reduceBtn;
@property (nonatomic, strong)UIButton *rightDrawBtn;

@property (nonatomic, strong)UIImageView *reduceImage;
@property (nonatomic, strong)UIImageView *addImage;

@property (assign, nonatomic)BOOL isBandWx;
@property (assign, nonatomic)BOOL isMoneyMax;



@end

@implementation WithdrawCashViewController
{
    UIView *emptyView;
    UIView *withdrawalsIsOk;
    UIView *withdrawalsIsNo;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    
    [self isAttentionPublic];

}

- (void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:YES];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    
    NSInteger rednum = [self.redNumLabel.text integerValue];
    NSString *save = self.accountMoney.text;
    if (rednum > 0) {
        CGFloat money = rednum * RED + [self.accountMoney.text floatValue];
        save = [NSString stringWithFormat:@"%.2f", money];
    }
    
    [user setObject:save forKey:@"DrawCashM"];
    [user synchronize];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"drawCashMoeny" object:nil];

}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bangdingweixin) name:@"bindingwx" object:nil];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self createNavigationBarWithTitle:@"提现" selecotr:@selector(backBtnClicked:)];
    
    [self createBindView];
    self.accountMoney.text = [NSString stringWithFormat:@"%.2f",[self.money floatValue]];
    
    if (([self.money floatValue] < RED)) {
        [self createWithdrawalsIsNo];
    }else {
        [self createWithdrawalsIsOk];
    }
    
    
    //判断是否绑定微信号
//    if (!self.isBandWx) {
//        [self createEmptyView];
//    }else {
//        //已经绑定微信，判断金额
//        if (self.isMoneyMax) {
//            [self createWithdrawalsIsOk];
//        }else {
//            [self createWithdrawalsIsNo];
//        }
//    }
    
//    [self createEmptyView];
//    [self createWithdrawalsIsOk];
//    [self createWithdrawalsIsNo];
//    [self createBindView];
}

- (void)isAttentionPublic{
    NSString *string = [NSString stringWithFormat:@"%@/rest/v1/users/profile.json", Root_URL];
    MMLOG(string);
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:string]];
    if (data == nil) {
        return;
    }
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    MMLOG(dic);
    NSInteger isAttPub = [[dic objectForKey:@"is_attention_public"] integerValue];
   // isAttPub = 0;
    
    if (isAttPub == 0) {
        //立即关注
        
    } else if (isAttPub == 1){
        //已关注
        UIButton *button = [self.bindView viewWithTag:88];
        [button setTitle:@"已关注" forState:UIControlStateNormal];
        button.enabled = NO;
        [button setTitleColor:[UIColor buttonDisabledBorderColor] forState:UIControlStateNormal];
        button.layer.borderColor = [UIColor buttonDisabledBorderColor].CGColor;
        
    }
    
}



#pragma mark --创建View
- (void)createBindView {
    //判断类型
//    UILabel *weiXinName = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.bindView.frame.size.width, self.bindView.frame.size.height)];
//    weiXinName.text = @"xiaolumeimie";
//    weiXinName.textAlignment = NSTextAlignmentRight;
//    [self.bindView addSubview:weiXinName];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    btn.backgroundColor = [UIColor redColor];
    btn.frame = CGRectMake(self.bindView.frame.size.width - 75, 17, 65, 25);
    btn.layer.cornerRadius = 13;
    btn.layer.borderWidth = 0.5;
    btn.layer.borderColor = [UIColor buttonEmptyBorderColor].CGColor;
    [btn setTitle:@"立即关注" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:12];
    [btn setTitleColor:[UIColor orangeThemeColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(bindBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    btn.tag = 88;
    [self.bindView addSubview:btn];
}

- (void)createEmptyView{
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"WithdrawalsEmpty" owner:nil options:nil];
    emptyView = views[0];
    
    emptyView.frame = CGRectMake(0, 180, SCREENWIDTH, SCREENHEIGHT - 180);
    
    UIButton *button = (UIButton *)[emptyView viewWithTag:111];
    button.layer.cornerRadius = 15;
    button.layer.borderWidth = 0.5;
    button.layer.borderColor = [UIColor buttonEmptyBorderColor].CGColor;
    [button addTarget:self action:@selector(gotoShopping:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:emptyView];
}

- (void)createWithdrawalsIsOk{
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"WithdrawalsIsOk" owner:nil options:nil];
    withdrawalsIsOk = views[0];
    
    withdrawalsIsOk.frame = CGRectMake(0, 180, SCREENWIDTH, SCREENHEIGHT - 180);
    
    self.rightDrawBtn = (UIButton *)[withdrawalsIsOk viewWithTag:104];
    self.rightDrawBtn.layer.cornerRadius = 20;
    self.rightDrawBtn.layer.borderWidth = 0.5;
    
    self.rightDrawBtn.layer.borderWidth = 1.0;
    [self.rightDrawBtn addTarget:self action:@selector(rightAwayDraw:) forControlEvents:UIControlEventTouchUpInside];
    
    //获得加按钮和减按钮
    self.reduceBtn = (UIButton *)[withdrawalsIsOk viewWithTag:102];
    [self.reduceBtn addTarget:self action:@selector(reduceBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
    self.addBtn = (UIButton *)[withdrawalsIsOk viewWithTag:103];
    [self.addBtn addTarget:self action:@selector(addBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.reduceImage = (UIImageView *)[withdrawalsIsOk viewWithTag:105];
    self.addImage = (UIImageView *)[withdrawalsIsOk viewWithTag:106];
    
    self.redNumLabel = (UILabel *)[withdrawalsIsOk viewWithTag:108];
    
    [self rightDrawCashBtn:NO];
    
    [self.view addSubview:withdrawalsIsOk];
    
    //    emptyView.hidden = YES;
}

- (void)createWithdrawalsIsNo {
    
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"WithdrwaIsNo" owner:nil options:nil];
    withdrawalsIsNo = views[0];
    
    withdrawalsIsNo.frame = CGRectMake(0, 180, SCREENWIDTH, SCREENHEIGHT - 180);

    UIButton *button = (UIButton *)[withdrawalsIsNo viewWithTag:105];
    button.layer.cornerRadius = 20;
    button.layer.borderWidth = 0.5;
    button.layer.borderColor = [UIColor buttonDisabledBorderColor].CGColor;
    button.backgroundColor = [UIColor buttonDisabledBackgroundColor];
    button.layer.borderWidth = 1.0;
    
    [self.view addSubview:withdrawalsIsNo];
}

#pragma mark--按钮点击事件
//减红包
- (void)reduceBtnClickAction:(UIButton *)btn {
    int rednum = [self.redNumLabel.text intValue];
    CGFloat totalMoney = [self.accountMoney.text floatValue];

    if (!rednum == 0) {
        self.redNumLabel.text = [NSString stringWithFormat:@"%d", (rednum - 1)];
        
        CGFloat addsurplus = totalMoney + RED;
        self.accountMoney.text = [NSString stringWithFormat:@"%.2f", addsurplus];
        
        if (rednum - 1 == 0) {
            [self rightDrawCashBtn:NO];
        }
        
        CGFloat totalMoney = [self.accountMoney.text floatValue];
        if (totalMoney - RED > 0.000001) {
            [self.addImage setImage:[UIImage imageNamed:@"redPkgAdd"]];
            self.addBtn.userInteractionEnabled = YES;
        }
    }
}
//加红包
- (void)addBtnClickAction:(UIButton *)btn {
    int rednum = [self.redNumLabel.text intValue];
    CGFloat totalMoney = [self.accountMoney.text floatValue];
    
//    NSNumber *temp = [NSNumber numberWithFloat:((rednum + 1) * RED)];
//    CGFloat num = [temp floatValue];
    
    if (totalMoney - RED > 0.000001 || (fabs(totalMoney - RED) < 0.000001 || fabs(RED - totalMoney) < 0.000001)) {
        [self rightDrawCashBtn:YES];
        self.redNumLabel.text = [NSString stringWithFormat:@"%d", (rednum + 1)];
        
        CGFloat surplus = totalMoney - RED;
        self.accountMoney.text = [NSString stringWithFormat:@"%.2f", surplus];
        
        if (surplus - RED < 0.000001) {
            [self.addImage setImage:[UIImage imageNamed:@"grayAdd"]];
            self.addBtn.userInteractionEnabled = YES;
            NSLog(@"您的余额不够了！");
        }
    }
}


- (void)gotoShopping:(UIButton *)btn {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)backBtnClicked:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}

//立即绑定
- (void)bindBtnAction:(UIButton *)button {
//    if ([WXApi isWXAppInstalled]) {
//        
//    } else{
//        UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"您的设备没有安装微信" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
//        [alterView show];
//        
//        return;
//    }
    GuanzhuViewController *guanzhuVC = [[GuanzhuViewController alloc] init];
    [self.navigationController pushViewController:guanzhuVC animated:YES];
   
    
}
//马上提现
- (void)rightAwayDraw:(UIButton *)button {
    //提现金额
    CGFloat amount1 = [self.redNumLabel.text floatValue] * RED;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *url = [NSString stringWithFormat:@"%@/rest/v1/users/budget_cash_out", Root_URL];
    
    NSNumber *amount = [NSNumber numberWithFloat:amount1];
    
    NSDictionary *dic = @{@"cashout_amount":amount};
    [manager POST:url parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@", responseObject);
        if ([[responseObject objectForKey:@"code"] integerValue] == 0) {
            [self showDrawResults:responseObject];
            self.redNumLabel.text = @"0";
            [self rightDrawCashBtn:NO];
        } else if ([[responseObject objectForKey:@"code"] integerValue] == 4) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"请关注小鹿美美公众号" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            alertView.tag = 1000;
            [alertView show];
        } else {
             [self showDrawResults:responseObject];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        
    }];
}

- (void)showDrawResults:(NSDictionary *)results {
    NSString *desc = results[@"message"];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:desc delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alert show];
    
    //如果没有绑定微信号
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
  
    if (alertView.tag == 1000) {
        GuanzhuViewController *guanzhuVC = [[GuanzhuViewController alloc] init];
        [self.navigationController pushViewController:guanzhuVC animated:YES];
        
    }
    

}

//绑定微信
- (void)bangdingweixin{
    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
    NSDictionary *dic = [userdefault objectForKey:@"userInfo"];
    NSLog(@"---> userinfo = %@", dic);
}

#pragma mark--马上提现按钮的操作
- (void)rightDrawCashBtn:(BOOL)type {
    if (type) {
        self.rightDrawBtn.layer.borderColor = [UIColor buttonEnabledBorderColor].CGColor;//buttonEnabledBorderColor
        self.rightDrawBtn.backgroundColor = [UIColor buttonEnabledBackgroundColor];//buttonDisabledBackgroundColor
        self.rightDrawBtn.userInteractionEnabled = YES;
        
        [self.reduceImage setImage:[UIImage imageNamed:@"redPkgjian"]];
        self.reduceBtn.userInteractionEnabled = YES;
    }else {
        self.rightDrawBtn.layer.borderColor = [UIColor buttonDisabledBorderColor].CGColor;//buttonEnabledBorderColor
        self.rightDrawBtn.backgroundColor = [UIColor buttonDisabledBackgroundColor];//buttonDisabledBackgroundColor
        self.rightDrawBtn.userInteractionEnabled = NO;
        
        [self.reduceImage setImage:[UIImage imageNamed:@"grayJian"]];
        self.reduceBtn.userInteractionEnabled = NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
