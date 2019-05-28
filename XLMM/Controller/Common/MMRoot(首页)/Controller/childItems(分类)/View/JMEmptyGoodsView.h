//
//  JMEmptyGoodsView.h
//  XLMM
//
//  Created by zhang on 16/8/22.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^emptyGoodsBlock)(NSInteger index);

@interface JMEmptyGoodsView : UIView

@property (nonatomic, copy) emptyGoodsBlock block;


@end
