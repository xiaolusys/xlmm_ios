//
//  JMGlobal.m
//  XLMM
//
//  Created by zhang on 16/11/8.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMGlobal.h"
#import "JMStoreManager.h"
#import "JMDevice.h"
#import "JMHTTPManager.h"
#import "JMRepopView.h"
#import "JMPopViewAnimationSpring.h"
#import "JMRefreshLoadView.h"



static BOOL isNetPrompt;

@interface JMGlobal () <UIAlertViewDelegate> {
    NSString *httpStatus;
}
@property (nonatomic, strong) JMRefreshLoadView *loadView;
@property (nonatomic, strong) UIView *maskView;


@end


@implementation JMGlobal

+ (JMGlobal *)global {
    static JMGlobal *global = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        global = [[JMGlobal alloc] init];
    });
    return global;
}
- (void)clearAllSDCache {
    // 停止所有的下载
    [[SDWebImageManager sharedManager] cancelAll];
    // 删除缓存
    [[SDWebImageManager sharedManager].imageCache clearMemory];
}
#pragma mark ---------- 弹出视图 (分享,选择框等) ----------
- (void)showpopBoxType:(popType)type Frame:(CGRect)frame ViewController:(UIViewController *)viewController WithBlock:(void (^)(UIView *maskView))clickBlock {
    JMShareView *cover = [JMShareView show];
    JMPopView *menu = [JMPopView showInRect:frame];
    menu.contentView = viewController.view;
    cover.blcok = ^(JMShareView *coverView) {
        [JMShareView hide];
        [JMPopView hide];
        [MobClick event:@"WebViewController_shareFail_masking"];
    };
    
//    cover.blcok = clickBlock;
}
#pragma mark ---------- 弹出视图 (活动信息) ----------
- (void)showpopForReceiveCouponFrame:(CGRect)frame WithBlock:(void (^)(UIView *maskView))clickBlock ActivePopBlock:(void (^)(UIButton *button))activeBlock {
    JMShareView *cover = [JMShareView show];
    JMRepopView *popView = [JMRepopView showInRect:frame];
    cover.blcok = ^(JMShareView *coverView) {
        // 这里点击蒙版没有效果
    };
    popView.activeBlock = activeBlock;
//    popView.activeBlock = ^(UIButton *button) {
//        if (button.tag == 100) {
//            
//        }else {
//            [JMShareView hide];
//            [JMRepopView hide];
//        }
//    };
    
    [JMPopViewAnimationSpring showView:popView overlayView:cover];
}


#pragma mark ---- 获取 dayNumber (-前,+后) 的时间 ----
- (BOOL)currentTimeWithBeforeDays:(NSInteger)dayNumber {
    NSString *currentTime = [NSString getCurrentTime];
    [JMStoreManager saveDataFromString:@"caveCurrentTimeWithSDImageCacke.txt" WithString:currentTime];
    NSString *beforeTime = [NSString getBeforeDay:dayNumber];
    NSString *saveCurrentTime = [JMStoreManager getDataString:@"caveCurrentTimeWithSDImageCacke.txt"];
    if ([self compareData:beforeTime SaveData:saveCurrentTime] == -1) {
        [JMStoreManager removeFileByFileName:@"caveCurrentTimeWithSDImageCacke.txt"];
        [JMStoreManager saveDataFromString:@"caveCurrentTimeWithSDImageCacke.txt" WithString:currentTime];
        return YES;
    }
    return NO;
}


#pragma mark ---------- 清除缓存 ----------
- (void)clearCacheWithSDImageCache:(clearCacheBlock)cacheBlock {
    [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
        NSString * path = [NSHomeDirectory() stringByAppendingString:@"/Library/Caches/default/com.hackemist.SDWebImageCache.default"];
        NSLog(@"path = %@", path);
        NSDictionary * dict = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil];
        NSLog(@"file size = %@",[dict objectForKey:NSFileSize]);
        float sizeValue = [[dict objectForKey:NSFileSize] integerValue]/200.0f;
        if (sizeValue < 1.0) {
            sizeValue = 0.0f;
        }
        NSString *cacheString = [NSString stringWithFormat:@"%.1fM", sizeValue];
        if (cacheBlock) {
            cacheBlock(cacheString);
        }
    }];
}

#pragma mark ---------- 监听网络状态 ----------
- (void)monitoringNetworkStatus {
    isNetPrompt = YES;
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        //这里是监测到网络改变的block  可以写成switch方便
        //在里面可以随便写事件
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
            {
                httpStatus = @"other";
                NSLog(@"未知网络状态");
                break;
            }
            case AFNetworkReachabilityStatusNotReachable:
            {
                httpStatus = @"noNet";
                NSLog(@"无网络");
                if (isNetPrompt) {
                    isNetPrompt = NO;
                    UIAlertView *alterView = [[UIAlertView alloc]  initWithTitle:nil message:@"无网络连接，请检查您的网络" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alterView show];
                }
                break;
            }
            case AFNetworkReachabilityStatusReachableViaWWAN:
            {
                httpStatus = @"2G|3G|4G";
                NSLog(@"蜂窝数据网");
                break;
            }
            case AFNetworkReachabilityStatusReachableViaWiFi:
            {
                NSLog(@"WiFi网络");
                httpStatus = @"wifi";
                break;
            }
            default:
                break;
        }
        NSString* phoneModel = [[JMDevice defaultDecice] getUserAgent];
        NSString *userAgent = [NSString stringWithFormat:@"%@ NetType/%@",phoneModel,httpStatus];
        [[JMHTTPManager shareManager].requestSerializer setValue:userAgent forHTTPHeaderField:@"User-Agent"];
    }] ;
    [manager startMonitoring];
    
}

#pragma mark ======== 请求个人信息,保存登录信息 ========
- (void)upDataLoginStatus {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *urlString = [NSString stringWithFormat:@"%@/rest/v1/users/profile", Root_URL];
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:urlString WithParaments:nil WithSuccess:^(id responseObject) {
        if (!responseObject) return;
        NSDictionary *result = responseObject;
        if (([result objectForKey:@"id"] != nil)  && ([[result objectForKey:@"id"] integerValue] != 0)) {
            // 手机登录成功 ，保存用户信息以及登录途径
            [defaults setBool:YES forKey:kIsLogin];
            NSLog(@"Still logined");
        } else{
            // 手机登录需要 ，保存用户信息以及登录途径
            [defaults setBool:NO forKey:kIsLogin];
            NSLog(@"maybe cookie timeout,need login");
        }
    } WithFail:^(NSError *error) {
        // 手机登录需要 ，保存用户信息以及登录途径
        [defaults setBool:NO forKey:kIsLogin];
        NSLog(@"maybe cookie timeout,need login");
    } Progress:^(float progress) {
    }];
}

#pragma mark ======== 跳转页面等待动画 ========
- (void)showWaitLoadingInView:(UIView *)viewController {
    if (self.loadView) {
        [self.loadView removeFromSuperview];
        self.loadView = nil;
    }
    if (!self.loadView) {
        UIView *maskView = [[UIView alloc] init];
        maskView.frame = viewController.bounds;
        maskView.backgroundColor = [UIColor whiteColor];
        [viewController addSubview:maskView];
        self.maskView = maskView;
        self.loadView = [[JMRefreshLoadView alloc] initWithFrame:CGRectMake(maskView.mj_w / 2 - 18, maskView.mj_h / 2 - 18, 36, 36)];
        [maskView addSubview:self.loadView];
    }
    [self.loadView setLineLayerStrokeWithProgress:100];
    [self.loadView startLoading];
}
- (void)hideWaitLoading {
    if (!self.loadView) {
        return ;
    }
    [self.loadView endLoading];
    if (self.loadView) {
        [self.loadView removeFromSuperview];
        self.loadView = nil;
        [self.maskView removeFromSuperview];
    }
}


/*
    befoData -- > 获取的当前时间几天 前/后 的时间 .
    saveData -- > 需要判断的时间(保存的时间)
 */
- (NSInteger)compareData:(NSString *)befoData SaveData:(NSString *)saveData {
    NSInteger compCount;
    NSComparisonResult result = [befoData compare:saveData];
    if (result == NSOrderedSame) {
        compCount = 0;
    }else if (result == NSOrderedAscending) {
        // saveData 大
        compCount = 1;
    }else if (result == NSOrderedDescending) {
        compCount = -1;
    }else { }
    return compCount;
}

- (int)secondOFCurrentTimeInEndtimeInt:(int)endTime {
    NSDate *lastDate = [NSDate dateWithTimeIntervalSince1970:endTime];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];  // 设置时间格式
    NSString *currentTime = [dateFormatter stringFromDate:lastDate];
    return [self secondOfCurrentTimeInEndTime:currentTime];
}
- (int)secondOfCurrentTimeInEndTime:(NSString *)endTime {
    if ([NSString isStringEmpty:endTime]) {
        return 0;
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];  // 设置时间格式
    //    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
    //    [dateFormatter setTimeZone:timeZone]; //设置时区 ＋8:00
    NSString *currentTime = [dateFormatter stringFromDate:[NSDate date]];
    NSDate *someDayDate = [dateFormatter dateFromString:currentTime];
    NSDate *date = [dateFormatter dateFromString:endTime]; // 结束时间
    NSTimeInterval time = [date timeIntervalSinceDate:someDayDate];  //结束时间距离当前时间的秒数
    NSLog(@"结束时间距离当前时间的秒数: %lld 秒",(long long int)time);
    return time;
}






@end








































































































