//
//  JumpUtils.m
//  XLMM
//
//  Created by wulei on 4/25/16.
//  Copyright © 2016 上海己美. All rights reserved.
//

#import "JumpUtils.h"
#import "MMClass.h"
#import "NSString+URL.h"
#import "PublishNewPdtViewController.h"
#import "MMCollectionController.h"
#import "JMHomeRootController.h"
#import "XlmmMall.h"
#import "ChildViewController.h"
#import "ProductSelectionListViewController.h"
#import "CartViewController.h"
#import "WebViewController.h"
#import "JMOrderDetailController.h"
//#import "JMMaMaPersonCenterController.h"
#import "JMSegmentController.h"
#import "JMRefundBaseController.h"
#import "JMLogInViewController.h"
#import "JMGoodsDetailController.h"
#import "JMClassifyListController.h"
#import "JMMaMaRootController.h"

@implementation JumpUtils
#pragma mark 解析targeturl 跳转到不同的界面
+ (void)jumpToLocation:(NSString *)target_url viewController:(UIViewController *)vc{
    
    BOOL login = [[NSUserDefaults standardUserDefaults] boolForKey:@"login"];
    
    if (target_url == nil) {
        NSLog(@"target_url null");
        return;
    }
//    target_url =  [target_url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
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
        JMClassifyListController *categoryVC = [[JMClassifyListController alloc] init];
        categoryVC.titleString = @"童装专区";
        categoryVC.cid = @"1";
        [vc.navigationController pushViewController:categoryVC animated:YES];
    } else if ([target_url isEqualToString:@"com.jimei.xlmm://app/v1/products/ladylist"]){
        //跳到时尚女装
        JMClassifyListController *categoryVC = [[JMClassifyListController alloc] init];
        categoryVC.titleString = @"女装专区";
        categoryVC.cid = @"2";
        [vc.navigationController pushViewController:categoryVC animated:YES];
    } else if ([target_url isEqualToString:@"com.jimei.xlmm://app/v1/usercoupons/method"]){
        //跳转到用户未过期优惠券列表
        JMSegmentController *youhuiVC = [[JMSegmentController alloc] init];
        youhuiVC.isSelectedYHQ = NO;
        [vc.navigationController pushViewController:youhuiVC animated:YES];
        
    }  else if ([target_url isEqualToString:@"com.jimei.xlmm://app/v1/vip_home"]){
        //  跳转到小鹿妈妈界面
        JMMaMaRootController *mamaCenterVC = [[JMMaMaRootController alloc] init];
//        JMMaMaPersonCenterController *ma = [[JMMaMaPersonCenterController alloc] init];
        [vc.navigationController pushViewController:mamaCenterVC animated:YES];
        
    }else if ([target_url isEqualToString:@"com.jimei.xlmm://app/v1/vip_0day"]){
        //跳转到小鹿妈妈每日上新
        PublishNewPdtViewController *publish = [[PublishNewPdtViewController alloc] init];
        [vc.navigationController pushViewController:publish animated:YES];
        
    }else if ([target_url isEqualToString:@"com.jimei.xlmm://app/v1/refunds"]) {
        //跳转到退款退货列表
        JMRefundBaseController *tuihuoVC = [[JMRefundBaseController alloc] init];
        [vc.navigationController pushViewController:tuihuoVC animated:YES];
        
    }
    else if ([target_url isEqualToString:@"com.jimei.xlmm://app/v1/vip_choice"]) {
        //跳转到选品上架
        ProductSelectionListViewController *mamachoiceVC = [[ProductSelectionListViewController alloc] init];
        [vc.navigationController pushViewController:mamachoiceVC animated:YES];
        
    }else if ([target_url isEqualToString:@"com.jimei.xlmm://app/v1/shopping_cart"]) {
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
    else if([target_url hasPrefix:@"com.jimei.xlmm://app/v1/brand"]){
        //经过跟秀清讨论，直接跳转商品列表的需求还需要整理，暂时屏蔽
        //[self jumpToBrand:target_url viewController:vc];
    }
    else if([target_url hasPrefix:@"com.jimei.xlmm://app/v1/products/modellist?"]){
        [self jumpToModelProduct:target_url viewController:vc];
    }
    else if([target_url hasPrefix:@"com.jimei.xlmm://app/v1/products?"]){
        [self jumpToProduct:target_url viewController:vc];
    }
    else if([target_url hasPrefix:@"com.jimei.xlmm://app/v1/trades/details?"]){
        [self jumpToTrade:target_url viewController:vc];
    }
    else if([target_url hasPrefix:@"com.jimei.xlmm://app/v1/webview?"]){
        [self jumpToWebview:target_url viewController:vc];
    }else if ([target_url hasPrefix:@"com.jimei.xlmm://app/v1/products/category?"]){
        [self jumpToCategoryProduct:target_url viewController:vc];
    }else if ([target_url isEqualToString:@"com.jimei.xlmm://app/v1/vip_forum"]){
        //  跳转到小鹿妈妈forum界面
        WebViewController *webVC = [[WebViewController alloc] init];
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setValue:@"http://forum.xiaolumeimei.com/accounts/xlmm/login/" forKey:@"web_url"];
        webVC.webDiction = dict;
        webVC.isShowNavBar = true;
        webVC.isShowRightShareBtn = false;
        [vc.navigationController pushViewController:webVC animated:YES];

        
    }
    
}

+(void) jumpToBrand:(NSString *)target_url viewController:(UIViewController *)vc{
    if([target_url rangeOfString:@"?"].length > 0){
        NSArray *components = [target_url componentsSeparatedByString:@"?"];
        NSString *parameter = [target_url substringFromIndex:([[components firstObject] length] + 1)];
        
        NSArray *params = [parameter componentsSeparatedByString:@"&"];
        NSArray *firstparams = [[params firstObject] componentsSeparatedByString:@"="];
        NSString *firstparam = [firstparams firstObject];
        NSString *firstvalue = [[params firstObject] substringFromIndex:([[firstparams firstObject] length] + 1)];
        NSLog(@"firstparams %@  %@", firstparam, firstvalue);
        if ([firstparam isEqualToString:@"activity_id"]) {
            MMCollectionController *brandVC = [[MMCollectionController alloc] init];
            brandVC.activityId = firstvalue;
            [vc.navigationController pushViewController:brandVC animated:YES];
            
        }
    }

}

+(void) jumpToModelProduct:(NSString *)target_url viewController:(UIViewController *)vc{
    NSArray *components = [target_url componentsSeparatedByString:@"?"];
    NSString *parameter = [target_url substringFromIndex:([[components firstObject] length] + 1)];
    
    NSArray *params = [parameter componentsSeparatedByString:@"&"];
    NSArray *firstparams = [[params firstObject] componentsSeparatedByString:@"="];
    NSString *firstparam = [firstparams firstObject];
    NSString *firstvalue = [[params firstObject] substringFromIndex:([[firstparams firstObject] length] + 1)];
    NSLog(@"firstparams %@  %@", firstparam, firstvalue);
    if ([firstparam isEqualToString:@"model_id"]) {
        //跳到集合页面
        NSLog(@"model_id = %@", firstvalue);
        NSMutableDictionary *web_dic = [NSMutableDictionary dictionary];
        [web_dic setValue:firstvalue forKey:@"web_url"];
        [web_dic setValue:@"ProductDetail" forKey:@"type_title"];
        
        WebViewController *webView = [[WebViewController alloc] init];
        webView.webDiction = web_dic;
        webView.isShowNavBar =false;
        webView.isShowRightShareBtn=false;
        [vc.navigationController pushViewController:webView animated:YES];
        
    }

}

+(void) jumpToProduct:(NSString *)target_url viewController:(UIViewController *)vc{
    NSArray *components = [target_url componentsSeparatedByString:@"?"];
    NSString *parameter = [target_url substringFromIndex:([[components firstObject] length] + 1)];
    
    NSArray *params = [parameter componentsSeparatedByString:@"&"];
    NSArray *firstparams = [[params firstObject] componentsSeparatedByString:@"="];
    NSString *firstparam = [firstparams firstObject];
    NSString *firstvalue = [[params firstObject] substringFromIndex:([[firstparams firstObject] length] + 1)];
    NSLog(@"firstparams %@  %@", firstparam, firstvalue);
    //  "target_url" = "com.jimei.xlmm://app/v1/products?product_id=http://m.xiaolumeimei.com/mall/product/details/17716";
    
    if ([firstparam isEqualToString:@"product_id"]){
        //跳到商品详情
        NSArray *denghaoArr = [target_url componentsSeparatedByString:@"="];
        NSString *denghaoStr = [denghaoArr lastObject];
        NSArray *xiahuaxianArr = [denghaoStr componentsSeparatedByString:@"/"];
        NSString *goodsID = [xiahuaxianArr lastObject];
        
        JMGoodsDetailController *goodsDetailVC = [[JMGoodsDetailController alloc] init];
        goodsDetailVC.goodsID = goodsID;
        [vc.navigationController pushViewController:goodsDetailVC animated:YES];
//        NSLog(@"product_id = %@", firstvalue);
//        NSMutableDictionary *web_dic = [NSMutableDictionary dictionary];
//        [web_dic setValue:firstvalue forKey:@"web_url"];
//        [web_dic setValue:@"ProductDetail" forKey:@"type_title"];
//        
//        WebViewController *webView = [[WebViewController alloc] init];
//        webView.webDiction = web_dic;
//        webView.isShowNavBar =false;
//        webView.isShowRightShareBtn=false;
//        [vc.navigationController pushViewController:webView animated:YES];
    }

}

+(void) jumpToTrade:(NSString *)target_url viewController:(UIViewController *)vc{
    NSArray *components = [target_url componentsSeparatedByString:@"?"];
    NSString *parameter = [target_url substringFromIndex:([[components firstObject] length] + 1)];
    
    NSArray *params = [parameter componentsSeparatedByString:@"&"];
    NSArray *firstparams = [[params firstObject] componentsSeparatedByString:@"="];
    NSString *firstparam = [firstparams firstObject];
    NSString *firstvalue = [[params firstObject] substringFromIndex:([[firstparams firstObject] length] + 1)];
    NSLog(@"firstparams %@  %@", firstparam, firstvalue);
    if ([firstparam isEqualToString:@"trade_id"]){
        //跳到订单详情
        NSLog(@"trade_id = %@", firstvalue);
        JMOrderDetailController *orderDetailVC = [[JMOrderDetailController alloc] init];
        //            XiangQingViewController *xiangqingVC = [[XiangQingViewController alloc] initWithNibName:@"XiangQingViewController" bundle:nil];
        
        // xiangqingVC.dingdanModel = [dataArray objectAtIndex:indexPath.row];
        orderDetailVC.urlString = [NSString stringWithFormat:@"%@/rest/v2/trades/%@?device=app", Root_URL, firstvalue];
        [vc.navigationController pushViewController:orderDetailVC animated:YES];
    }

}

+(void) jumpToWebview:(NSString *)target_url viewController:(UIViewController *)vc{
    NSArray *components = [target_url componentsSeparatedByString:@"?"];
    NSString *parameter = [target_url substringFromIndex:([[components firstObject] length] + 1)];
    
    NSArray *params = [parameter componentsSeparatedByString:@"&"];
    NSArray *firstparams = [[params firstObject] componentsSeparatedByString:@"="];
    NSString *firstparam = [firstparams firstObject];
    NSString *firstvalue = [[params firstObject] substringFromIndex:([[firstparams firstObject] length] + 1)];
    NSString *urlString = nil;
    NSLog(@"firstparams %@  %@", firstparam, firstvalue);
    if ([firstparam isEqualToString:@"is_native"] || [firstparam isEqualToString:@"url"]){
        NSString *secondvalue = nil;
        NSMutableDictionary *web_dic = [NSMutableDictionary dictionary];
        if ([firstparam isEqualToString:@"is_native"]){
            params = [parameter componentsSeparatedByString:@"url="];
            secondvalue = params[1];
            
            urlString =  secondvalue;

        }else {
            params = [parameter componentsSeparatedByString:@"&is_native="];
            firstvalue = [[params firstObject] substringFromIndex:([@"url=" length])];
            secondvalue = [params lastObject];
            
            urlString =  firstvalue;
        }
        
        NSString *urlStringDecode = [urlString JMURLDecodedString];
        [web_dic setValue:urlStringDecode forKey:@"web_url"];

        NSLog(@"跳到H5首页 firstvalue= %@ secondvalue=%@", firstvalue, secondvalue);
        
        WebViewController *webView = [[WebViewController alloc] init];
        webView.webDiction = web_dic;
        webView.isShowNavBar =true;
        webView.isShowRightShareBtn=true;
        [vc.navigationController pushViewController:webView animated:YES];
    } else if([firstparam isEqualToString:@"activity_id"] || [firstparam isEqualToString:@"url"]){

        NSString *secondvalue = nil;
        NSMutableDictionary *web_dic = [NSMutableDictionary dictionary];
        
        [web_dic setValue:@"active" forKey:@"type_title"];
        if ([firstparam isEqualToString:@"activity_id"]){
            params = [parameter componentsSeparatedByString:@"url="];
            secondvalue = params[1];
            urlString =  secondvalue;
            
            [web_dic setValue:firstvalue forKey:@"activity_id"];
        }
        else{
            params = [parameter componentsSeparatedByString:@"&activity_id="];
            firstvalue = [[params firstObject] substringFromIndex:([@"url=" length])];
            secondvalue = [params lastObject];
            urlString =  firstvalue;
            
            [web_dic setValue:secondvalue forKey:@"activity_id"];
        }
        NSLog(@"跳到activity_id firstvalue=%@ secondvalue= %@", firstvalue, secondvalue);
        NSString *urlStringDecode = [urlString JMURLDecodedString];
        [web_dic setValue:urlStringDecode forKey:@"web_url"];
        
        WebViewController *webView = [[WebViewController alloc] init];
        webView.webDiction = web_dic;
        webView.isShowNavBar =true;
        webView.isShowRightShareBtn=true;
        [vc.navigationController pushViewController:webView animated:YES];
    }
}

+(void) jumpToCategoryProduct:(NSString *)target_url viewController:(UIViewController *)vc{
    if([target_url rangeOfString:@"?"].length > 0){
        NSArray *components = [target_url componentsSeparatedByString:@"?"];
        NSString *parameter = [target_url substringFromIndex:([[components firstObject] length] + 1)];
        
        NSArray *params = [parameter componentsSeparatedByString:@"&"];
        NSArray *firstparams = [[params firstObject] componentsSeparatedByString:@"="];
        NSString *firstparam = [firstparams firstObject];
        NSString *firstvalue = [[params firstObject] substringFromIndex:([[firstparams firstObject] length] + 1)];
        NSLog(@"firstparams %@  %@", firstparam, firstvalue);
        if ([firstparam isEqualToString:@"cid"]) {
            JMClassifyListController *categoryVC = [[JMClassifyListController alloc] init];
            categoryVC.titleString = @"分类商品";
            categoryVC.cid = firstvalue;
            [vc.navigationController pushViewController:categoryVC animated:YES];
            
        }
    }
    
}

@end










































