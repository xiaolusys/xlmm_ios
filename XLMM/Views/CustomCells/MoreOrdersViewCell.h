//
//  MoreOrdersViewCell.h
//  XLMM
//
//  Created by younishijie on 15/11/11.
//  Copyright © 2015年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoreOrdersViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *paymentLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *midHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomHeight;

@end
