//
//  PurchaseViewController1.h
//  XLMM
//
//  Created by younishijie on 15/10/22.
//  Copyright © 2015年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PurchaseViewController1 : UIViewController

@property (strong, nonatomic) NSArray *cartsArray;
@property (weak, nonatomic) IBOutlet UILabel *peopleLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIButton *buyButton;
@property (weak, nonatomic) IBOutlet UILabel *totalFeeLabel;
@property (weak, nonatomic) IBOutlet UILabel *postFeeLabel;
@property (weak, nonatomic) IBOutlet UILabel *youhuijineLabel;
@property (weak, nonatomic) IBOutlet UILabel *allPayLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *detailsViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addressViewWidth;

@property (weak, nonatomic) IBOutlet UIView *detailsView;

- (IBAction)addAddress:(id)sender;
- (IBAction)yhqClicked:(id)sender;
- (IBAction)zhifubaoClicked:(id)sender;
- (IBAction)weixinZhifuClicked:(id)sender;
- (IBAction)buyClicked:(id)sender;

@end
