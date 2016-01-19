//
//  MaMaPersonCenterViewController.h
//  XLMM
//
//  Created by younishijie on 16/1/11.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MaMaPersonCenterViewController : UIViewController


@property (weak, nonatomic) IBOutlet UIScrollView *rootScrollView;
@property (weak, nonatomic) IBOutlet UILabel *levelLabel;
@property (weak, nonatomic) IBOutlet UILabel *jineLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeight;
@property (weak, nonatomic) IBOutlet UILabel *jileishouyi;
@property (weak, nonatomic) IBOutlet UILabel *dingdanyilu;

@property (weak, nonatomic) IBOutlet UILabel *dingdanLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *mamaScrollView;
@property (weak, nonatomic) IBOutlet UIButton *fabuButton;

@property (weak, nonatomic) IBOutlet UITableView *mamaTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headViewWidth;


- (IBAction)backClicked:(id)sender;
- (IBAction)sendProduct:(id)sender;

- (IBAction)MamaOrderClicked:(id)sender;
- (IBAction)MamaCarryLogClicked:(id)sender;


@end
