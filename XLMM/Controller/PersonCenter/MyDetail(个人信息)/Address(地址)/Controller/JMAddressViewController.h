//
//  JMAddressViewController.h
//  XLMM
//
//  Created by zhang on 17/2/21.
//  Copyright © 2017年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JMAddressViewController,JMAddressModel;
@protocol JMAddressViewControllerDelegate <NSObject>

@required

- (void)addressView:(JMAddressViewController *)addressVC model:(JMAddressModel *)model;

@end

@interface JMAddressViewController : UIViewController

@property (nonatomic, assign) id <JMAddressViewControllerDelegate>delegate;


@property (nonatomic, assign) BOOL isSelected;
//@property (nonatomic, assign) BOOL isBondedGoods;
//@property (nonatomic, assign) BOOL isButtonSelected;
@property (nonatomic, assign) NSInteger cartsPayInfoLevel;

@property (nonatomic, copy) NSString *addressID;

@end
