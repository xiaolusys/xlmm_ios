//
//  JMPhotoBrowesView.h
//  XLMM
//
//  Created by zhang on 16/11/10.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>


@class JMPhotoBrowesView;

@protocol JMPhotoBrowesViewDelegate <NSObject>
@end

@protocol JMPhotoBrowesViewDatasource <NSObject>

@optional

- (UIImage *)photoBrowser:(JMPhotoBrowesView *)browser placeholderImageForIndex:(NSInteger)index;

- (NSURL *)photoBrowser:(JMPhotoBrowesView *)browser highQualityImageURLForIndex:(NSInteger)index;

- (ALAsset *)photoBrowser:(JMPhotoBrowesView *)browser assetForIndex:(NSInteger)index;

- (UIImageView *)photoBrowser:(JMPhotoBrowesView *)browser sourceImageViewForIndex:(NSInteger)index;

@end

@interface JMPhotoBrowesView : UIView


@property (nonatomic, strong) UIImageView *sourceImageView;
// 当前图片位置索引
@property (nonatomic, assign) NSInteger currentImageIndex;
// 图片数量
@property (nonatomic, assign) NSInteger imageCount;

@property (nonatomic, strong) UIImage *placeholderImage;

@property (nonatomic, weak) id <JMPhotoBrowesViewDatasource> datasource;
@property (nonatomic , weak) id <JMPhotoBrowesViewDelegate> delegate;



+ (instancetype)showPhotoBrowesWihtCurrentImageIndex:(NSInteger)index ImageCount:(NSInteger)count DataSource:(id<JMPhotoBrowesViewDatasource>)dataSource;
+ (instancetype)showPhotoBrowserWithImages:(NSArray *)images currentImageIndex:(NSInteger)currentImageIndex;
// 保存图片
- (void)saveCurrentShowImage;
// 显示图片浏览器
- (void)show;
// 退出图片浏览器
- (void)dismiss;










@end
































































































