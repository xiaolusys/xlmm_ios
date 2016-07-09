//
//  JMSelecterButton.h
//  XLMM
//
//  Created by zhang on 16/5/17.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JMSelecterButton : UIButton


- (void)setSelecterBorderColor:(UIColor *)color TitleColor:(UIColor *)tcolor Title:(NSString *)title TitleFont:(NSInteger)font CornerRadius:(NSInteger)corner;


- (void)setNomalBorderColor:(UIColor *)color TitleColor:(UIColor *)tcolor Title:(NSString *)title TitleFont:(NSInteger)font CornerRadius:(NSInteger)corner;

// 定制确定按钮 -- 分别有灰色背景  橙色背景  深绿色背景、
- (void)setSureBackgroundColor:(UIColor *)color CornerRadius:(NSInteger)corner;

//- (void)setBackgrdColor:(UIColor *)backgrdColor layerRead:(CGFloat)layerRead;

@end
