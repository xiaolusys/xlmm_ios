//
//  JMShareViewController.h
//  XLMM
//
//  Created by 崔人帅 on 16/5/29.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JMShareModel;
typedef void(^shareCancelBlock)(UIButton *button);
@interface JMShareViewController : UIViewController

@property (nonatomic,strong) JMShareModel *model;
@property (nonatomic, assign) BOOL isShowEarningValue;
//@property (nonatomic,copy) NSString *activeID;

//@property (nonatomic,strong) NSMutableDictionary *otherDict;

//@property (nonatomic,copy) NSString *urlStr;
@property (nonatomic, copy) shareCancelBlock blcok;


@end
