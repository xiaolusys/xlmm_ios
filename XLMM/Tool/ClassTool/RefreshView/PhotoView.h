//
//  PhotoView.h
//  XLMM
//
//  Created by 张迎 on 16/1/7.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoView : UIView <UIScrollViewDelegate>

@property (nonatomic, strong)NSMutableArray *picArr;
@property (nonatomic, assign)NSInteger index;
@property (nonatomic, assign)CGRect cellFrame;
@property (nonatomic, assign)CGFloat contentOffY;

- (void)fillData:(NSInteger)index
       cellFrame:(CGRect)cellFrame;
- (void)createScrollView;
@end
