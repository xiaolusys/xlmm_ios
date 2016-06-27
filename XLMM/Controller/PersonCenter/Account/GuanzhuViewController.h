//
//  GuanzhuViewController.h
//  XLMM
//
//  Created by younishijie on 16/2/27.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GuanzhuViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *saveView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIButton *button;
- (IBAction)buttonClicked:(id)sender;

@property (nonatomic, strong) NSDictionary *dicinfo;

@end
