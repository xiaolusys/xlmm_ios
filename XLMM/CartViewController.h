//
//  CartViewController.h
//  XLMM
//
//  Created by younishijie on 15/8/17.
//  Copyright (c) 2015年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CartViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UIView *myView;

@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (weak, nonatomic) IBOutlet UIButton *retainBtn;

@property (weak, nonatomic) IBOutlet UIView *frontView;
@property (strong, nonatomic)NSMutableArray *dataArray;

@property (weak, nonatomic) IBOutlet UILabel *discountLabel;
@property (weak, nonatomic) IBOutlet UITableView *cartTableView;
@property (weak, nonatomic) IBOutlet UILabel *totalPricelabel;

- (IBAction)purchaseClicked:(id)sender;
@end