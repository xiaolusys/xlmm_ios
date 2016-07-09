//
//  JMPhonenumViewController.h
//  XLMM
//
//  Created by zhang on 16/5/14.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JMEditAddressModel;

@protocol JMPhonenumViewControllerDelegate <NSObject>

- (void)updateEditerWithmodel:(JMEditAddressModel *)model;

@end

@interface JMPhonenumViewController : UIViewController

@property (nonatomic,weak) id<JMPhonenumViewControllerDelegate>delegate;

@end
