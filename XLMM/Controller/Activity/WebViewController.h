//
//  HuodongViewController.h
//  XLMM
//
//  Created by younishijie on 16/2/3.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonWebViewViewController.h"
#import "PontoDispatcher.h"

@interface WebViewController : CommonWebViewViewController <PontoDispatcherCallbackDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property (nonatomic, strong) NSDictionary *diction;

@property (nonatomic, copy)NSString *eventLink;

@property (nonatomic,copy) NSString *active;

@end
