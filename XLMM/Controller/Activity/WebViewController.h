//
//  HuodongViewController.h
//  XLMM
//
//  Created by younishijie on 16/2/3.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonWebViewViewController.h"
#import "JMShareModel.h"

@interface WebViewController : CommonWebViewViewController

//一般来说webDiction是include 3个属性，type_title web_url activity_id
@property (nonatomic,strong) NSMutableDictionary *webDiction;
// share params
@property (nonatomic,strong) JMShareModel *share_model;

@property (nonatomic,assign) BOOL isShowNavBar;
@property (nonatomic,assign) BOOL isShowRightShareBtn;
@end
