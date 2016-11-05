//
//  JMLaunchView.h
//  XLMM
//
//  Created by zhang on 16/11/3.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>

//typedef void(^LaunchAdCallback)(); // (UIImage *image, NSString *ImageURL);
typedef void (^LaunchAdClick)();
typedef void (^EndPlays)();

@interface JMLaunchView : UIView

@property (nonatomic,copy) dispatch_source_t timer;

@property (nonatomic,copy) dispatch_source_t noDataTimer;
// 广告显示秒数
@property (nonatomic, assign) NSInteger timeInteger;
// 广告图frame
@property (nonatomic, assign) CGRect imageFrame;
// 广告图
@property (nonatomic, strong) UIImageView *advertisingImageView;

@property (nonatomic,assign) BOOL isClick;
// 是否显示跳过按钮
@property (nonatomic, assign) BOOL hideSkip;
// 是否点击广告
@property (nonatomic, assign) BOOL clickAds;
// 点击广告图
@property (nonatomic, copy) LaunchAdClick ImageClick;
// 广告加载完
//@property (nonatomic, copy) LaunchAdCallback launchAdCallback;
// 广告播放结束
@property (nonatomic, copy) EndPlays endPlays;
/**
 *  WZXLaunchAd
 *
 *  @param frame            广告图片的位置
 *  @param imageURL         加载广告的URL 可以是图片 也可以是GIF
 *  @param timeSecond       广告的时长
 *  @param hideSkip         是否隐藏“跳过按钮” YES隐藏  NO显示
 *  @param LaunchAdCallback 广告图片加载完成 回调
 *  @param ImageClick       点击广告 回调
 *  @param endPlays         广告播放结束 回调
 *
 *  @return WZXLaunchAd
 */
- (instancetype)initImageWithframe:(CGRect)frame imageURL:(NSString *)imageURL timeSecond:(NSInteger )timeSecond hideSkip:(BOOL)hideSkip ImageClick:(LaunchAdClick)ImageClick endPlays:(EndPlays)endPlays;
//- (instancetype)initImageWithframe:(CGRect)frame imageURL:(NSString *)imageURL timeSecond:(NSInteger )timeSecond hideSkip:(BOOL)hideSkip LaunchAdCallback:(LaunchAdCallback)LaunchAdCallback ImageClick:(LaunchAdClick)ImageClick endPlays:(EndPlays)endPlays;





@end
















































