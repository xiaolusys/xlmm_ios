//
//  LiJiGMViewController1.h
//  XLMM
//
//  Created by younishijie on 15/9/28.
//  Copyright © 2015年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LiJiGMViewController1 : UIViewController

@property (nonatomic, strong)NSString *skuID;
@property (nonatomic, strong)NSString *itemID;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *zhifuHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containterWidth;


@property (weak, nonatomic) IBOutlet UILabel *shouhuoren;
@property (weak, nonatomic) IBOutlet UILabel *shouhuodizhi;
@property (weak, nonatomic) IBOutlet UIButton *modifyButton;

- (IBAction)addAddressClicked:(id)sender;

- (IBAction)modifyAddressClicked:(id)sender;

- (IBAction)reduceClicked:(id)sender;
- (IBAction)plusClicked:(id)sender;
- (IBAction)selectYouhuiClicked:(id)sender;
- (IBAction)zhifubaoClicked:(id)sender;
- (IBAction)weixinClicked:(id)sender;




- (IBAction)buyClicked:(id)sender;

@end
