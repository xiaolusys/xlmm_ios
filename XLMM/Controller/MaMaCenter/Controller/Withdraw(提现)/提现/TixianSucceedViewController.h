//
//  TixianSucceedViewController.h
//  XLMM
//
//  Created by younishijie on 16/1/11.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TixianSucceedViewController : UIViewController

//@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
//
//@property (weak, nonatomic) IBOutlet UILabel *weixinLabel;
//@property (weak, nonatomic) IBOutlet UIButton *fabuButton;
@property (assign, nonatomic) float tixianjine;
//- (IBAction)fabuClicked:(id)sender;

@property (nonatomic,assign) float activeNum;

//剩余金额
@property (nonatomic,assign) float surplusMoney;
//剩余活跃值
@property (nonatomic,assign) NSInteger activeValueNum;

@property (nonatomic, assign) BOOL isActiveValue;

@end
