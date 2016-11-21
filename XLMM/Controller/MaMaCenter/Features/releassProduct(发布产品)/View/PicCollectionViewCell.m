//
//  PicCollectionViewCell.m
//  XLMM
//
//  Created by 张迎 on 16/1/6.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "PicCollectionViewCell.h"


@interface PicCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *cellImageView;

@end

@implementation PicCollectionViewCell

- (void)awakeFromNib {
    
}

- (void)createImageForCellImageView:(NSString *)imageUrl Index:(NSInteger)index RowIndex:(NSInteger)rowIndex {
    //图片处理小图
    NSString *url = index == rowIndex ? imageUrl : [imageUrl imageGoodsOrderCompression];
    [self.cellImageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"zhanwei"]];
    
    
    
    


}







@end






































