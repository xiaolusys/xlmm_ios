//
//  MamaActivityViewController.h
//  XLMM
//
//  Created by younishijie on 16/1/22.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MamaActivityViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *colorViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sizeViewHeight;
@property (weak, nonatomic) IBOutlet UIView *colorView;
@property (weak, nonatomic) IBOutlet UIView *sizeView;
@property (weak, nonatomic) IBOutlet UIButton *commitButton;
- (IBAction)commitClicked:(id)sender;
- (IBAction)chimabiao:(id)sender;


@end
