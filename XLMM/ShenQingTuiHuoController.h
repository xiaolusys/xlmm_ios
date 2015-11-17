//
//  ShenQingTuiHuoController.h
//  XLMM
//
//  Created by younishijie on 15/11/13.
//  Copyright © 2015年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PerDingdanModel;

@interface ShenQingTuiHuoController : UIViewController

@property (nonatomic, strong) PerDingdanModel *dingdanModel;

@property (assign, nonatomic) float refundPrice;
@property (copy, nonatomic) NSString *tid;
@property (copy, nonatomic) NSString *oid;
@property (copy, nonatomic) NSString *status;



@property (weak, nonatomic) IBOutlet UIImageView *myImageView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *sizeLabel;


@property (weak, nonatomic) IBOutlet UILabel *sizeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containterWidth;

@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *refundPriceLabel;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UILabel *refundNumLabel;
- (IBAction)reduceButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *addButtonClicked;
- (IBAction)addBtnClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *selectedReason;
@property (weak, nonatomic) IBOutlet UITextView *inputTextView;
- (IBAction)yuanyinClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UILabel *reasonLabel;
- (IBAction)commitClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *commitButton;

@property (weak, nonatomic) IBOutlet UIImageView *sendImageView;

- (IBAction)sendImages:(id)sender;

@end
