//
//  JMLaunchView.m
//  XLMM
//
//  Created by zhang on 16/11/3.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMLaunchView.h"
#import "JMStoreManager.h"

NSString *const TimerSender = @"3";

@interface JMLaunchView ()

@property (nonatomic, strong) UIButton *skipButton; // 跳过按钮


@end

@implementation JMLaunchView

- (UIImageView *)advertisingImageView{
    
    if(_advertisingImageView == nil){
        _advertisingImageView = [[UIImageView alloc]initWithFrame:self.imageFrame];
        _advertisingImageView.userInteractionEnabled = YES;
        //        _adImageView.alpha = 0.2;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
        [_advertisingImageView addGestureRecognizer:tap];
        
    }
    return _advertisingImageView;
    
}
- (UIButton *)skipButton{
    
    if(_skipButton == nil){
        
        _skipButton = [[UIButton alloc]initWithFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width-70, 30, 60, 30)];
        [_skipButton setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.4]];
        _skipButton.layer.cornerRadius = 15;
        _skipButton.layer.masksToBounds = YES;
        NSInteger duration = [TimerSender integerValue];
        if(self.timeInteger) duration = self.timeInteger;
        [_skipButton setTitle:[NSString stringWithFormat:@"%ld 跳过",duration] forState:UIControlStateNormal];
        _skipButton.titleLabel.font = [UIFont systemFontOfSize:13.];
        [_skipButton addTarget:self action:@selector(skipClick) forControlEvents:UIControlEventTouchUpInside];
        
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
- (void)dispathTiemr {
    if(_noDataTimer) dispatch_source_cancel(_noDataTimer);
    
    NSTimeInterval period = 1.0;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), period * NSEC_PER_SEC, 0);
    __block NSInteger duration = [TimerSender integerValue];
    if(self.timeInteger) duration = self.timeInteger;
    dispatch_source_set_event_handler(_timer, ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.skipButton setTitle:[NSString stringWithFormat:@"%ld 跳过",duration] forState:UIControlStateNormal];
            if(duration==0)
            {
                dispatch_source_cancel(_timer);
                
                [self removeView];
            }
            duration--;
            
        });
    });
    dispatch_resume(_timer);
    
}

- (instancetype)initImageWithframe:(CGRect)frame imageURL:(NSString *)imageURL timeSecond:(NSInteger )timeSecond hideSkip:(BOOL)hideSkip ImageClick:(LaunchAdClick)ImageClick endPlays:(EndPlays)endPlays {
    if(self = [super initWithFrame:frame]){
        if ([NSString isStringEmpty:imageURL]) {
            self.hidden = YES;
            return self;
        }
        self.clickAds = NO;
        self.imageFrame = frame;
        self.timeInteger = timeSecond;
        self.hideSkip = hideSkip;
        UIImage *averImage = [UIImage imagewithURLString:imageURL];
        [self addSubview:self.advertisingImageView];
        self.advertisingImageView.image = averImage;
        [self startNoDataDispathTiemr];
        [self addSubview:self.skipButton];
        [self dispathTiemr];
        // 这里使用异步加载图片会导致第一次加载图片的时候先加载主页,然后在回调下载完成的图片...... LaunchAdCallback -- > 这里可以回调图片和url,但是此处不需要这些参数
//        [self.advertisingImageView sd_setImageWithURL:[NSURL URLWithString:imageURL] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//        }];
//        if(LaunchAdCallback){
//            LaunchAdCallback();
//        }
        __weak typeof(self) weakLaunch = self;
        self.ImageClick = ^(){
            if(ImageClick){
                ImageClick();
                weakLaunch.clickAds = YES;
            }
        };
        self.endPlays =^(){
            if(endPlays){
                endPlays();
            }
        };
    }
    return self;
}
- (void)removeView{
    if(self.endPlays){
        if(self.clickAds == NO){
            self.endPlays();
        }
    }
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.transform = CGAffineTransformMakeScale(1.5, 1.5);
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
- (void)skipClick{
    
    self.isClick = NO;
    if (_timer) dispatch_source_cancel(_timer);
    [self removeView];
    
    
}
- (void)tapClick:(UITapGestureRecognizer *)tap {
    [self removeView]; // 点击图片先移除广告图
    if(self.ImageClick){
        self.isClick = YES;
        self.ImageClick();
    }
}
-(void)setHideSkip:(BOOL)hideSkip{
    
    _hideSkip = hideSkip;
    
    if(!_hideSkip){
        [self.skipButton removeFromSuperview];
    }
    
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end




















































































