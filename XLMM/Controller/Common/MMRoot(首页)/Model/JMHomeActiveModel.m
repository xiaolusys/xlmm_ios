//
//  JMHomeActiveModel.m
//  XLMM
//
//  Created by zhang on 16/8/31.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMHomeActiveModel.h"

@implementation JMHomeActiveModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"activeID":@"id"};
}

- (CGFloat)cellHeight {
    if (!_cellHeight) {
//        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0 , SCREENWIDTH, SCREENWIDTH * 0.6)];
        
        UIImage *imgView = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[[self.act_img JMUrlEncodedString] imageNormalCompression]]]];
        
        float h;
        if((imgView == nil) || (imgView.size.width == 0)){
            h = SCREENWIDTH * 0.5;
        }
        else{
            h = SCREENWIDTH * (imgView.size.height / imgView.size.width);
        }
        _cellHeight = h + 10;
        
        
//        [imgView sd_setImageWithURL:[NSURL URLWithString:[[self.act_img JMUrlEncodedString] imageNormalCompression]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//            //通过加载图片得到其高度wa
//            float h;
//            if((image == nil) || (image.size.width == 0)){
//                h = SCREENWIDTH * 0.6;
//            }
//            else{
//                h = SCREENWIDTH * (image.size.height / image.size.width);
//            }
//            _cellHeight = h + 10;
//            
//        }];
        
        
        
        
        
        
    }
    return _cellHeight;
}






@end



