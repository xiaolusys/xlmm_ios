//
//  HuodongViewController.h
//  XLMM
//
//  Created by younishijie on 16/2/3.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonWebViewViewController.h"

@interface WebViewController : CommonWebViewViewController //<PontoDispatcherCallbackDelegate>
//@property (weak, nonatomic) IBOutlet UIWebView *webView;



@property (nonatomic, strong) NSDictionary *diction;

@property (nonatomic, copy)NSString *eventLink;

@property (nonatomic,copy) NSString *active;
/**
 *  商品详情 ID
 */
@property (nonatomic,copy) NSString *goodsID;

//@property (nonatomic,copy) NSString *titleName;
//@property (nonatomic, strong)NSString *loadLink;
//@property (nonatomic, strong)NSString *titleName;

//- (instancetype)initWithUrl:(NSString *)url title:(NSString *)titleName;

@end
