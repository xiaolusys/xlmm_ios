//
//  JMSelectAddressView.h
//  XLMM
//
//  Created by zhang on 17/2/20.
//  Copyright © 2017年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^selectBlock)(NSString *proviceStr,NSString *cityStr,NSString * disStr);

@interface JMSelectAddressView : UIView

@property (nonatomic, copy) selectBlock block;


- (void)show;

- (void)hide;



@end
