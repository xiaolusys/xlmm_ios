//
//  JMBuyNumberView.h
//  XLMM
//
//  Created by zhang on 16/8/10.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^numOfClickBlcok)(NSInteger index);

@interface JMBuyNumberView : UIView

@property (nonatomic, strong) UILabel *numLabel;

@property (nonatomic, strong) UIButton *reduceButton;
@property (nonatomic, strong) UIButton *addButton;

@property (nonatomic, copy) numOfClickBlcok numblock;

@end
