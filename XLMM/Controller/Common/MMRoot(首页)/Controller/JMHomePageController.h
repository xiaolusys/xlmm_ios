//
//  JMHomePageController.h
//  XLMM
//
//  Created by zhang on 17/2/13.
//  Copyright © 2017年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@class HMSegmentedControl;
@interface JMHomePageController : UIViewController <NSURLSessionDelegate,NSURLSessionTaskDelegate,NSURLSessionDownloadDelegate,UIDocumentInteractionControllerDelegate>

@property (nonatomic, strong) NSURLSessionDownloadTask *downloadTask;
@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong) AVPlayer *player;

@property (nonatomic, strong) HMSegmentedControl *segmentControl;
@property (nonatomic, strong) UIScrollView *baseScrollView;



@end
