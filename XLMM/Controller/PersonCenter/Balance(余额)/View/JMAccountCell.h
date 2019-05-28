//
//  JMAccountCell.h
//  XLMM
//
//  Created by zhang on 16/12/28.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AccountModel;
@interface JMAccountCell : UITableViewCell

- (void)fillDataOfCell:(AccountModel *)accountM;

@end
