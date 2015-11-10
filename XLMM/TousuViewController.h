//
//  TousuViewController.h
//  XLMM
//
//  Created by younishijie on 15/8/20.
//  Copyright (c) 2015年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TousuViewController : UIViewController <UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *tousuTextView;
@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UIButton *tijiaoButton;

- (IBAction)tijiaoClicked:(id)sender;

@end
