//
//  DetailViewController.h
//  XLMM
//
//  Created by younishijie on 15/8/4.
//  Copyright (c) 2015年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DetailsModel;

@interface DetailViewController : UIViewController

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headHeight;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet UILabel *oldPriceLabel;

@property (weak, nonatomic) IBOutlet UILabel *productNameLabel;


@property (weak, nonatomic) IBOutlet UILabel *productName;



@property (weak, nonatomic) IBOutlet UIView *headView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *view1Height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *view2Height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *view3Height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *view4Height;
@property (weak, nonatomic) IBOutlet UIImageView *imageView1;
@property (weak, nonatomic) IBOutlet UIImageView *imageView2;
@property (weak, nonatomic) IBOutlet UIImageView *imageView3;
@property (weak, nonatomic) IBOutlet UIImageView *imageView4;


- (IBAction)addCart:(id)sender;

- (IBAction)purchase:(id)sender;


@property (nonatomic, copy)NSArray *headImageUrlArray;
@property (nonatomic, copy)NSArray *contentImageUrlArray;
@property (nonatomic, strong)DetailsModel *detailsModel;

@end
