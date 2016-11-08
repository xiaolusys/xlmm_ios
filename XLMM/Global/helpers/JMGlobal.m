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


static BOOL isNetPrompt;

@interface JMGlobal () <UIAlertViewDelegate> {
    NSString *httpStatus;
}




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
                httpStatus = @"2G";
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




@end








































































































