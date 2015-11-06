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
- (IBAction)washshuomingClicked:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *canshuView;

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHeight;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollerView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
- (IBAction)addCartBtnClicked:(id)sender;
- (IBAction)buyBtnClicked:(id)sender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sizeTableHeight;
@property (weak, nonatomic) IBOutlet UIView *sizeTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomImageViewHeight;
@property (weak, nonatomic) IBOutlet UIImageView *bottomImageView;
- (IBAction)backqianye:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIView *backHeadImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageleading;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageTrailing;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageBottom;
@property (weak, nonatomic) IBOutlet UIButton *addCartButton;
@property (weak, nonatomic) IBOutlet UIButton *lijiBuyButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *canshuHeight;
@property (weak, nonatomic) IBOutlet UILabel *beizhuLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftWidth;
@property (weak, nonatomic) IBOutlet UILabel *xidishuomingLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *line1Height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *line2Height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *line3Height;
@property (weak, nonatomic) IBOutlet UIView *line4Height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *line5Height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *line6height;

@end
