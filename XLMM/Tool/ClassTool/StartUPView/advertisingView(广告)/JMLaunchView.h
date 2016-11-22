//
//  JMLaunchView.h
//  XLMM
//
//  Created by zhang on 16/11/9.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^launchAdClick)();
typedef void(^timeEnd)();




@interface JMLaunchView : UIView

@property (nonatomic, copy) dispatch_source_t timer;
@property (nonatomic, copy) dispatch_source_t noDataTimer;


@property (nonatomic, assign) NSInteger timeShowSecond;
@property (nonatomic, strong) UIImageView *adImageView;
@property (nonatomic, copy) launchAdClick adImageClick;
@property (nonatomic, copy) timeEnd timeFinish;

@property (nonatomic, assign) CGRect adImageFrame;
@property (nonatomic, assign) BOOL hideSkip;
@property (nonatomic, assign) BOOL clickAd;
@property (nonatomic, assign) BOOL isClick;


+ (instancetype)initImageWithFrame:(CGRect)frame Image:(UIImage *)image TimeSecond:(NSInteger)timeSecond HideSkip:(BOOL)hideSkip LaunchAdClick:(launchAdClick)adImageClick TimeEnd:(timeEnd)timeFinish;






@end






























