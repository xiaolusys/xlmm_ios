//
//  JMGoodsAttributeTypeView.h
//  XLMM
//
//  Created by zhang on 16/8/10.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JMGoodsAttributeTypeView;
@protocol JMGoodsAttributeTypeViewDelegate <NSObject>

- (void)composeAttrubuteTypeView:(JMGoodsAttributeTypeView *)typeView Index:(NSInteger)index;

@end

@interface JMGoodsAttributeTypeView : UIView


@property (nonatomic, assign) CGFloat height;

@property (nonatomic, assign) int selectIndex;

-(instancetype)initWithFrame:(CGRect)frame DataArray:(NSArray *)dataArray GoodsTypeName:(NSString *)goodsTypeName;

@property (nonatomic, weak) id<JMGoodsAttributeTypeViewDelegate> delegate;

@end
