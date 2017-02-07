//
//  JMPaySucTitleView.h
//  XLMM
//
//  Created by zhang on 16/6/21.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>


@class JMPaySucTitleView;
@protocol JMPaySucTitleViewDelegate <NSObject>

- (void)composeGetRedpackBtn:(JMPaySucTitleView *)renPack didClick:(UIButton *)button;

@end


@interface JMPaySucTitleView : UIView

+ (instancetype)enterHeaderView;

@property (nonatomic, weak) id<JMPaySucTitleViewDelegate> delegate;


@end
