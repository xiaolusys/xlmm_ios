//
//  CartViewController.h
//  XLMM
//
//  Created by younishijie on 15/8/17.
//  Copyright (c) 2015年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CartViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic)NSMutableArray *dataArray;

@property (weak, nonatomic) IBOutlet UITableView *cartTableView;
@end
