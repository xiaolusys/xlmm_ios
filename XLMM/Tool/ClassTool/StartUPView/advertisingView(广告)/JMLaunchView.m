//
//  JMLaunchView.m
//  XLMM
//
//  Created by zhang on 16/11/9.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMLaunchView.h"

NSString *const timeSecond = @"3";

@interface JMLaunchView ()

@property (nonatomic, strong) UIImageView *launchImage;

@property (nonatomic, strong) UIButton *skipButton;

@end

@implementation JMLaunchView

- (instancetype)initWithFrame:(CGRect)frame TimeInteger:(NSInteger)TimeInteger{
    
    if(self = [super initWithFrame:frame]){
        self.adImageFrame = frame;
        self.timeShowSecond = TimeInteger;
        self.frame = [UIScreen mainScreen].bounds;
        //        [self addSubview:self.LaunchImage];
        [self addSubview:self.adImageView];
        [self startNoDataDispathTiemr];
    }
    return self;
}

- (UIImageView *)adImageView{
    
    if(_adImageView == nil){
        _adImageView = [[UIImageView alloc]initWithFrame:self.adImageFrame];
        _adImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
        [_adImageView addGestureRecognizer:tap];
        
    }
    return _adImageView;
    
}

- (UIButton *)skipButton{
    
    if(_skipButton == nil){
        
        _skipButton = [[UIButton alloc]initWithFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width-70, 30, 60, 30)];
        [_skipButton setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.4]];
        _skipButton.layer.cornerRadius = 15;
        _skipButton.layer.masksToBounds = YES;
        NSInteger duration = [timeSecond integerValue];
        if(self.timeShowSecond) duration = self.timeShowSecond;
        [_skipButton setTitle:[NSString stringWithFormat:@"%ld 跳过",duration] forState:UIControlStateNormal];
        _skipButton.titleLabel.font = [UIFont systemFontOfSize:13.];
        [_skipButton addTarget:self action:@selector(skipAction) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _skipButton;
    
}



- (void)startNoDataDispathTiemr{
    
    NSTimeInterval period = 1.0;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _noDataTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    dispatch_source_set_timer(_noDataTimer, dispatch_walltime(NULL, 0), period * NSEC_PER_SEC, 0);
    
    __block NSInteger duration = 3;
    dispatch_source_set_event_handler(_noDataTimer, ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if(duration == 0){
                dispatch_source_cancel(_noDataTimer);
                [self removeView];
            }
            duration--;
            
            
        });
    });
    dispatch_resume(_noDataTimer);
}
- (void)dispathTiemr{
    
    if(_noDataTimer) dispatch_source_cancel(_noDataTimer);
    
    NSTimeInterval period = 1.0;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), period * NSEC_PER_SEC, 0);
    
    
    __block NSInteger duration = [timeSecond integerValue];
    if(self.timeShowSecond) duration = self.timeShowSecond;
    dispatch_source_set_event_handler(_timer, ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [_skipButton setTitle:[NSString stringWithFormat:@"%ld 跳过",duration] forState:UIControlStateNormal];
            if (duration == 0) {
                dispatch_source_cancel(_timer);
                [self removeView];
            }
            duration--;
            
        });
    });
    dispatch_resume(_timer);
    
}
- (void)animateEnd {
    CGFloat duration = [timeSecond floatValue];
    if(self.timeShowSecond)duration = self.timeShowSecond;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self removeView];
    });
}
- (void)skipAction{
    self.isClick = NO;
    if (_timer) dispatch_source_cancel(_timer);
    [self removeView];
    
    
}
- (void)removeView{
    if(self.timeFinish){
        if(self.clickAd == NO){
            self.timeFinish();
        }
    }
    [UIView animateWithDuration:0.5 animations:^{
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        self.transform = CGAffineTransformMakeScale(1.5, 1.5);
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
}
- (void)tapAction:(UITapGestureRecognizer *)tap{
    if(self.adImageClick){
        self.isClick = YES;
        self.adImageClick();
    }
}
-(void)setHideSkip:(BOOL)hideSkip {
    _hideSkip = hideSkip;
    if(!_hideSkip){
        [self.skipButton removeFromSuperview];
    }
}

+ (instancetype)initImageWithFrame:(CGRect)frame Image:(UIImage *)image TimeSecond:(NSInteger)timeSecond HideSkip:(BOOL)hideSkip LaunchAdClick:(launchAdClick)adImageClick TimeEnd:(timeEnd)timeFinish {
    if (image == nil) {
        return nil;
    }
    JMLaunchView *launchView = [[JMLaunchView alloc] initWithFrame:frame TimeInteger:timeSecond];
    launchView.hideSkip = hideSkip;
    launchView.clickAd = NO;
    launchView.adImageView.image = image;
    [launchView addSubview:launchView.skipButton];
    [launchView dispathTiemr];
    
    __weak typeof(launchView) weakLaunch = launchView;
    launchView.adImageClick = ^(){
        if(adImageClick){
            adImageClick();
            weakLaunch.clickAd = YES;
        }
    };
    launchView.timeFinish =^(){
        if(timeFinish){
            timeFinish();
        }
    };
    return launchView;

    
}









@end


































































