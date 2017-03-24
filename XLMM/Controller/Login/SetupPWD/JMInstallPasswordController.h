//
//  JMInstallPasswordController.h
//  XLMM
//
//  Created by zhang on 17/3/21.
//  Copyright © 2017年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, PWDWithInstallType) {
    PWDWithInstall = 0,    // 设置密码
    PWDWithChange,         // 修改密码
};


@interface JMInstallPasswordController : UIViewController

@property (nonatomic, copy) NSString *phomeNumber;
@property (nonatomic, copy) NSString *verfiyCode;
@property (nonatomic, assign) PWDWithInstallType pwdType;

@end
