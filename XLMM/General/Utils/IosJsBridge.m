//
//  IosJsBridge.m
//  XLMM
//
//  Created by wulei on 6/16/16.
//  Copyright © 2016 上海己美. All rights reserved.
//

#import "IosJsBridge.h"
#import <UIKit/UIKit.h>
#import "SVProgressHUD.h"
#import "JumpUtils.h"
#import "JMLogInViewController.h"
#import "JMShareViewController.h"
#import "JMShareView.h"
#import "JMPopView.h"
#import "MMClass.h"
#import "WebViewController.h"
#import "AFNetworking.h"
#import "UMSocial.h"
#import "SendMessageToWeibo.h"
#import "WXApi.h"
#import "YoumengShare.h"
#import "NSString+URL.h"
#import "UUID.h"
#import "SSKeychain.h"

#define kService [NSBundle mainBundle].bundleIdentifier
#define kAccount @"so.xiaolu.m.xiaolumeimei"

@implementation IosJsBridge
+ (void)dispatchJsBridgeFunc:(UIViewController *)vc name:(NSString *)name para:(NSString*)para{
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
    else if ([name isEqualToString:@"callNativeShareFunc"]){
        [self callNativeShareFunc:vc para:data];
    }
    else if ([name isEqualToString:@"showLoading"]){
        [self showLoading:data];
    }


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

+ (void) universeShare:(UIViewController *)vc para:(NSDictionary *)data {
    JMShareViewController *shareView = [[JMShareViewController alloc] init];
    ((WebViewController *)vc).shareView = shareView;
    
    if([((WebViewController *)vc).webDiction[@"type_title"] isEqualToString:@"ProductDetail"]){
        ((WebViewController *)vc).share_model.share_type = [data objectForKey:@"share_type"];
        
        ((WebViewController *)vc).share_model.share_img = [data objectForKey:@"share_icon"]; //图片
        ((WebViewController *)vc).share_model.desc = [data objectForKey:@"share_desc"]; // 文字详情
        
        ((WebViewController *)vc).share_model.title = [data objectForKey:@"share_title"]; //标题
        ((WebViewController *)vc).share_model.share_link = [data objectForKey:@"link"];
    }
    shareView.model = ((WebViewController *)vc).share_model;
    
    JMShareView *cover = [JMShareView show];
    cover.delegate = ((WebViewController *)vc);
    //弹出视图
    JMPopView *menu = [JMPopView showInRect:CGRectMake(0, SCREENHEIGHT - 240, SCREENWIDTH, 240)];
    menu.contentView = shareView.view;
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
    BOOL login = [[NSUserDefaults standardUserDefaults] boolForKey:@"login"];
    if (login == NO) {
        JMLogInViewController *enterVC = [[JMLogInViewController alloc] init];
        [vc.navigationController pushViewController:enterVC animated:YES];
        return;
    }else {
        [self universeShare:vc para:data];
    }

}
/**
 *   进入购物车  -- 判断是否登录
 */
+ (void)jumpToNativeLogin:(UIViewController *)vc para:(NSDictionary *)data{
    BOOL login = [[NSUserDefaults standardUserDefaults] boolForKey:@"login"];
    if (login == NO) {
        JMLogInViewController *enterVC = [[JMLogInViewController alloc] init];
        [vc.navigationController pushViewController:enterVC animated:YES];
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
 *  老的分享接口，带活动id
 */
+ (void)callNativeShareFunc:(UIViewController *)vc para:(NSDictionary *)data{

    
    NSNumber *activeid = data[@"active_id"];
    NSString *platform = data[@"share_to"];
    if ([activeid integerValue] == 0) {
        //        activeid = @([_itemID integerValue]);
    }
    NSString *string = [NSString stringWithFormat:@"%@/rest/v1/activitys/%@/get_share_params", Root_URL, activeid];
    NSString *shareType = data[@"share_to"];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:string parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
            NSString *str = sharelink;
            if (str == nil) {
                [SVProgressHUD showSuccessWithStatus:@"复制失败"];
                return ;
            }
            [pab setString:str];
            if (pab == nil) {
                [SVProgressHUD showErrorWithStatus:@"请重新复制"];
            }else
            {
                [SVProgressHUD showSuccessWithStatus:@"已复制"];
            }
            [SVProgressHUD showWithStatus:@"正在下载二维码..."];
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
                [SVProgressHUD showWithStatus:@"正在生成快照..."];
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
                
                [SVProgressHUD showWithStatus:@"正在生成快照..."];
                //                  isWXFriends = NO;
                //                [self createKuaiZhaoImage];
            }
            
        } else{}
    }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         }];
}

/**
 *  详情界面加载
 */
+ (void)showLoading:(NSDictionary *)data{
    BOOL isLoading = data[@"isLoading"];
    if (!isLoading) {
        [SVProgressHUD dismiss];
    }
}




@end