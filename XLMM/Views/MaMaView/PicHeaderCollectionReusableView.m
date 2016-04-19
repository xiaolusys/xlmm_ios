//
//  PicHeaderCollectionReusableView.m
//  XLMM
//
//  Created by 张迎 on 16/1/6.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "PicHeaderCollectionReusableView.h"

@implementation PicHeaderCollectionReusableView

- (void)awakeFromNib {
    // Initialization code
    self.propagandaLabel.numberOfLines = 0;
    self.propagandaLabel.lineBreakMode = 0;
    self.propagandaLabel.font = [UIFont systemFontOfSize:14];
    [self.propagandaLabel sizeToFit];
}


@end
