//
//  JumpUtils.m
//  XLMM
//
//  Created by wulei on 4/25/16.
//  Copyright © 2016 上海己美. All rights reserved.
//

#import "JumpUtils.h"
#import "MMClass.h"
#import "YouHuiQuanViewController.h"
#import "MaMaPersonCenterViewController.h"
#import "PublishNewPdtViewController.h"
#import "MMCollectionController.h"
#import "MMDetailsViewController.h"
#import "XiangQingViewController.h"
#import "HomeViewController.h"
#import "XlmmMall.h"
#import "ChildViewController.h"
#import "TuihuoViewController.h"
#import "ProductSelectionListViewController.h"
#import "CartViewController.h"
#import "WebViewController.h"

@implementation JumpUtils
#pragma mark 解析targeturl 跳转到不同的界面
+ (void)jumpToLocation:(NSString *)target_url viewController:(UIViewController *)vc{
    
    BOOL login = [[NSUserDefaults standardUserDefaults] boolForKey:@"login"];
    
    if (target_url == nil) {
        NSLog(@"target_url null");
        return;
    }
    if ([target_url isEqualToString:@"com.jimei.xlmm://app/v1/products/promote_today"]) {
        //跳到今日上新
        [vc.navigationController popToRootViewControllerAnimated:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"fromActivityToToday" object:nil userInfo:@{@"param":@"today"}];
        
    } else if ([target_url isEqualToString:@"com.jimei.xlmm://app/v1/products/promote_previous"]){
        //跳到昨日推荐
        [vc.navigationController popToRootViewControllerAnimated:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"fromActivityToToday" object:nil userInfo:@{@"param":@"previous"}];
        
    } else if ([target_url isEqualToString:@"com.jimei.xlmm://app/v1/products/childlist"]){
        //跳到潮童专区
        ChildViewController *childVC = [[ChildViewController alloc] initWithNibName:@"ChildViewController" bundle:[NSBundle mainBundle]];
        childVC.urlString = kCHILD_LIST_URL;
        childVC.orderUrlString = kCHILD_LIST_ORDER_URL;
        childVC.childClothing = YES;
        
        [vc.navigationController pushViewController:childVC animated:YES];
    } else if ([target_url isEqualToString:@"com.jimei.xlmm://app/v1/products/ladylist"]){
        //跳到时尚女装
        ChildViewController *womanVC = [[ChildViewController alloc] initWithNibName:@"ChildViewController" bundle:[NSBundle mainBundle]];
        womanVC.urlString = kLADY_LIST_URL;
        womanVC.orderUrlString = kLADY_LIST_ORDER_URL;
        womanVC.childClothing = NO;
        
        [vc.navigationController pushViewController:womanVC animated:YES];
    } else if ([target_url isEqualToString:@"com.jimei.xlmm://app/v1/usercoupons/method"]){
        //跳转到用户未过期优惠券列表
        YouHuiQuanViewController *youhuiVC = [[YouHuiQuanViewController alloc] initWithNibName:@"YouHuiQuanViewController" bundle:nil];
        youhuiVC.isSelectedYHQ = NO;
        [vc.navigationController pushViewController:youhuiVC animated:YES];
        
    }  else if ([target_url isEqualToString:@"com.jimei.xlmm://app/v1/vip_home"]){
        //  跳转到小鹿妈妈界面
        MaMaPersonCenterViewController *ma = [[MaMaPersonCenterViewController alloc] initWithNibName:@"MaMaPersonCenterViewController" bundle:nil];
        [vc.navigationController pushViewController:ma animated:YES];
        
    }else if ([target_url isEqualToString:@"com.jimei.xlmm://app/v1/vip_0day"]){
        //跳转到小鹿妈妈每日上新
        PublishNewPdtViewController *publish = [[PublishNewPdtViewController alloc] init];
        [vc.navigationController pushViewController:publish animated:YES];
        
    }else if ([target_url isEqualToString:@"com.jimei.xlmm://app/v1/refunds"]) {
        //跳转到退款退货列表
        TuihuoViewController *tuihuoVC = [[TuihuoViewController alloc] initWithNibName:@"TuihuoViewController" bundle:nil];
        [vc.navigationController pushViewController:tuihuoVC animated:YES];
        
    }
    else if ([target_url isEqualToString:@"com.jimei.xlmm://app/v1/vip_choice"]) {
        //跳转到选品上架
        ProductSelectionListViewController *mamachoiceVC = [[ProductSelectionListViewController alloc] init];
        [vc.navigationController pushViewController:mamachoiceVC animated:YES];
        
    }else {
        
    }
    
    if ([target_url isEqualToString:@"com.jimei.xlmm://app/v1/shopping_cart"]) {
        //跳转到shopping cart
//        CartViewController *cartVC = [[CartViewController alloc] initWithNibName:@"CartViewController" bundle:nil];
//        [vc.navigationController pushViewController:cartVC animated:YES];
        BOOL login = [[NSUserDefaults standardUserDefaults] boolForKey:@"login"];
        
        if (login == NO) {
            JMLogInViewController *enterVC = [[JMLogInViewController alloc] init];
            [vc.navigationController pushViewController:enterVC animated:YES];
            return;
        }else {
            
            CartViewController *cartVC = [[CartViewController alloc] initWithNibName:@"CartViewController" bundle:nil];
            [vc.navigationController pushViewController:cartVC animated:YES];
        }

    }

    else if([target_url rangeOfString:@"?"].length > 0){
        NSArray *components = [target_url componentsSeparatedByString:@"?"];
        
        NSString *parameter = [components lastObject];
        NSArray *params = [parameter componentsSeparatedByString:@"="];
        NSString *firstparam = [params firstObject];
        if ([firstparam isEqualToString:@"model_id"]) {
            //跳到集合页面
            NSLog(@"model_id = %@", [params lastObject]);
            NSMutableDictionary *web_dic = [NSMutableDictionary dictionary];
            [web_dic setValue:[params lastObject] forKey:@"web_url"];
            
            WebViewController *webView = [[WebViewController alloc] init];
            webView.webDiction = web_dic;
            
            [vc.navigationController pushViewController:webView animated:YES];
            
        } else if ([firstparam isEqualToString:@"product_id"]){
            //跳到商品详情
            NSLog(@"product_id = %@", [params lastObject]);
            NSMutableDictionary *web_dic = [NSMutableDictionary dictionary];
            [web_dic setValue:[params lastObject] forKey:@"web_url"];
            
            WebViewController *webView = [[WebViewController alloc] init];
            webView.webDiction = web_dic;

            [vc.navigationController pushViewController:webView animated:YES];
            
            
        } else if ([firstparam isEqualToString:@"trade_id"]){
            //跳到订单详情
            NSLog(@"trade_id = %@", [params lastObject]);
            XiangQingViewController *xiangqingVC = [[XiangQingViewController alloc] initWithNibName:@"XiangQingViewController" bundle:nil];
            
            // xiangqingVC.dingdanModel = [dataArray objectAtIndex:indexPath.row];
            xiangqingVC.urlString = [NSString stringWithFormat:@"%@/rest/v2/trades/%@", Root_URL, [params lastObject]];
            [vc.navigationController pushViewController:xiangqingVC animated:YES];
        } else if ([firstparam isEqualToString:@"is_native"]){
            NSLog(@"跳到H5首页 url= %@", [params lastObject]);
            NSMutableDictionary *web_dic = [NSMutableDictionary dictionary];
            [web_dic setValue:[params lastObject] forKey:@"web_url"];
            WebViewController *webView = [[WebViewController alloc] init];
            webView.webDiction = web_dic;
            webView.isShowNavBar =true;
            webView.isShowRightShareBtn=true;
            [vc.navigationController pushViewController:webView animated:YES];
        } else if([firstparam isEqualToString:@"activity_id"]){

            NSMutableDictionary *web_dic = [NSMutableDictionary dictionary];
            [web_dic setValue:[params lastObject] forKey:@"web_url"];
            [web_dic setValue:@"active" forKey:@"type_title"];
            
            NSArray *id_params = [params[1] componentsSeparatedByString:@"&"];
            NSString *id_param = [id_params firstObject];
            [web_dic setValue:id_param forKey:@"activity_id"];
            NSLog(@"跳到activity_id id=%@ url= %@", id_param, [params lastObject]);
            
            WebViewController *webView = [[WebViewController alloc] init];
            webView.webDiction = web_dic;
            webView.isShowNavBar =true;
            webView.isShowRightShareBtn=true;
            [vc.navigationController pushViewController:webView animated:YES];
        }
        
    }
    
}
@end
/**
 *  if ([target_url isEqualToString:@"com.jimei.xlmm://app/v1/shopping_cart"]) {
 if (login == NO) {
 JMLogInViewController *enterVC = [[JMLogInViewController alloc] init];
 
 [vc.navigationController pushViewController:enterVC animated:YES];
 return;
 }else {
 CartViewController *cartVC = [[CartViewController alloc] initWithNibName:@"CartViewController" bundle:nil];
 
 [vc.navigationController pushViewController:cartVC animated:YES];
 }
 }else
 */
