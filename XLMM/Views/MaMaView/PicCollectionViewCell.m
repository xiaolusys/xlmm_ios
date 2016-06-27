//
//  PicCollectionViewCell.m
//  XLMM
//
//  Created by 张迎 on 16/1/6.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "PicCollectionViewCell.h"
#import "NSString+URL.h"
#import "UIImageView+WebCache.h"

@interface PicCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *cellImageView;

@end

@implementation PicCollectionViewCell

- (void)awakeFromNib {
    
}

- (void)createImageForCellImageView:(NSString *)imageUrl {
    //图片处理小图
    NSString *url = [imageUrl imageShareCompression];
    
//    [self.cellImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
    [self.cellImageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"zhanwei"]];
    self.cellImageView.contentMode = UIViewContentModeScaleAspectFill;
//    UIImage *image = [UIImage imageNamed:url];
//    self.cellImageView.image = image;
}

@end
