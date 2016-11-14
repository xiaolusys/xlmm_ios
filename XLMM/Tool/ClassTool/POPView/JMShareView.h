//
//  JMShareView.h
//  XLMM
//
//  Created by 崔人帅 on 16/5/29.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JMShareView;

typedef void(^coverBlock)(JMShareView *cover);

//@protocol JMShareViewDelegate <NSObject>
//
//@optional
//// 点击蒙板的时候调用
//- (void)coverDidClickCover:(JMShareView *)cover;
//
//@end


@interface JMShareView : UIView

+ (void)hide;

+ (instancetype)show;


@property (nonatomic, assign) BOOL dimBackground;


//@property (nonatomic, weak) id<JMShareViewDelegate> delegate;

@property (nonatomic, copy) coverBlock blcok;


@end
