//
//  PicFooterCollectionReusableView.m
//  XLMM
//
//  Created by 张迎 on 16/1/7.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "PicFooterCollectionReusableView.h"
#import "MMClass.h"

@implementation PicFooterCollectionReusableView

- (void)awakeFromNib {
    // Initialization code
    self.savePhotoBtn.layer.borderColor = [UIColor buttonEmptyBorderColor].CGColor;
    self.savePhotoBtn.layer.borderWidth = 1.0;
    self.savePhotoBtn.layer.cornerRadius = 18;
    self.savePhotoBtn.titleLabel.textColor = [UIColor buttonEmptyBorderColor];
}

@end
