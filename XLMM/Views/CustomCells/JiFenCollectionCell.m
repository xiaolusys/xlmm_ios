//
//  JiFenCollectionCell.m
//  XLMM
//
//  Created by younishijie on 15/9/9.
//  Copyright (c) 2015年 上海己美. All rights reserved.
//

#import "JiFenCollectionCell.h"
#import "JiFenModel.h"

@implementation JiFenCollectionCell

- (void)awakeFromNib {
    // Initialization code
    
}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self)
    {
        // 初始化时加载collectionCell.xib文件
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"JiFenCollectionCell" owner:self options:nil];
        
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

- (void)fillCellWithData:(JiFenModel *)model{
    self.timeLabel.text = [self replaceString:model.created];
    self.bianhaoLabel.text = [model.order objectForKey:@"order_id"];
    self.jifenLabel.text = [NSString stringWithFormat:@"+%@分",model.log_value];
    
    
}
- (NSString *)replaceString:(NSString *)string{
    NSMutableString *mutableStr = [[NSMutableString alloc] initWithString:string];
    NSRange range = {10, 1};
    [mutableStr replaceCharactersInRange:range withString:@" "];
    return mutableStr;
}
@end
