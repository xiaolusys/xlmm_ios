//
//  JMSharePackView.h
//  XLMM
//
//  Created by zhang on 16/6/21.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JMSharePackView.h"

@class JMSharePackView;
@protocol JMSharePackViewDelegate <NSObject>

- (void)composeGetRedpackBtn:(JMSharePackView *)renPack didClick:(UIButton *)button;

@end

@interface JMSharePackView : UIView

@property (nonatomic,copy) NSString *limitStr;

+ (instancetype)enterHeaderView;

@property (nonatomic, weak) id<JMSharePackViewDelegate> delegate;

@end
