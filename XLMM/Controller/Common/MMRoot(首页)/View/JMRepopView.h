//
//  JMRepopView.h
//  XLMM
//
//  Created by 崔人帅 on 16/6/19.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^clickBlcok)(UIButton *button);

@interface JMRepopView : UIView

@property (nonatomic, copy) clickBlcok activeBlock;

+ (instancetype)showInRect:(CGRect)rect;
+ (void)hide;

@end
