//
//  JMPurchaseFooterView.h
//  XLMM
//
//  Created by zhang on 16/7/21.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JMPurchaseFooterView;
@protocol JMPurchaseFooterViewDelegate <NSObject>

- (void)composeFooterButtonView:(JMPurchaseFooterView *)headerView UIButton:(UIButton *)button;

@end


@interface JMPurchaseFooterView : UIView

@property (nonatomic, strong) UILabel *appPayLabel;

@property (nonatomic, strong) UILabel *couponLabel;

@property (nonatomic, strong) UILabel *walletLabel;

@property (nonatomic, strong) UILabel *goodsLabel;

@property (nonatomic, strong) UILabel *postLabel;

@property (nonatomic, strong) UILabel *paymenLabel;

@property (nonatomic, strong) UIButton *goPayButton;

@property (nonatomic, weak) id<JMPurchaseFooterViewDelegate> delegate;



@end
