//
//  IosJsBridge.m
//  XLMM
//
//  Created by wulei on 6/16/16.
//  Copyright © 2016 上海己美. All rights reserved.
//

#import "IosJsBridge.h"
#import <UIKit/UIKit.h>
#import "JumpUtils.h"
#import "JMShareViewController.h"
#import "WebViewController.h"
#import "UMSocial.h"
#import "SendMessageToWeibo.h"
#import "WXApi.h"
#import "UUID.h"
#import "SSKeychain.h"


#define kService [NSBundle mainBundle].bundleIdentifier
#define kAccount @"so.xiaolu.m.xiaolumeimei"

@implementation IosJsBridge

+ (void)dispatchJsBridgeFunc:(UIViewController *)vc name:(NSString *)name para:(NSString*)para{
//    [JMNotificationCenter addObserver:vc selector:@selector(paySuccessful) name:@"ZhifuSeccessfully" object:nil];
//    [JMNotificationCenter addObserver:vc selector:@selector(popview) name:@"CancleZhifu" object:nil];
    
    NSDictionary *data = [self dictionaryWithJsonString:para];
    if ([name isEqualToString:@"jumpToNativeLocation"]) {
        
        [self jumpToNativeLocation:vc para:data];
    }
    else if ([name isEqualToString:@"callNativeUniShareFunc"]){
        [self callNativeUniShareFunc:vc para:data];
    }
    else if ([name isEqualToString:@"jumpToNativeLogin"]){
        [self jumpToNativeLogin:vc para:data];
    }
    else if ([name isEqualToString:@"getNativeMobileSNCode"]){
        [self getNativeMobileSNCode];
    }
    else if ([name isEqualToString:@"callNativeBack"]){
        [self callNativeBack:vc];
    }
    else if ([name isEqualToString:@"callNativeBackToHome"]){
        [self callNativeBackToHome:vc];
    }
    else if ([name isEqualToString:@"callNativeShareFunc"]){
        [self callNativeShareFunc:vc para:data];
    }
    else if ([name isEqualToString:@"showLoading"]){
        [self showLoading:data];
    }else if ([name isEqualToString:@"callNativePurchase"]) {
        [self jumpToCallNativePurchase:vc para:data];
    }else { }


}

/*
    支付
 */
+ (void)jumpToCallNativePurchase:(UIViewController *)vc para:(NSDictionary *)data{
    NSDictionary *dataDic = data[@"charge"];
    NSString *tidString = [NSString stringWithFormat:@"%@",dataDic[@"order_no"]];
    [JMNotificationCenter postNotificationName:@"fineCouponTid" object:tidString];
    [JumpUtils jumpToCallNativePurchase:dataDic Tid:tidString viewController:vc];
    
    
//    [Pingpp createPayment:data appURLScheme:kUrlScheme withCompletion:^(NSString *result, PingppError *error) {
//        
//        
//        
//        
//    }];
    
    
    
}


/*!
 * @brief 把格式化的JSON格式的字符串转换成字典
 * @param jsonString JSON格式的字符串
 * @return 返回字典
 */
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}
/*

 */
+ (void) universeShare:(UIViewController *)vc para:(NSDictionary *)data {
    JMShareViewController *shareView = [[JMShareViewController alloc] init];
    ((WebViewController *)vc).shareView = shareView;
    JMShareModel *model = [[JMShareModel alloc] init];
    model.share_type = [data objectForKey:@"share_type"];
    model.share_img = [data objectForKey:@"share_icon"]; //图片
    model.desc = [data objectForKey:@"share_desc"]; // 文字详情
    model.title = [data objectForKey:@"share_title"]; //标题
    model.share_link = [data objectForKey:@"link"];
    shareView.model = model;
    
    [[JMGlobal global] showpopBoxType:popViewTypeShare Frame:CGRectMake(0, SCREENHEIGHT, SCREENWIDTH, 240) ViewController:shareView WithBlock:^(UIView *maskView) {
    }];
    shareView.blcok = ^(UIButton *button) {
        [MobClick event:@"WebViewController_shareFail_cancel"];
    };

    
}

+ (NSString *)getMobileSNCode {
    if (![SSKeychain passwordForService:kService account:kAccount]) {
        NSString *uuid = [UUID gen_uuid];
        [SSKeychain setPassword:uuid forService:kService account:kAccount];
    }
    NSString *devicenumber = [SSKeychain passwordForService:kService account:kAccount];
    return devicenumber;
}


#pragma JSBRIDGE函数
+ (void)jumpToNativeLocation:(UIViewController *)vc para:(NSDictionary *)data{
    
    NSString *target_url = [data objectForKey:@"target_url"];
    [JumpUtils jumpToLocation:target_url viewController:vc];
}

/**
 *   统一的分享接口，注意这个jsbridge实现逻辑错误，需要重新按照接口文档的参数来重写此函数。
 */
+ (void)callNativeUniShareFunc:(UIViewController *)vc para:(NSDictionary *)data{
    NSLog(@"callNativeUniShareFunc");
    BOOL login = [JMUserDefaults boolForKey:@"login"];
    if (login == NO) {
        [[JMGlobal global] showLoginViewController];
        return;
    }else {
        [self universeShare:vc para:data];
    }

}
/**
 *   进入购物车  -- 判断是否登录
 */
+ (void)jumpToNativeLogin:(UIViewController *)vc para:(NSDictionary *)data{
    BOOL login = [JMUserDefaults boolForKey:@"login"];
    if (login == NO) {
        [[JMGlobal global] showLoginViewController];
        return;
    }else {
        NSString *target_url = [data objectForKey:@"target_url"];
        [JumpUtils jumpToLocation:target_url viewController:vc];
    }

}

+ (void)getNativeMobileSNCode{

    NSString *device = [self getMobileSNCode];


}

/**
 *  返回按钮
 */
+ (void)callNativeBack:(UIViewController *)vc{
    if(vc != nil){
        [vc.navigationController popViewControllerAnimated:YES];
    }
}
/**
 *  返回主页/
 */
+ (void)callNativeBackToHome:(UIViewController *)vc{
    if(vc != nil){
        [vc.navigationController popViewControllerAnimated:YES];
    }
}

/**
 *  老的分享接口，带活动id
 */
+ (void)callNativeShareFunc:(UIViewController *)vc para:(NSDictionary *)data {

    
    NSNumber *activeid = data[@"active_id"];
    NSString *platform = data[@"share_to"];
    if ([activeid integerValue] == 0) {
        //        activeid = @([_itemID integerValue]);
    }
    NSString *string = [NSString stringWithFormat:@"%@/rest/v1/activitys/%@/get_share_params", Root_URL, activeid];
    NSString *shareType = data[@"share_to"];
    
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:string WithParaments:nil WithSuccess:^(id responseObject) {
        NSString *shareTitle = [responseObject objectForKey:@"share_desc"];
        NSString *imageurl = [NSString stringWithFormat:@"%@%@",Root_URL, [responseObject objectForKey:@"picture"]];
        UIImage *newshareImage = [UIImage imagewithURLString:[imageurl imageShareCompression]];
        NSString *content = [responseObject objectForKey:@"share_desc"];
        UIImage *shareImage = [UIImage imagewithURLString:[[responseObject objectForKey:@"share_icon"] imageShareCompression]];
        NSString *sharelink = [responseObject objectForKey:@"share_link"];
        if ([platform isEqualToString:@""]) {
            ((WebViewController *)vc).activityId = [responseObject objectForKey:@"id"];
            ((WebViewController *)vc).share_model.share_type = [responseObject objectForKey:@"share_type"];
            ((WebViewController *)vc).share_model.share_img = [responseObject objectForKey:@"share_icon"]; //图片
            ((WebViewController *)vc).share_model.desc = [responseObject objectForKey:@"active_dec"]; // 文字详情
            ((WebViewController *)vc).share_model.title = [responseObject objectForKey:@"title"]; //标题
            ((WebViewController *)vc).share_model.share_link = [responseObject objectForKey:@"share_link"];
            [self universeShare:vc para:responseObject];
        }else if ([platform isEqualToString:@"wx"]) {
            [UMSocialData defaultData].extConfig.wechatSessionData.url = sharelink;
            [UMSocialData defaultData].extConfig.wechatSessionData.title = sharelink;
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:content image:shareImage location:nil urlResource:nil presentedController:vc completion:^(UMSocialResponseEntity *response){
            }];
        }else if ([platform isEqualToString:@"qq"]) {
            [UMSocialData defaultData].extConfig.qqData.url = sharelink;
            [UMSocialData defaultData].extConfig.qqData.title = shareTitle;
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQQ] content:content image:shareImage location:nil urlResource:nil presentedController:vc completion:^(UMSocialResponseEntity *response){
            }];
        }else if ([platform isEqualToString:@"sinawb"]){
            NSString *sina_content = [NSString stringWithFormat:@"%@%@",shareTitle, sharelink];
            [SendMessageToWeibo sendMessageWithText:sina_content andPicture:UIImagePNGRepresentation(shareImage)];
        } else if ([platform isEqualToString:@"web"]){
            UIPasteboard *pab = [UIPasteboard generalPasteboard];
            if ([NSString isStringEmpty:sharelink]) {
                [MBProgressHUD showMessage:@"复制失败"];
                return ;
            }else {
                [pab setString:sharelink];
                if (pab == nil) {
                    [MBProgressHUD showMessage:@"请重新复制"];
                }else
                {
                    [MBProgressHUD showMessage:@"已复制"];
                }
            }
            [MBProgressHUD showLoading:@"正在下载二维码..."];
            //            [self createKuaiZhaoImagewithlink:[responseObject objectForKey:@"qrcode_link"]];
            //            [self createKuaiZhaoImage];
        } else if ([platform isEqualToString:@"qqspa"]){
            [UMSocialData defaultData].extConfig.qzoneData.url = sharelink;
            [UMSocialData defaultData].extConfig.qzoneData.title = shareTitle;
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQzone] content:content image: shareImage location:nil urlResource:nil presentedController:vc completion:^(UMSocialResponseEntity *response){
            }];
        } else if ([platform isEqualToString:@"wxapp"]){
            if ([[responseObject objectForKey:@"share_type"] isEqualToString:@"link"]) {
                NSLog(@"wx");
                [UMSocialData defaultData].extConfig.wechatSessionData.title = shareTitle;
                [UMSocialData defaultData].extConfig.wechatSessionData.url = sharelink;
                [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:content image:shareImage location:nil urlResource:nil presentedController:vc completion:^(UMSocialResponseEntity *response){
                }];
            } else {
                [MBProgressHUD showLoading:@"正在生成快照..."];
                //                [self createKuaiZhaoImage];
            }
        }  else if ([platform isEqualToString:@"pyq"]){
            
            NSLog(@"friends");
            
            if ([[responseObject objectForKey:@"share_type"] isEqualToString:@"link"]) {
                [UMSocialData defaultData].extConfig.wechatTimelineData.url = sharelink;
                [UMSocialData defaultData].extConfig.wechatTimelineData.title = shareTitle;
                [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:content image:shareImage location:nil urlResource:nil presentedController:vc completion:^(UMSocialResponseEntity *response){
                }];
            } else{
                
                [MBProgressHUD showLoading:@"正在生成快照..."];
                //                  isWXFriends = NO;
                //                [self createKuaiZhaoImage];
            }
            
        } else{}
    } WithFail:^(NSError *error) {
        
    } Progress:^(float progress) {
        
    }];
}

/**
 *  详情界面加载
 */
+ (void)showLoading:(NSDictionary *)data{
    BOOL isLoading = [data[@"isLoading"] boolValue];
    if (!isLoading) {
        [MBProgressHUD hideHUD];
    }
}




@end
