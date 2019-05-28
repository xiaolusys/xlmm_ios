//
//  JMPopLogistcsCell.h
//  XLMM
//
//  Created by 崔人帅 on 16/6/1.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JMPopLogistcsModel.h"
//@class JMPopLogistcsCell;
//@protocol JMPopLogistcsCellDelegate <NSObject>
//
//- (void)ClickLogistics:(JMPopLogistcsCell *)click Title:(NSString *)title;
//
//@end

@interface JMPopLogistcsCell : UITableViewCell

- (void)configWithModel:(JMPopLogistcsModel *)model Index:(NSInteger)index;

//@property (nonatomic,weak) id<JMPopLogistcsCellDelegate>delegate;

@end
