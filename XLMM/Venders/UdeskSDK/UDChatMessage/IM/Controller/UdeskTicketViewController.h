//
//  UdeskTicketViewController.h
//  UdeskSDK
//
//  Created by xuchen on 15/11/26.
//  Copyright (c) 2015年 xuchen. All rights reserved.
//

#import "UdeskBaseViewController.h"

@interface UdeskTicketViewController : UdeskBaseViewController<UIWebViewDelegate>

/**
 *  ticket webView
 */
@property (nonatomic,strong ) UIWebView *ticketWebView;

@end
