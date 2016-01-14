//
//  PhotoView.m
//  XLMM
//
//  Created by 张迎 on 16/1/7.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "PhotoView.h"
#import "UIImageView+WebCache.h"

#define SWIDTH [UIScreen mainScreen].bounds.size.width
#define SHEIGHT [UIScreen mainScreen].bounds.size.height

@interface PhotoView ()

@property (nonatomic, strong)UIScrollView *scrollView;
@property (nonatomic, strong)UIPageControl *pageControl;

@end


@implementation PhotoView

////重写初始化方法 ／／初始化方法。。。
//- (instancetype)initWithFrame:(CGRect)frame {
//    self = [super initWithFrame:frame];
//    if (self) {
//        self.backgroundColor = [UIColor blackColor];
//    }
//    return self;
//}

- (void)createScrollView {
    [self createScrollViewAndPageControl];
    [self addGestureRecognizerForView];
}

- (void)fillData:(NSInteger)index
       cellFrame:(CGRect)cellFrame {
    self.index = index;
    self.cellFrame = cellFrame;
    //初始位置
    self.scrollView.contentOffset = CGPointMake(SWIDTH * self.index, 0);
    self.pageControl.currentPage = self.index;
    
    [self picAddToScrollView];
}
//图片加入到ScrollView
- (void)picAddToScrollView {
    //换成对应的位置
    CGFloat smallX = self.cellFrame.origin.x + self.index * SWIDTH;
    
    CGFloat smallY = 0;
    if (self.cellFrame.origin.y / SHEIGHT > 1) {
        smallY = self.cellFrame.origin.y - self.contentOffY;
    }else {
        smallY = self.cellFrame.origin.y;
    }
    
    UIImageView *imageIndex = [[UIImageView alloc] initWithFrame:CGRectMake(smallX, smallY, 80, 80)];
    NSString *url = self.picArr[self.index];
    [imageIndex sd_setImageWithURL:[NSURL URLWithString:url]];
    
    [UIView animateWithDuration:0.3 animations:^{
        imageIndex.frame = CGRectMake(self.index * SWIDTH, 0, SWIDTH, SHEIGHT);
    }];
    [self.scrollView addSubview:imageIndex];
    
    //添加图片
    for (int i = 0; i < self.picArr.count; i++) {
        if (self.index == i)continue;
        UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(i * SWIDTH, 0, SWIDTH, SHEIGHT)];
        [imageV sd_setImageWithURL:self.picArr[self.index]];
        [self.scrollView addSubview:imageV];
    }
}

// 创建ScrollView 和 PageControl
- (void)createScrollViewAndPageControl {
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    self.scrollView.contentSize = CGSizeMake(SWIDTH * self.picArr.count, SHEIGHT);
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.delegate = self;
    [self addSubview:self.scrollView];
    
    
    
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(SWIDTH * 0.5 - 60, SHEIGHT - 34, 120, 20)];
    self.pageControl.numberOfPages = self.picArr.count;
    self.pageControl.currentPageIndicatorTintColor = [UIColor orangeColor];
    self.pageControl.pageIndicatorTintColor = [UIColor colorWithRed:120 / 256.0 green:120 / 256.0 blue:120 / 256.0 alpha:0.4];
    [self addSubview:self.pageControl];
}

- (void)addGestureRecognizerForView {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelShade)];
    [self addGestureRecognizer:tap];
}


//点击图片返回
- (void)cancelShade {
    //清除所有的照片
    [UIView animateWithDuration:0.5 animations:^{
        [self removeFromSuperview];
    }];
    for (UIImageView *imageV in self.scrollView.subviews) {
        imageV.image = nil;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.index = self.scrollView.contentOffset.x / SWIDTH;
    self.pageControl.currentPage = self.index;
}

@end
