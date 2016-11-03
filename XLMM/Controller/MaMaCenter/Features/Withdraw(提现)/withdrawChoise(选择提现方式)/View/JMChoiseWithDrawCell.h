//
//  JMChoiseWithDrawCell.h
//  XLMM
//
//  Created by zhang on 16/9/20.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JMChoiseWithDrawCell : UITableViewCell



@property (nonatomic, strong) NSDictionary *withDrawDic;



- (void)configSettingData:(NSDictionary *)dict Index:(NSInteger)index;


@end
