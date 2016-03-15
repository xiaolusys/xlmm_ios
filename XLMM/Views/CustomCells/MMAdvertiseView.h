//
//  MMAdvertiseView.h
//  TestView001
//
//  Created by younishijie on 16/2/2.
//  Copyright © 2016年 上海己美网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MMAdvertiseView : UIView<UIScrollViewDelegate>{
 
   
}

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, assign) NSTimeInterval looptime;


@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *leftImageView;
@property (nonatomic, strong) UIImageView *centerImageView;
@property (nonatomic, strong) UIImageView *rightImageView;

@property (nonatomic, strong) UIPageControl *pageControl;

@property (nonatomic, assign) NSInteger currentImageIndex;
@property (nonatomic, assign) NSInteger imageCount;


@property (nonatomic, copy) NSArray *images;

// 数组中包含要循环显示的图片。。。
- (instancetype) initWithFrame:(CGRect)frame andImages:(NSArray *)images;

@end
