//
//  PicCollectionViewCell.m
//  XLMM
//
//  Created by 张迎 on 16/1/6.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "PicCollectionViewCell.h"


@interface PicCollectionViewCell ()


@end

@implementation PicCollectionViewCell

- (void)awakeFromNib {
    
}

- (void)createImageForCellImageView:(NSString *)imageUrl Index:(NSInteger)index RowIndex:(NSInteger)rowIndex {
    //图片处理小图
//    if ([NSString isStringEmpty:imageUrl]) {
//        self.cellImageView.image = [UIImage imageNamed:@"zhanwei"];
//        return ;
//    }
    
    if (index == rowIndex) {
    }else {
        imageUrl = [imageUrl imageGoodsOrderCompression];
    }
    NSLog(@"%@",imageUrl);
//    NSString *url = index == rowIndex ? imageUrl : [imageUrl imageGoodsOrderCompression];
    [self.cellImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"zhanwei"]];
    
    
    
    


}







@end






































