//
//  MaMaHuoyueduViewController.h
//  XLMM
//
//  Created by younishijie on 16/3/9.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MaMaHuoyueduViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong)NSNumber *activeValueNum;
@end
