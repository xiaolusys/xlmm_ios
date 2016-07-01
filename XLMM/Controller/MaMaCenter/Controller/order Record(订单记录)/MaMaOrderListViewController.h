//
//  MaMaOrderListViewController.h
//  XLMM
//
//  Created by 张迎 on 16/1/18.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MaMaOrderListViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong)NSString *orderRecord;
@end
