//
//  MaMaShareSubsidiesViewController.h
//  XLMM
//
//  Created by apple on 16/1/23.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MaMaShareSubsidiesViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
//当前日期总的补贴
@property (nonatomic, strong)NSNumber *todayMoney;
@property (nonatomic, assign)NSInteger clickDate;
@end
