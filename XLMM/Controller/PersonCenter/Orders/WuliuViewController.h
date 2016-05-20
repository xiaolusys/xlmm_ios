//
//  WuliuViewController.h
//  XLMM
//
//  Created by younishijie on 15/11/17.
//  Copyright © 2015年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WuliuViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *wuliuInfoChainView;
@property (weak, nonatomic) IBOutlet UILabel *wuliuCompanyName;
@property (weak, nonatomic) IBOutlet UILabel *wuliuMiandanId;
@property (copy, nonatomic) NSString *packetId;
@property (copy, nonatomic) NSString *companyCode;
@end
