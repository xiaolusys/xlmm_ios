//
//  JMHomeCategoryCell.m
//  XLMM
//
//  Created by zhang on 16/8/19.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMHomeCategoryCell.h"



NSString *const JMHomeCategoryCellIdentifier = @"JMHomeCategoryCellIdentifier";

@interface JMHomeCategoryCell ()

@property (nonatomic, strong) UIImageView *iconImage1;
@property (nonatomic, strong) UIImageView *iconImage2;

@end

@implementation JMHomeCategoryCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self createUI];
        
    }
    return self;
}


- (void)createUI {
//    NSLog(@"%f",SCREENWIDTH / 320.0);
//    NSLog(@"%f",HomeCategorySpaceW);
//    NSLog(@"%f",HomeCategorySpaceH);
//    UIView *baseView = [UIView new];
//    [self.contentView addSubview:baseView];
//    
//    [baseView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.equalTo(weakSelf.contentView);
//        make.top.equalTo(weakSelf.contentView).offset(15);
//        make.bottom.equalTo(weakSelf.contentView).offset(-15);
//    }];
    
    NSInteger imageW = (SCREENWIDTH - 5 * HomeCategorySpaceW) / 4;
    NSInteger imageH = imageW * 1.25;
    for (int i = 0; i < 8; i++) {
        UIImageView *iconImage = [UIImageView new];
        iconImage.hidden = YES;
        iconImage.userInteractionEnabled = YES;
        iconImage.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:iconImage];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
        [iconImage addGestureRecognizer:tap];
        UIView *tapView = [tap view];
        tapView.tag = 100 + i;
        iconImage.tag = 100 + i;
        
        iconImage.frame = CGRectMake(HomeCategorySpaceW + (imageW + HomeCategorySpaceW) * (i % 4), 15 + (imageH + HomeCategorySpaceH) * (i / 4), imageW, imageH);

    }
    

}

- (void)setImageArray:(NSMutableArray *)imageArray {
    _imageArray = imageArray;
    if (imageArray.count == 0) {
        return ;
    }
    for (int i = 0; i < imageArray.count; i++) {
        NSDictionary *dic = imageArray[i];
        UIImageView *image = (UIImageView *)[self.contentView viewWithTag:100 + i];
        [image sd_setImageWithURL:[NSURL URLWithString:[[dic[@"cat_img"] imageGoodsOrderCompression] JMUrlEncodedString]] placeholderImage:nil]; //[UIImage imageNamed:@"placeHolderImage.png"]
        image.hidden = NO;
    }
}

- (void)tapClick:(UITapGestureRecognizer *)tap {
    UIView *tapView = [tap view];
    NSInteger index = tapView.tag - 100;
    NSDictionary *dic = self.imageArray[index];
    if (_delegate && [_delegate respondsToSelector:@selector(composeCategoryCellTapView:ParamerStr:)]) {
        [_delegate composeCategoryCellTapView:self ParamerStr:dic];
    }
}





@end



































































































































