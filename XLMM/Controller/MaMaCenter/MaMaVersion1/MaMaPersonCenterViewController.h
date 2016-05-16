//
//  MaMaPersonCenterViewController.h
//  XLMM
//
//  Created by younishijie on 16/1/11.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MaMaPersonCenterViewController : UIViewController

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *clickedViewHeight;
@property (weak, nonatomic) IBOutlet UILabel *huoyuedulabel;
@property (weak, nonatomic) IBOutlet UIView *huoyueduView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *huoyueduRight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *huoyueduLeft;
@property (weak, nonatomic) IBOutlet UILabel *mamahuoyueduLabel;
@property (weak, nonatomic) IBOutlet UIView *mamaHuoyueduView;

@property (weak, nonatomic) IBOutlet UIScrollView *rootScrollView;
@property (weak, nonatomic) IBOutlet UILabel *levelLabel;
@property (weak, nonatomic) IBOutlet UILabel *jineLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeight;
@property (weak, nonatomic) IBOutlet UIView *mamaHeadViewnew;
@property (weak, nonatomic) IBOutlet UILabel *jileishouyi;
@property (weak, nonatomic) IBOutlet UILabel *dingdanyilu;

@property (weak, nonatomic) IBOutlet UILabel *dingdanLabel;
@property (weak, nonatomic) IBOutlet UILabel *shouyiLabel;


@property (weak, nonatomic) IBOutlet UIScrollView *mamaScrollView;
@property (weak, nonatomic) IBOutlet UIButton *fabuButton;
@property (weak, nonatomic) IBOutlet UILabel *fensilabel;

@property (weak, nonatomic) IBOutlet UITableView *mamaTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headViewWidth;
@property (weak, nonatomic) IBOutlet UIView *shareSubsidies;

@property (weak, nonatomic) IBOutlet UILabel *mamalabel;
@property (weak, nonatomic) IBOutlet UIImageView *mamaimage;


@property (weak, nonatomic) IBOutlet UILabel *inviteLabel;
@property (weak, nonatomic) IBOutlet UILabel *order;
@property (weak, nonatomic) IBOutlet UILabel *account;

@property (weak, nonatomic) IBOutlet UILabel *todayNum;


- (void)backClicked:(id)sender;
- (IBAction)sendProduct:(id)sender;

- (IBAction)MamaOrderClicked:(id)sender;
- (IBAction)MamaCarryLogClicked:(id)sender;
- (IBAction)erweima:(id)sender;

- (IBAction)jingxuanliebiao:(id)sender;
- (IBAction)xuanpinliebiao:(id)sender;
- (IBAction)shareSubsidiesAction:(id)sender;

- (IBAction)huodongzhongxin:(id)sender;

- (IBAction)fansList:(id)sender;

- (IBAction)boutiqueActivities:(id)sender;

- (IBAction)todayVisitor:(id)sender;
- (IBAction)todayOrder:(id)sender;
- (IBAction)todayCarry:(id)sender;



@end
