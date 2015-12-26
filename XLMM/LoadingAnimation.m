//
//  LoadingAnimation.m
//  DH
//
//  Created by 张迎 on 15/12/25.
//  Copyright © 2015年 张迎. All rights reserved.
//

#define PAGE 78
#define CIRCLEPAGE 25

#import "LoadingAnimation.h"


@interface LoadingAnimation()
{
    NSInteger _count;
}
@property(nonatomic, strong)UIImageView *imageV;
@property(nonatomic, strong)UIView *shadeView;
@end

@implementation LoadingAnimation

-(void)startLoadingAnimating {
    self.imageV = [[UIImageView alloc] initWithFrame:self.frame];
    self.imageV.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:self.imageV];
    
    [self createFirstAnimating];
    [self performSelector:@selector(createSecondAnimating) withObject:nil afterDelay:3];
    
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
    
    [UIView setAnimationDuration:3];
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
    self.imageV.animationDuration = 1.5;
    self.imageV.animationRepeatCount = 500;
    [self.imageV startAnimating];
}


- (void)runGifForImage {
//    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.frame];
//    webView.backgroundColor = [UIColor redColor];
//    webView.scalesPageToFit = YES;
//    NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"run" ofType:@"gif"]];
//    [webView loadData:data MIMEType:@"image/gif" textEncodingName:nil baseURL:nil];
//    [self addSubview:webView];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
