//
//  JMSettingController.m
//  XLMM
//
//  Created by zhang on 16/10/4.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMSettingController.h"
#import "JMChoiseWithDrawCell.h"
#import "ChangeNicknameViewController.h"
#import "WXLoginController.h"
#import "VerifyPhoneViewController.h"
#import "AddressViewController.h"
#import "ThirdAccountViewController.h"
#import "TSettingViewController.h"
#import "MiPushSDK.h"

@interface JMSettingController () <UITableViewDataSource,UITableViewDelegate> {
    NSMutableArray *cellDataArr;              // 自定义在cell上展示的类型
    NSString *nameString;
    NSString *phoneString;
}

@property (nonatomic, strong) UITableView *tableView;



@end

@implementation JMSettingController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavigationBarWithTitle:@"个人信息" selecotr:@selector(backClick:)];
    cellDataArr = [NSMutableArray array];
    
    [self createTableView];
    [self getData:self.userInfoDict];
    [self.tableView reloadData];
    self.tableView.scrollEnabled = self.tableView.contentSize.height > SCREENHEIGHT ? YES : NO;
    
//    [self ishavemobel];
//    [self loadUserData];
    

}
- (void)loadUserData {
    NSString *urlString = [NSString stringWithFormat:@"%@/rest/v1/users.json", Root_URL];
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:urlString WithParaments:nil WithSuccess:^(id responseObject) {
        if (!responseObject) return ;
        [self getData:responseObject];
        [self.tableView reloadData];
        self.tableView.scrollEnabled = self.tableView.contentSize.height > SCREENHEIGHT ? YES : NO;
    } WithFail:^(NSError *error) {
        [MBProgressHUD showError:@"个人数据获取失败,请检查网络哦~"];
    } Progress:^(float progress) {
        
    }];
    
}
- (void)ishavemobel{
    NSString *string = [NSString stringWithFormat:@"%@/rest/v1/users/profile", Root_URL];
    NSURL *url = [NSURL URLWithString:string];
    NSData *data = [NSData dataWithContentsOfURL:url];
    if (data == nil) {
        return;
    }
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    NSLog(@"dic = %@", dic);
    phoneString = [dic objectForKey:@"mobile"];

}

- (void)createTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT) style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor countLabelColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return cellDataArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 70;
    }else {
        return 45;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *JMSettingControllerIndetifier = @"JMSettingController";
    JMChoiseWithDrawCell *cell = [tableView dequeueReusableCellWithIdentifier:JMSettingControllerIndetifier];
    if (cell == nil) {
        cell = [[JMChoiseWithDrawCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:JMSettingControllerIndetifier];
    }
    NSDictionary *dict = cellDataArr[indexPath.row];
    [cell configSettingData:dict Index:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger index = indexPath.row;
    if (index == 1) {
        ChangeNicknameViewController *changeNicknameView = [[ChangeNicknameViewController alloc] initWithNibName:@"ChangeNicknameViewController" bundle:nil];
        changeNicknameView.nickNameText = nameString;
        changeNicknameView.blcok = ^(NSString *nameStr) {
            nameString = nameStr;
            NSDictionary *dict = cellDataArr[1];
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:dict];
            dic[@"descTitle"] = nameStr;
            [cellDataArr replaceObjectAtIndex:1 withObject:dic];
            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:1 inSection:0];
            [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
        };
        [self.navigationController pushViewController:changeNicknameView animated:YES];
    }else if (index == 2) {
        NSDictionary *dic = [[NSUserDefaults standardUserDefaults]objectForKey:@"userInfo"];
//        if ([phoneString isEqualToString:@""] && [[[NSUserDefaults standardUserDefaults] objectForKey:kLoginMethod] isEqualToString:kWeiXinLogin]) // -- > 不做判断
        WXLoginController *wxloginVC = [[WXLoginController alloc]  initWithNibName:@"WXLoginController" bundle:nil];
        wxloginVC.userInfo = dic;
        [self.navigationController pushViewController:wxloginVC animated:YES];
    }else if (index == 3) {
        VerifyPhoneViewController *verifyVC = [[VerifyPhoneViewController alloc] initWithNibName:@"VerifyPhoneViewController" bundle:nil];
        verifyVC.config = @{@"title":@"请验证手机",@"isUpdateMobile":@YES};
        [self.navigationController pushViewController:verifyVC animated:YES];
    }else if (index == 4) {
        ThirdAccountViewController *third = [[ThirdAccountViewController alloc] initWithNibName:@"ThirdAccountViewController" bundle:nil];
        [self.navigationController pushViewController:third animated:YES];
    }else if (index == 5) {
        AddressViewController *addressVC = [[AddressViewController alloc] initWithNibName:@"AddressViewController" bundle:nil];
        addressVC.isSelected = NO;
        [self.navigationController pushViewController:addressVC animated:YES];
    }else if (index == 6) {
        TSettingViewController *set = [[TSettingViewController alloc] init];
        [self.navigationController pushViewController:set animated:YES];
    }else if (index == 7) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setBool:NO forKey:@"login"];
        [userDefaults setObject:@"unlogin" forKey:kLoginMethod];
        
        [userDefaults setBool:NO forKey:@"isXLMM"];
        [userDefaults synchronize];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"logout" object:nil];
        
        //   http://m.xiaolu.so/rest/v1/users/customer_logout
        NSString *urlString = [NSString stringWithFormat:@"%@/rest/v1/users/customer_logout", Root_URL];
        [JMHTTPManager requestWithType:RequestTypePOST WithURLString:urlString WithParaments:nil WithSuccess:^(id responseObject) {
            NSDictionary *dic = responseObject;
            if ([[dic objectForKey:@"code"] integerValue] != 0) return;
            //注销账号
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            NSString *user_account = [user objectForKey:@"user_account"];
            if (!([user_account isEqualToString:@""] || [user_account class] == [NSNull null])) {
                [MiPushSDK unsetAccount:user_account];
                [user setObject:@"" forKey:@"user_account"];
            }
            
            //发送通知修改NewLeft中的用户信息
            [[NSNotificationCenter defaultCenter] postNotificationName:@"quit" object:nil];
            
            [self.navigationController popToRootViewControllerAnimated:YES];
            
            UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:nil message:@"退出成功" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(performDismiss:) userInfo:@{@"alterView":alterView} repeats:NO];
            
            [alterView show];
        } WithFail:^(NSError *error) {
            
        } Progress:^(float progress) {
            
        }];
    }
    
    
}
-(void) performDismiss:(NSTimer *)timer
{
    UIAlertView *Alert = [timer.userInfo objectForKey:@"alterView"];
    [Alert dismissWithClickedButtonIndex:0 animated:NO];
}


- (void)backClick:(UIButton *)button {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)getData:(NSDictionary *)dic {
    if (dic.count == 0) {
        return ;
    }
    nameString = dic[@"nick"];
    phoneString = dic[@"mobile"];
    NSMutableString * mutablePhoneNumber = [phoneString mutableCopy];
    NSRange range = {3,4};
    if (mutablePhoneNumber.length == 11) {
        [mutablePhoneNumber replaceCharactersInRange:range withString:@"****"];
    }
    
    
    NSArray *arr = @[@{
                        @"title":@"头像",
                        @"descTitle":@"",
                        @"iconImage":@"rightArrow",
                        @"cellImage":dic[@"thumbnail"]
                        },
                    @{
                        @"title":@"账户昵称",
                        @"descTitle":nameString,
                        @"iconImage":@"rightArrow",
                        @"cellImage":@""
                        },
                    @{
                        @"title":@"绑定手机",
                        @"descTitle":mutablePhoneNumber,
                        @"iconImage":@"rightArrow",
                        @"cellImage":@""
                        },
                    @{
                        @"title":@"修改密码",
                        @"descTitle":@"",
                        @"iconImage":@"rightArrow",
                        @"cellImage":@""
                        },
                    @{
                        @"title":@"第三方账户绑定",
                        @"descTitle":@"",
                        @"iconImage":@"rightArrow",
                        @"cellImage":@""
                        },
                    @{
                        @"title":@"收货地址管理",
                        @"descTitle":@"",
                        @"iconImage":@"rightArrow",
                        @"cellImage":@""
                        },
                    @{
                        @"title":@"设置",
                        @"descTitle":@"",
                        @"iconImage":@"rightArrow",
                        @"cellImage":@""
                        },
                    @{
                        @"title":@"退出账号",
                        @"descTitle":@"",
                        @"iconImage":@"rightArrow",
                        @"cellImage":@""
                        }
                    ];

    cellDataArr = [NSMutableArray arrayWithArray:arr];
    
    
}




@end
















































































































































