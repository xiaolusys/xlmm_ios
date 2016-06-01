//
//  JMPopLogistcsCell.h
//  XLMM
//
//  Created by 崔人帅 on 16/6/1.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JMPopLogistcsModel.h"

@protocol JMPopLogistcsCellDelegate <NSObject>

- (void)composeWith:(UIImageView *)imageView;

@end

@interface JMPopLogistcsCell : UITableViewCell

- (void)configWithModel:(JMPopLogistcsModel *)model;

@property (nonatomic,strong) UIImageView *selecImage;

@property (nonatomic,copy) NSString *imageStr;

@property (nonatomic,weak) id<JMPopLogistcsCellDelegate> delegate;


@end
