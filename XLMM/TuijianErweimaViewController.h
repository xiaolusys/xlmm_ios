//
//  TuijianErweimaViewController.h
//  XLMM
//
//  Created by younishijie on 16/1/21.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UMSocial.h"

@interface TuijianErweimaViewController : UIViewController<UMSocialUIDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (copy, nonatomic) NSString *imagelink;

@property (copy, nonatomic) NSString *mamalink;

@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;

@property (weak, nonatomic) IBOutlet UIView *whiteView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topHeight;

- (IBAction)saveImage:(id)sender;
- (IBAction)shareImage:(id)sender;

@end
