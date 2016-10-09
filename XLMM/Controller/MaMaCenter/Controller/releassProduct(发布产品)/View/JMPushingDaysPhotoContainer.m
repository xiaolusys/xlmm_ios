//
//  JMPushingDaysPhotoContainer.m
//  XLMM
//
//  Created by zhang on 16/10/9.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMPushingDaysPhotoContainer.h"
#import "MMClass.h"
#import "PhotoView.h"

@interface JMPushingDaysPhotoContainer () {
    CGFloat h;
    CGFloat imageViewW;
    long lineNumber;
    CGFloat itemW;
    CGFloat itemH;
    CGFloat margin;
    long perRowItemCount;
}

@property (nonatomic, strong) NSMutableArray *imageViewsArray;
@property (nonatomic, strong) PhotoView *photoView;


@end

@implementation JMPushingDaysPhotoContainer

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}
- (void)setup {
    self.imageViewsArray = [NSMutableArray array];
    for (int i = 0; i < 9; i++) {
        UIImageView *imageView = [UIImageView new];
        [self addSubview:imageView];
        imageView.userInteractionEnabled = YES;
        imageView.tag = 100 + i;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageView:)];
        [imageView addGestureRecognizer:tap];
        UIView *tapView = [tap view];
        tapView.tag = 100 + i;
        [self.imageViewsArray addObject:imageView];
        
    }
    
}
- (void)setPicPathStringsArray:(NSArray *)picPathStringsArray
{
    _picPathStringsArray = picPathStringsArray;
    
    for (long i = _picPathStringsArray.count; i < self.imageViewsArray.count; i++) {
        UIImageView *imageView = [self.imageViewsArray objectAtIndex:i];
        imageView.hidden = YES;
    }
    
    if (_picPathStringsArray.count == 0) {
        h = 0;
        return;
    }
    
    lineNumber = [self perRowItemCountForPicPathArray:_picPathStringsArray];
    itemW = [self itemWidthForPicPathArray:_picPathStringsArray];
    itemH = 0;
    if (_picPathStringsArray.count == 1) {
        UIImage *image = [UIImage imageNamed:_picPathStringsArray.firstObject];
        if (image.size.width) {
            itemH = image.size.height / image.size.width * itemW;
        }
    } else {
        itemH = itemW;
    }
    perRowItemCount = [self perRowItemCountForPicPathArray:_picPathStringsArray];
    margin = 5;

    [_picPathStringsArray enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        long columnIndex = idx % perRowItemCount;
        long rowIndex = idx / perRowItemCount;
        UIImageView *imageView = [_imageViewsArray objectAtIndex:idx];
        imageView.hidden = NO;
//        imageView.image = [UIImage imageNamed:obj];
        if ([obj hasPrefix:@"http://img.xiaolumeimei.com"]) {
            obj = [NSString stringWithFormat:@"%@?imageMogr2/thumbnail/578/format/jpg/quality/90", obj];
        }else {
        }
        [imageView sd_setImageWithURL:[NSURL URLWithString:obj] placeholderImage:[UIImage imageNamed:@"zhanwei"]];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.frame = CGRectMake(columnIndex * (itemW + margin), rowIndex * (itemH + margin), itemW, itemH);
    }];
    
//    CGFloat w = perRowItemCount * itemW + (perRowItemCount - 1) * margin;
    int columnCount = ceilf(_picPathStringsArray.count * 1.0 / perRowItemCount);
    h = columnCount * itemH + (columnCount - 1) * margin;

}

- (CGSize)sizeThatFits:(CGSize)size {
//    imageViewW = size.width;
    CGFloat totalHeight = h;
    return CGSizeMake(size.width, totalHeight);
}

- (CGFloat)itemWidthForPicPathArray:(NSArray *)array {
    imageViewW = [UIScreen mainScreen].bounds.size.width - 90;
    if (array.count == 1) {
        return 120;
    } else {
        CGFloat w = (imageViewW - (lineNumber - 1) * 5) / 3;//[UIScreen mainScreen].bounds.size.width > 320 ? 80 : 70;
        return w;
    }
}
- (NSInteger)perRowItemCountForPicPathArray:(NSArray *)array {
    if (array.count < 3) {
        return array.count;
    } else {
        return 3;
    }
}

- (void)tapImageView:(UITapGestureRecognizer *)tap {
    UIView *image = tap.view;
    NSInteger tagIndex = image.tag - 100;
//    UIImageView *image = (UIImageView *)[self viewWithTag:imageView.tag];
//    long columnIndex = tagIndex % perRowItemCount;
//    long rowIndex = tagIndex / perRowItemCount;
//    image.frame = CGRectMake(80 + columnIndex * (itemW + margin),100 + rowIndex * (itemH + margin), itemW, itemH);
    self.photoView = [[PhotoView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    self.photoView.picArr = [self.picPathStringsArray mutableCopy];
    self.photoView.index = tagIndex;
    
    [self.photoView createScrollView];
    [self.photoView fillData:tagIndex cellFrame:CGRectMake(100, 200, 0, 0)];
    [[[UIApplication sharedApplication].delegate window]addSubview:self.photoView];

    
    
}




@end

































































































