//
//  VersionController.h
//  XLMM
//
//  Created by younishijie on 15/12/4.
//  Copyright © 2015年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VersionController : UIViewController

@property (nonatomic, copy) NSString *versionString;

@property (weak, nonatomic) IBOutlet UIImageView *imgDeer;
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;
@end
