//
//  JMPicContainerView.m
//  XLMM
//
//  Created by zhang on 16/11/18.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMPicContainerView.h"

@interface JMPicContainerView ()

@property (nonatomic, strong) NSArray *imageViewsArray;

@end

@implementation JMPicContainerView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}
- (void)setup {
    NSMutableArray *temp = [NSMutableArray new];
    for (int i = 0; i < 9; i++) {
        UIImageView *imageView = [UIImageView new];
        [self addSubview:imageView];
        imageView.userInteractionEnabled = YES;
        imageView.tag = i;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageView:)];
        [imageView addGestureRecognizer:tap];
        [temp addObject:imageView];
    }
    
    self.imageViewsArray = [temp copy];
}

- (void)setPicUrlArray:(NSArray *)picUrlArray {
    _picUrlArray = picUrlArray;
    
    for (long i = _picUrlArray.count; i < self.imageViewsArray.count; i++) {
        UIImageView *imageView = [self.imageViewsArray objectAtIndex:i];
        imageView.hidden = YES;
    }
    
    if (_picUrlArray.count == 0) {
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(@0);
        }];
        return;
    }
    
    CGFloat itemW = [self itemWidthForPicPathArray:_picUrlArray];
    CGFloat itemH = 0;
    if (_picUrlArray.count == 1) {
        UIImage *image = [UIImage imageNamed:_picUrlArray.firstObject];
        if (image.size.width) {
            itemH = image.size.height / image.size.width * itemW;
        }
    } else {
        itemH = itemW;
    }
    long perRowItemCount = [self perRowItemCountForPicPathArray:_picUrlArray];
    CGFloat margin = 5;
    
    [_picUrlArray enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        long columnIndex = idx % perRowItemCount;
        long rowIndex = idx / perRowItemCount;
        UIImageView *imageView = [_imageViewsArray objectAtIndex:idx];
        [imageView sd_setImageWithURL:[NSURL URLWithString:obj] placeholderImage:nil];
        imageView.hidden = NO;
        imageView.image = [UIImage imageNamed:obj];
        imageView.frame = CGRectMake(columnIndex * (itemW + margin), rowIndex * (itemH + margin), itemW, itemH);
    }];
    
    CGFloat w = perRowItemCount * itemW + (perRowItemCount - 1) * margin;
    int columnCount = ceilf(_picUrlArray.count * 1.0 / perRowItemCount);
    CGFloat h = columnCount * itemH + (columnCount - 1) * margin;

    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(@(w));
        make.height.mas_equalTo(@(h));
    }];
    
    
}
- (CGFloat)itemWidthForPicPathArray:(NSArray *)array {
    if (array.count == 1) {
        return 120;
    } else {
//        CGFloat w = [UIScreen mainScreen].bounds.size.width > 320 ? 80 : 70;
        CGFloat w = (SCREENWIDTH - 30) / 3;
        return w;
    }
}

- (NSInteger)perRowItemCountForPicPathArray:(NSArray *)array {
    if (array.count < 3) {
        return array.count;
    } else if (array.count <= 4) {
        return 2;
    } else {
        return 3;
    }
}



@end











































