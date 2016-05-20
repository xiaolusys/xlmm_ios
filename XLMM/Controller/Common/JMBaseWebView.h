//
//  JMBaseWebView.h
//  XLMM
//
//  Created by zhang on 16/5/19.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JMBaseWebView : UIViewController

@property (nonatomic,copy) NSString *urlStr;

@property (nonatomic,copy) NSString *titleName;

- (instancetype)initWithUrl:(NSString *)url Title:(NSString *)titleName;


@end
