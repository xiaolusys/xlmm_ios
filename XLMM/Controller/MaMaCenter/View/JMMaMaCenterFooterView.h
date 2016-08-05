//
//  JMMaMaCenterFooterView.h
//  XLMM
//
//  Created by zhang on 16/7/25.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JMMaMaCenterModel;
@class JMMaMaCenterFooterView;
@protocol JMMaMaCenterFooterViewDelegate <NSObject>

@optional
- (void)composeMaMaCenterFooterView:(JMMaMaCenterFooterView *)footerView Index:(NSInteger)index;
- (void)composeFooterViewScrollView:(JMMaMaCenterFooterView *)footerView Index:(NSInteger)index;

@end

@interface JMMaMaCenterFooterView : UIView

@property (nonatomic, strong) JMMaMaCenterModel *mamaCenterModel;

+ (instancetype)enterFooterView;

@property (nonatomic, weak) id<JMMaMaCenterFooterViewDelegate>delegate;

@property (nonatomic, strong) NSDictionary *messageDic;


@end
