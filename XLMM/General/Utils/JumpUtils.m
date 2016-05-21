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

@implementation JumpUtils
#pragma mark 解析targeturl 跳转到不同的界面
+ (void)jumpToLocation:(NSString *)target_url viewController:(UIViewController *)vc{
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
        
    }
    if ([target_url isEqualToString:@"com.jimei.xlmm://app/v1/shopping_cart"]) {
        //跳转到shopping cart
        CartViewController *cartVC = [[CartViewController alloc] initWithNibName:@"CartViewController" bundle:nil];
        [vc.navigationController pushViewController:cartVC animated:YES];
    }

    else if([target_url rangeOfString:@"?"].length > 0){
        NSArray *components = [target_url componentsSeparatedByString:@"?"];
        
        NSString *parameter = [components lastObject];
        NSArray *params = [parameter componentsSeparatedByString:@"="];
        NSString *firstparam = [params firstObject];
        if ([firstparam isEqualToString:@"model_id"]) {
            //跳到集合页面
            NSLog(@"model_id = %@", [params lastObject]);
            
            MMCollectionController *collectionVC = [[MMCollectionController alloc] initWithNibName:@"MMCollectionController" bundle:nil modelID:[params lastObject] isChild:NO];
            
            [vc.navigationController pushViewController:collectionVC animated:YES];
            
            
            
        } else if ([firstparam isEqualToString:@"product_id"]){
            //跳到商品详情
            NSLog(@"product_id = %@", [params lastObject]);
            
            MMDetailsViewController *details = [[MMDetailsViewController alloc] initWithNibName:@"MMDetailsViewController" bundle:nil modelID:[params lastObject] isChild:NO];
            [vc.navigationController pushViewController:details animated:YES];
            
            
        } else if ([firstparam isEqualToString:@"trade_id"]){
            //跳到订单详情
            NSLog(@"trade_id = %@", [params lastObject]);
            XiangQingViewController *xiangqingVC = [[XiangQingViewController alloc] initWithNibName:@"XiangQingViewController" bundle:nil];
            
            // xiangqingVC.dingdanModel = [dataArray objectAtIndex:indexPath.row];
            xiangqingVC.urlString = [NSString stringWithFormat:@"%@/rest/v1/trades/%@/details", Root_URL, [params lastObject]];
            [vc.navigationController pushViewController:xiangqingVC animated:YES];
        } else if ([firstparam isEqualToString:@"is_native"]){
            NSLog(@"跳到H5首页 url= %@", [params lastObject]);
        }
    }
    
}
@end

