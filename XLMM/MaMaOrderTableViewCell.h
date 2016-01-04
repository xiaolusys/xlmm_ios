//
//  MaMaOrderTableViewCell.h
//  XLMM
//
//  Created by 张迎 on 16/1/3.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MaMaOrderModel;

@interface MaMaOrderTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet UILabel *purchaser;
@property (weak, nonatomic) IBOutlet UILabel *rebate;
@property (weak, nonatomic) IBOutlet UILabel *orderStatic;
@property (weak, nonatomic) IBOutlet UILabel *times;
@property (weak, nonatomic) IBOutlet UILabel *fanyong;


- (void)fillDataOfCell:(MaMaOrderModel *)orderM;

@end
