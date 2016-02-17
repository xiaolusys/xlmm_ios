//
//  MMLoadingAnimation.m
//  XLMM
//
//  Created by younishijie on 15/12/25.
//  Copyright © 2015年 上海己美. All rights reserved.
//

#import "MMLoadingAnimation.h"
#import "UIColor+RGBColor.h"
#import "MMClass.h"

#define PAGE 21
#define CIRCLEPAGE 25

@interface MMLoadingAnimation()

@property(nonatomic, strong)UIImageView *imageV;
@property(nonatomic, strong)UIView *shadeView;
@property(nonatomic, strong)NSMutableArray *imgArr;

@end

@implementation MMLoadingAnimation{
}

- (UIImageView *)imageV {
    if (!_imageV) {
//        self.imageV = [[UIImageView alloc] initWithFrame:self.frame];
        self.imageV = [[UIImageView alloc] initWithFrame:CGRectMake(SCREENWIDTH * 0.5 - 75, 0, 150, 335)];
        _imageV.contentMode = UIViewContentModeScaleAspectFit;
        _imageV.alpha = 1.0;
    }
    return _imageV;
}

- (UIView *)shadeView {
    if (!_shadeView) {
        self.shadeView = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width * 0.5 - 38, 315, 50, 20)];
        _shadeView.backgroundColor = [UIColor loadingViewBackgroundColor];
//        _shadeView.backgroundColor = [UIColor redColor];
        _shadeView.alpha = 0.5;
    }
    return _shadeView;
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

//- (instancetype)initWithFrame:(CGRect)frame{
//    self = [super initWithFrame:frame];
//    if(self){
//    }
//    return self;
//}

+ (void)showLoadingView{
    [[MMLoadingAnimation sharedView] showLoadingView];
}
+ (void)dismissLoadingView{
    [[MMLoadingAnimation sharedView] dismissLoadingView];
}

+ (void)showLoadingViewOfGif {
    [[MMLoadingAnimation sharedView] runGifForImage];
}

- (void)showLoadingView{
    [self startLoadingAnimating];
    
}
- (void)dismissLoadingView{
    self.imageV.animationImages = nil;
    [self.imageV setAnimationImages:nil];
    [self removeFromSuperview];
}

-(void)startLoadingAnimating {
//    self.imageV = [[UIImageView alloc] initWithFrame:self.frame];
    
    
    [self addSubview:self.imageV];

    [self createFirstAnimating];
//    [self performSelector:@selector(createSecondAnimating) withObject:nil afterDelay:1.5];
    

    self.backgroundColor = [[UIColor loadingViewBackgroundColor] colorWithAlphaComponent:1.0];
}



-(void)stopLoadingAnimating {
    self.imageV.animationImages = nil;
    [self.imageV setAnimationImages:nil];
    [self removeFromSuperview];
}

- (void)createFirstAnimating {
//    self.shadeView = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width * 0.5 - 38, self.frame.size.height * 0.5 + 23, 76, 40)];
//    self.shadeView.backgroundColor = [UIColor loadingViewBackgroundColor];
//    self.shadeView.alpha = 0.5;
//    self.shadeView.backgroundColor = [UIColor colorWithRed:99 / 255.0 green:99 / 255.0 blue:99 / 255.0 alpha:0.2];
    
    [self addSubview:self.shadeView];
    
    
    NSMutableArray *imgArr = [NSMutableArray array];
    NSString *name = nil;
    for (int i = 1; i < PAGE; i++) {
        name = [NSString stringWithFormat:@"loading动画00%d", i];
        NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"png"];
        UIImage *img =[UIImage imageWithContentsOfFile:path];
        
        [imgArr addObject:img];
    }
    [self.imageV setAnimationImages:imgArr];
    self.imageV.animationDuration = 2.5;
    self.imageV.animationRepeatCount = 100;
    
    
    [UIView beginAnimations:@"animationID" context:nil];
    [UIView setAnimationRepeatCount:500];
    
    [UIView setAnimationDuration:1.5];
    self.shadeView.frame = CGRectMake(self.frame.size.width * 0.5 + 38, 315, 50, 20);
    [UIView commitAnimations];

    [self.imageV startAnimating];
}



- (void)createSecondAnimating {
    NSMutableArray *imgArr = [NSMutableArray array];
    NSString *name = nil;
    for (int i = CIRCLEPAGE; i < PAGE; i++) {
        name = [NSString stringWithFormat:@"loading动画00%d", i];
        NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"png"];
        UIImage *img =[UIImage imageWithContentsOfFile:path];
        [imgArr addObject:img];
    }
    [self.imageV setAnimationImages:imgArr];
    self.imageV.animationDuration = 0.5;
    self.imageV.animationRepeatCount = 500;
    [self.imageV startAnimating];
}


- (void)runGifForImage {
    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.frame];
    webView.backgroundColor = [UIColor redColor];
    webView.scalesPageToFit = YES;
    NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"run" ofType:@"gif"]];
    
    [webView loadData:data MIMEType:@"image/gif" textEncodingName:nil baseURL:nil];
    [self addSubview:webView];
}

@end
