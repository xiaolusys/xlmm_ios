//
//  MMDetailsViewController.h
//  XLMM
//
//  Created by younishijie on 15/9/2.
//  Copyright (c) 2015年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MMDetailsViewController : UIViewController{
    
}


@property (nonatomic, copy) NSString * urlString;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headViewwidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headViewHeitht;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *allPriceLabel;
@property (weak, nonatomic) IBOutlet UIView *sizeView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sizeViewHeight;
@property (weak, nonatomic) IBOutlet UILabel *mingcheng;
@property (weak, nonatomic) IBOutlet UILabel *bianhao;
@property (weak, nonatomic) IBOutlet UILabel *caizhi;
@property (weak, nonatomic) IBOutlet UILabel *yanse;
@property (weak, nonatomic) IBOutlet UILabel *beizhu;
@property (weak, nonatomic) IBOutlet UILabel *shuoming;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHeight;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollerView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
- (IBAction)addCartBtnClicked:(id)sender;
- (IBAction)buyBtnClicked:(id)sender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sizeTableHeight;
@property (weak, nonatomic) IBOutlet UIView *sizeTableView;

@end
