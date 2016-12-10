//
//  PhotoView.m
//  XLMM
//
//  Created by 张迎 on 16/1/7.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "PhotoView.h"


#define SWIDTH [UIScreen mainScreen].bounds.size.width
#define SHEIGHT [UIScreen mainScreen].bounds.size.height

@interface PhotoView ()

@property (nonatomic, strong)UIScrollView *scrollView;
@property (nonatomic, strong)UIPageControl *pageControl;

@end


@implementation PhotoView

////重写初始化方法 ／／初始化方法。。。
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor pothoViewBackgroundColor];
    }
    return self;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        self.scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.delegate = self;
        [self addSubview:_scrollView];
    }
    return _scrollView;
}

- (UIPageControl *)pageControl {
    if (!_pageControl) {
        self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(SWIDTH * 0.5 - 60, SHEIGHT - 34, 120, 20)];
        _pageControl.currentPageIndicatorTintColor = [UIColor pagecontrolBackgroundColor];
        _pageControl.pageIndicatorTintColor = [UIColor pagecontrolCurrentIndicatorColor];
        [self addSubview:_pageControl];
    }
    return _pageControl;
}

- (void)createScrollView {
    [self addGestureRecognizerForView];
}

- (void)fillData:(NSInteger)index
       cellFrame:(CGRect)cellFrame {
    self.index = index;
    self.cellFrame = cellFrame;
    
    self.scrollView.contentSize = CGSizeMake(SWIDTH * self.picArr.count, SHEIGHT);
    self.pageControl.numberOfPages = self.picArr.count;
    
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
    NSInteger countNum = self.picArr.count;
    
    NSString *joinUrl = [url imageNormalCompression]; // [NSString stringWithFormat:@"%@?imageMogr2/thumbnail/289/format/jpg/quality/90", url];
    if (countNum < 9) {
        if (self.index == (countNum - 1)) {
            joinUrl = self.picArr[self.index];
        }
    }else {
        if (self.index == 4) {
            joinUrl = self.picArr[4];
        }
    }
    

//    [imageIndex sd_setImageWithURL:[NSURL URLWithString:joinUrl]];
    __block float imageWidth = 0.0;
    __block float imageHeight = 0.0;
    [imageIndex sd_setImageWithURL:[NSURL URLWithString:joinUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        imageWidth = SWIDTH;
        if (image.size.width == 0) {
            imageHeight = 0;
        }else {
            imageHeight = image.size.height/image.size.width * SWIDTH;
        }
        CGFloat imageIndexY = (SHEIGHT - imageHeight) * 0.5;
        [UIView animateWithDuration:0.3 animations:^{
            imageIndex.frame = CGRectMake(self.index * SWIDTH, imageIndexY, SWIDTH, imageHeight);
        }];
    }];
    [self.scrollView addSubview:imageIndex];
    
    //添加图片
    for (int i = 0; i < countNum; i++) {
        if (self.index == i)continue;
    
        UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(i * SWIDTH , 0, 80, 80)];
//        __block UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
//        activityIndicator.center = imageV.center;
//        [activityIndicator startAnimating];
        
        NSString *joinUrl = [self.picArr[i] imageNormalCompression]; // [NSString stringWithFormat:@"%@?imageMogr2/thumbnail/289/format/jpg/quality/90", self.picArr[i]];
        if (countNum < 9) {
            if (i == countNum - 1) {
                joinUrl = self.picArr[i];
            }
        }else {
            if (i == 4) {
                joinUrl = self.picArr[4];
            }
        }
        __block float imagew = 0.0;
        __block float imageh = 0.0;
        

        
        [imageV sd_setImageWithURL:[NSURL URLWithString:joinUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//            [activityIndicator removeFromSuperview];
//            activityIndicator = nil;
            imagew = SWIDTH;
            if (image.size.width == 0) {
                imageh = 0;
            }else {
                imageh = image.size.height/image.size.width * SWIDTH;
            }
            CGFloat imageY = (SHEIGHT - imageh) * 0.5;
            imageV.frame = CGRectMake(i * SWIDTH, imageY, SWIDTH, imageh);
            imagew = 0;
            imageh = 0;
        }];
    
        [self.scrollView addSubview:imageV];
//        [self.scrollView addSubview:activityIndicator];
    }
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
