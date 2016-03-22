//
//  FensiListViewController.h
//  XLMM
//
//  Created by younishijie on 16/1/27.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FensiListViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, assign)NSInteger fansNum;
@end
