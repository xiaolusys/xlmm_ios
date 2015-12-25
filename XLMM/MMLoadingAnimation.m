//
//  MMLoadingAnimation.m
//  XLMM
//
//  Created by younishijie on 15/12/25.
//  Copyright © 2015年 上海己美. All rights reserved.
//

#import "MMLoadingAnimation.h"

#define PAGE 78
#define CIRCLEPAGE 25

@interface MMLoadingAnimation()
{
    
}
@property(nonatomic, strong)UIImageView *imageV;
@property(nonatomic, strong)UIView *shadeView;

@end

@implementation MMLoadingAnimation{
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
}


+ (MMLoadingAnimation *)sharedView{
    static MMLoadingAnimation *_sharedView = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        _sharedView = [[MMLoadingAnimation alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    });
    return _sharedView;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
     
        
        
    }
    return self;
}

+ (void)showLoadingView{
    [[MMLoadingAnimation sharedView] showLoadingView];
}
+ (void)dismissLoadingView{
    [[MMLoadingAnimation sharedView] dismissLoadingView];
    
}

- (void)showLoadingView{
    [self startLoadingAnimating];
    
}
- (void)dismissLoadingView{
    [self removeFromSuperview];
}

-(void)startLoadingAnimating {
    self.imageV = [[UIImageView alloc] initWithFrame:self.frame];
    self.imageV.contentMode = UIViewContentModeScaleAspectFit;
    
    [self addSubview:self.imageV];
    self.imageV.backgroundColor = [UIColor whiteColor];
    
    [self createFirstAnimating];
    [self performSelector:@selector(createSecondAnimating) withObject:nil afterDelay:1.5];
    
}



-(void)stopLoadingAnimating {
    [self removeFromSuperview];
}

- (void)createFirstAnimating {
    self.shadeView = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width * 0.5 - 38, self.frame.size.height * 0.5 + 23, 76, 40)];
    self.shadeView.backgroundColor = [UIColor whiteColor];
    self.shadeView.alpha = 0.5;
    [self addSubview:self.shadeView];
    
    NSMutableArray *imgArr = [NSMutableArray array];
    NSString *name = nil;
    for (int i = 1; i < PAGE; i++) {
        name = [NSString stringWithFormat:@"loading动画00%d", i];
        UIImage *img = [UIImage imageNamed:name];
        [imgArr addObject:img];
    }
    [self.imageV setAnimationImages:imgArr];
    self.imageV.animationDuration = 2.5;
    self.imageV.animationRepeatCount = 1;
    
    
    [UIView beginAnimations:@"animationID"  context:nil];
    [UIView setAnimationRepeatCount:500];
    
    [UIView setAnimationDuration:1.5];
    self.shadeView.frame = CGRectMake(self.frame.size.width * 0.5 + 38, self.frame.size.height * 0.5 + 23, 76, 40);
    [UIView commitAnimations];
    
    
    [self.imageV startAnimating];
}



- (void)createSecondAnimating {
    NSMutableArray *imgArr = [NSMutableArray array];
    NSString *name = nil;
    for (int i = CIRCLEPAGE; i < PAGE; i++) {
        name = [NSString stringWithFormat:@"loading动画00%d", i];
        UIImage *img = [UIImage imageNamed:name];
        [imgArr addObject:img];
    }
    [self.imageV setAnimationImages:imgArr];
    self.imageV.animationDuration = 1.0;
    self.imageV.animationRepeatCount = 500;
    [self.imageV startAnimating];
}


   
    




@end
