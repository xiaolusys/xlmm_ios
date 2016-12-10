//
//  JMBorwesScrollView.h
//  XLMM
//
//  Created by zhang on 16/12/10.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JMBorwesScrollView;
@protocol JMBorwesScrollViewDelegate <NSObject>

- (void)composeBrowesScrollView:(JMBorwesScrollView *)browesScrollView singleTapDetected:(UITapGestureRecognizer *)singleTap;

@end

@interface JMBorwesScrollView : UIScrollView

@property (nonatomic, weak) id <JMBorwesScrollViewDelegate> browesScrollViewDelegate;

// 是否已经加载过图片
@property (nonatomic, assign) BOOL isLoadingImage;

// 当前展示的图片
@property (nonatomic, strong, readonly) UIImage *currentShowImage;

@property (nonatomic, strong, readonly) UIImageView *imageView;



- (void)showHightQualityImageUrl:(NSURL *)url placeholderImage:(UIImage *)image;
- (void)showImage:(UIImage *)image;
- (void)adjustmentImageSize;
- (void)prepareForReuse;







@end






























































































































