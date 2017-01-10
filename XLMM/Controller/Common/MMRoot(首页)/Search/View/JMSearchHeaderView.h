//
//  JMSearchHeaderView.h
//  XLMM
//
//  Created by zhang on 17/1/10.
//  Copyright © 2017年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^deleteBlock)(UIButton *button);

@interface JMSearchHeaderView : UICollectionReusableView

@property (nonatomic, copy) deleteBlock block;

@end
