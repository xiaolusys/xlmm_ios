//
//  TuijianErweimaViewController.h
//  XLMM
//
//  Created by younishijie on 16/1/21.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TuijianErweimaViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (copy, nonatomic) NSString *imagelink;

@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;


- (IBAction)saveImage:(id)sender;
- (IBAction)shareImage:(id)sender;

@end
