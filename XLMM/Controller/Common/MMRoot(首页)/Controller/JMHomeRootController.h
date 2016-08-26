//
//  JMHomeRootController.h
//  XLMM
//
//  Created by zhang on 16/8/19.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewLeftViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface JMHomeRootController : UIViewController<RootVCPushOtherVCDelegate,NSURLSessionDelegate,NSURLSessionTaskDelegate,NSURLSessionDownloadDelegate,UIDocumentInteractionControllerDelegate>

@property (nonatomic, strong) NSURLSessionDownloadTask *downloadTask;
@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong) AVPlayer *player;

@end
