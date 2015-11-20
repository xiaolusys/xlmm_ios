//
//  YHQCollectionCell.m
//  XLMM
//
//  Created by younishijie on 15/9/15.
//  Copyright (c) 2015年 上海己美. All rights reserved.
//

#import "YHQCollectionCell.h"
#import "YHQModel.h"


@implementation YHQCollectionCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self)
    {
        // 初始化时加载collectionCell.xib文件
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"YHQCollectionCell" owner:self options:nil];
        
        // 如果路径不存在，return nil
        if (arrayOfViews.count < 1)
        {
            return nil;
        }
        // 如果xib中view不属于UICollectionViewCell类，return nil
        if (![[arrayOfViews objectAtIndex:0] isKindOfClass:[UICollectionViewCell class]])
        {
            return nil;
        }
        // 加载nib
        self = [arrayOfViews objectAtIndex:0];
    }
    return self;
}

- (void)fillCellWithYHQModel:(YHQModel *)yhqModel{
    NSString *createTime = yhqModel.created;
    NSString *deadlineTime = yhqModel.deadline;
    NSString *couponValue = yhqModel.coupon_value;
    
    NSString *useFee = yhqModel.use_fee;
    NSMutableString *mutablestart = [createTime mutableCopy];
    NSRange range = {10, 9};
    [mutablestart deleteCharactersInRange:range];
    NSMutableString *mutableend = [deadlineTime mutableCopy];
    [mutableend deleteCharactersInRange:range];
    NSString *newString = [NSString stringWithFormat:@"%@ 至 %@", mutablestart, mutableend];
    
    
    self.requireLabel.text = [NSString stringWithFormat:@"满%@元可以使用", useFee];
    if ([useFee intValue] == 0 && [yhqModel.status integerValue] == 0 && [yhqModel.poll_status integerValue] == 1) {
        self.requireLabel.textColor = [UIColor colorWithRed:240/255.0 green:80/255.0 blue:80/255.0 alpha:1];
        self.requireLabel.text = @"无门槛";
    }
    self.valueLabel.text = [NSString stringWithFormat:@"%d", [couponValue intValue]];
    self.timeLabel.text = newString;
    
    
    
}

@end
