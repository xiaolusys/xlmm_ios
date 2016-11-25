//
//  JMEditAddressController.h
//  XLMM
//
//  Created by zhang on 16/5/25.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JMEditAddressModel;
@protocol JMEditAddressControllerDelegate <NSObject>

- (void)updateEditerWithmodel:(NSDictionary *)model;

@end

@interface JMEditAddressController : UIViewController

@property (nonatomic,strong) NSMutableDictionary *editDict;

@property (nonatomic, weak) id <JMEditAddressControllerDelegate> delegate;


@end
