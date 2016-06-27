//
//  HtmlViewController.h
//  XLMM
//
//  Created by apple on 16/3/26.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UMSocial.h"

@interface HtmlViewController : UIViewController<UIWebViewDelegate, UMSocialUIDelegate>
@property (nonatomic, strong)NSString *eventLink;
@property (nonatomic, strong)NSString *webTitle;

@property (nonatomic, strong)NSNumber *activityId;
@end
