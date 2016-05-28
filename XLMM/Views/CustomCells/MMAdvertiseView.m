//
//  MMAdvertiseView.m
//  TestView001
//
//  Created by younishijie on 16/2/2.
//  Copyright © 2016年 上海己美网络科技有限公司. All rights reserved.
//

#import "MMAdvertiseView.h"
#import "UIColor+RGBColor.h"
#import "ImageUtils.h"
#import "NSString+URL.h"

#define width [[UIScreen mainScreen] bounds].size.width
#define height self.frame.size.height
@implementation MMAdvertiseView



- (instancetype)initWithFrame:(CGRect)frame andImages:(NSArray *)imageurls{
    self = [super initWithFrame:frame];
    NSLog(@"-MMAdvertiseView-initWithFrame----width %f height %f %@", width, height, NSStringFromCGRect(frame));
    if (self) {
        _imageurls = imageurls;
        NSLog(@"MMAdvertiseView _images = %@", _imageurls);
        _imageCount = _imageurls.count;
        
        NSLog(@"MMAdvertiseView _count = %ld", (long)_imageCount);
        _currentImageIndex = 0;
        self.looptime = 4.0;
        //添加滚动控件
        [self addScrollView];
        //添加图片控件
        [self addImageViews];
        //添加分页控件
        [self addPageControl];
        
        [self setDefaultImage];
        
        [self createTimer];
    }
    return self;
}

#pragma mark 添加控件
-(void)addScrollView{
    _scrollView=[[UIScrollView alloc]initWithFrame:self.bounds];
    NSLog(@"MMAdvertiseView addScrollView frame=%@", NSStringFromCGRect(_scrollView.frame));
    [self addSubview:_scrollView];
    //设置代理
    _scrollView.delegate=self;
    //设置contentSize
    _scrollView.contentSize=CGSizeMake(width * (_imageCount), height);
    //设置当前显示的位置为中间图片
    [_scrollView setContentOffset:CGPointMake(width, 0) animated:NO];
    NSLog(@"-MMAdvertiseView--偏移-----%f", _scrollView.contentOffset.x);
    //设置分页
    _scrollView.pagingEnabled=YES;
    
    //去掉滚动条
    _scrollView.showsHorizontalScrollIndicator=NO;
    self.scrollView.backgroundColor = [UIColor whiteColor];
    
    NSLog(@"-MMAdvertiseView----contentOffset.x----%f", _scrollView.contentOffset.x);
}

#pragma mark 添加图片三个控件
-(void)addImageViews{
    
    //加载默认图片
    for(int i=0; i < _imageCount; i++){
        _leftImageView=[[UIImageView alloc]initWithFrame:CGRectMake(width * i, 0, width, height)];
        _leftImageView.contentMode=UIViewContentModeScaleAspectFill;
        [ImageUtils loadImage:_leftImageView url:[self.imageurls[i] imageNormalCompression] ];
        NSLog(@"MMAdvertiseView width=%f  height=%f", width, height);
        [_scrollView addSubview:_leftImageView];
        
    }
    
//    _centerImageView=[[UIImageView alloc]initWithFrame:CGRectMake(width, 0, width, height)];
//    _centerImageView.contentMode=UIViewContentModeScaleAspectFill;
//    [_scrollView addSubview:_centerImageView];
//    
//    _rightImageView=[[UIImageView alloc]initWithFrame:CGRectMake(_imageCount * width, 0, width, height)];
//    _rightImageView.contentMode=UIViewContentModeScaleAspectFill;
//    [ImageUtils loadImage:_rightImageView url:[self.imageurls[0] imageNormalCompression] ];
//    [_scrollView addSubview:_rightImageView];

}

#pragma mark 添加分页控件
-(void)addPageControl{
    _pageControl=[[UIPageControl alloc]init];
    //注意此方法可以根据页数返回UIPageControl合适的大小
//    CGSize size= [_pageControl sizeForNumberOfPages:_imageCount];
    _pageControl.bounds=CGRectMake(0, 0, width, 30);
    _pageControl.center=CGPointMake(width/2, height-15);
    //设置颜色
    _pageControl.pageIndicatorTintColor=[UIColor backgroundlightGrayColor];
    //设置当前页颜色
    _pageControl.currentPageIndicatorTintColor=[UIColor orangeThemeColor];
    //设置总页数
    _pageControl.numberOfPages = _imageCount;
    
    [self addSubview:_pageControl];
}


#pragma mark 设置默认显示图片
-(void)setDefaultImage{
    //加载默认图片
//    [ImageUtils loadImage:_leftImageView url:[self.imageurls[_imageCount - 1] imageNormalCompression] ];
//    
//    [ImageUtils loadImage:_centerImageView url:[self.imageurls[0] imageNormalCompression] ];
//    
//    [ImageUtils loadImage:_rightImageView url:[self.imageurls[1] imageNormalCompression] ];
//    
//    NSLog(@"MMAdvertiseView _left = %@", [self.imageurls[_imageCount - 1] imageNormalCompression]);
    _currentImageIndex = 0;
    //设置当前页
    _pageControl.currentPage = _currentImageIndex;
   
}

- (void)reloadImageAuto{
    long leftImageIndex,rightImageIndex;
    self.currentImageIndex = (_currentImageIndex+1)%_imageCount;
    
    
    [UIView animateWithDuration:1.0 animations:^{
        self.scrollView.contentOffset = CGPointMake(width * _currentImageIndex, 0);
    }];
    
  
//    [ImageUtils loadImage:_centerImageView url:[self.imageurls[self.currentImageIndex] imageNormalCompression] ];
//    
//    //重新设置左右图片
//    leftImageIndex = (_currentImageIndex+_imageCount-1)%_imageCount;
//    rightImageIndex = (_currentImageIndex+1)%_imageCount;
//    [ImageUtils loadImage:_leftImageView url:[self.imageurls[leftImageIndex] imageNormalCompression] ];
//    [ImageUtils loadImage:_rightImageView url:[self.imageurls[rightImageIndex] imageNormalCompression] ];
//    
//    [_scrollView setContentOffset:CGPointMake(width, 0) animated:NO];
    //设置分页
    _pageControl.currentPage=_currentImageIndex;
}


- (void)createTimer{
    if (self.timer == nil) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:self.looptime target:self selector:@selector(reloadImageAuto) userInfo:nil repeats:YES];
        NSLog(@"start");
    }
}

#pragma mark 滚动停止事件



-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSLog(@"scrollViewDidEndDecelerating");
    //重新加载图片
    [self reloadImage];
    //移动到中间
    [_scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
    //设置分页
    _pageControl.currentPage=_currentImageIndex;
}



#pragma mark 重新加载图片
-(void)reloadImage{
//    long leftImageIndex,rightImageIndex;
    CGPoint offset=[_scrollView contentOffset];
    NSLog(@"MMAdvertiseview reloadimage offset %f %f _currentImageIndex=%ld", offset.x, offset.y, (long)_currentImageIndex);
    if (offset.x>=width* _currentImageIndex) { //向右滑动
        self.currentImageIndex = (_currentImageIndex+1)%_imageCount;
    }else if(offset.x<width*_currentImageIndex){ //向左滑动
        self.currentImageIndex = (_currentImageIndex+_imageCount-1)%_imageCount;
    }
    NSLog(@"MMAdvertiseview reloadimage  _currentImageIndex=%ld", (long)_currentImageIndex);
//    //UIImageView *centerImageView=(UIImageView *)[_scrollView viewWithTag:2];
//    [ImageUtils loadImage:_centerImageView url:[self.imageurls[self.currentImageIndex] imageNormalCompression] ];
//    
//    //重新设置左右图片
//    leftImageIndex = (_currentImageIndex+_imageCount-1)%_imageCount;
//    rightImageIndex = (_currentImageIndex+1)%_imageCount;
//
//    [ImageUtils loadImage:_leftImageView url:[self.imageurls[leftImageIndex] imageNormalCompression] ];
//    [ImageUtils loadImage:_rightImageView url:[self.imageurls[rightImageIndex] imageNormalCompression] ];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRec2t)rect {
    // Drawing code
}
*/

@end
