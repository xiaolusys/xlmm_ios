//
//  JMSelectionGoodsInfoController.h
//  XLMM
//
//  Created by zhang on 16/8/9.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^sureButtonBlock)(NSDictionary *dic);

@class JMGoodsInfoPopView;
@protocol JMGoodsInfoPopViewDelegate <NSObject>

- (void)composeGoodsInfoView:(JMGoodsInfoPopView *)popView AttrubuteDic:(NSDictionary *)attrubuteDic;

@end

@class JMGoodsAttributeTypeView,JMBuyNumberView;
@interface JMGoodsInfoPopView : UIView

@property (nonatomic, strong) NSMutableArray *goodsInfoArray;


@property (nonatomic, strong) JMGoodsAttributeTypeView *sizeView;
@property (nonatomic, strong) JMGoodsAttributeTypeView *colorView;
@property (nonatomic, strong) JMBuyNumberView *buyNumView;

@property (nonatomic, copy) sureButtonBlock block;
@property (nonatomic, weak) id<JMGoodsInfoPopViewDelegate>delegate;


- (void)initTypeSizeView:(NSArray *)goodsArray TitleString:(NSString *)titleString;




@end