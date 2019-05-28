//
//  JMReloadEmptyDataView.h
//  XLMM
//
//  Created by zhang on 17/2/27.
//  Copyright © 2017年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ReloadClickBlock)();

@interface JMReloadEmptyDataView : UIView

- (instancetype)initWithFrame:(CGRect)frame Title:(NSString *)title DescTitle:(NSString *)descTitle ButtonTitle:(NSString *)buttonTitle Image:(NSString *)imageStr ReloadBlcok:(ReloadClickBlock)reloadBlock;

- (void)showInView:(UIView *)viewShow;
- (void)hideView;

@end
