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

@interface WithdrawCashViewController ()

@property (weak, nonatomic) IBOutlet UIView *bindView;
@property (assign, nonatomic)BOOL isBandWx;
@property (assign, nonatomic)BOOL isMoneyMax;

@end

@implementation WithdrawCashViewController
{
    UIView *emptyView;
    UIView *withdrawalsIsOk;
    UIView *withdrawalsIsNo;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bangdingweixin) name:@"bindingwx" object:nil];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createNavigationBarWithTitle:@"提现" selecotr:@selector(backBtnClicked:)];
    
    [self createBindView];
    //判断是否绑定微信号
    if (!self.isBandWx) {
        [self createEmptyView];
    }else {
        //已经绑定微信，判断金额
        if (self.isMoneyMax) {
            [self createWithdrawalsIsOk];
        }else {
            [self createWithdrawalsIsNo];
        }
    }
    
//    [self createEmptyView];
//    [self createWithdrawalsIsOk];
//    [self createWithdrawalsIsNo];
//    [self createBindView];
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
    [btn setTitle:@"立即绑定" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:12];
    [btn setTitleColor:[UIColor orangeThemeColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(bindBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.bindView addSubview:btn];
}

- (void)createEmptyView{
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"WithdrawalsEmpty" owner:nil options:nil];
    emptyView = views[0];
    
    emptyView.frame = CGRectMake(0, 180, SCREENWIDTH, SCREENHEIGHT - 180);
    
    UIButton *button = (UIButton *)[emptyView viewWithTag:102];
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
    
    UIButton *button = (UIButton *)[withdrawalsIsOk viewWithTag:104];
    button.layer.cornerRadius = 20;
    button.layer.borderWidth = 0.5;
    button.layer.borderColor = [UIColor buttonEmptyBorderColor].CGColor;
    button.backgroundColor = [UIColor buttonEnabledBackgroundColor];
    button.layer.borderWidth = 1.0;
    [button addTarget:self action:@selector(rightAwayDraw:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:withdrawalsIsOk];
    //    emptyView.hidden = YES;
}

- (void)createWithdrawalsIsNo {
    
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"WithdrwaIsNo" owner:nil options:nil];
    withdrawalsIsNo = views[0];
    
    withdrawalsIsNo.frame = CGRectMake(0, 180, SCREENWIDTH, SCREENHEIGHT - 180);
//
    UIButton *button = (UIButton *)[withdrawalsIsNo viewWithTag:105];
    button.layer.cornerRadius = 20;
    button.layer.borderWidth = 0.5;
    button.layer.borderColor = [UIColor buttonDisabledBorderColor].CGColor;
    button.backgroundColor = [UIColor buttonDisabledBackgroundColor];
    button.layer.borderWidth = 1.0;
    
    [self.view addSubview:withdrawalsIsNo];
}

#pragma mark--按钮点击事件
- (void)gotoShopping:(UIButton *)btn {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)backBtnClicked:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}

//立即绑定
- (void)bindBtnAction:(UIButton *)button {
    if ([WXApi isWXAppInstalled]) {
        
    } else{
        UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"您的设备没有安装微信" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alterView show];
        
        return;
    }
    SendAuthReq* req =[[SendAuthReq alloc ] init];
    req.scope = @"snsapi_userinfo,snsapi_base";
    req.state = @"xiaolumeimei" ;
    NSLog(@"req = %@", req);
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    [userdefaults setObject:@"binding" forKey:kWeiXinauthorize];
    [userdefaults synchronize];
    [WXApi sendReq:req];
    
}
//马上提现
- (void)rightAwayDraw:(UIButton *)button {
    
}
//绑定微信
- (void)bangdingweixin{
    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
    NSDictionary *dic = [userdefault objectForKey:@"userInfo"];
    NSLog(@"---> userinfo = %@", dic);
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
