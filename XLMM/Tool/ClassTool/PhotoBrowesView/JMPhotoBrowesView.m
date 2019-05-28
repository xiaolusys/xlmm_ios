//
//  JMPhotoBrowesView.m
//  XLMM
//
//  Created by zhang on 16/11/10.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMPhotoBrowesView.h"
#import "JMBorwesScrollView.h"
#import "JMPageControl.h"
#import "UIImage+UIImageExt.h"


@interface JMPhotoBrowesView () <JMBorwesScrollViewDelegate, UIScrollViewDelegate>

// 存放图片
@property (nonatomic, strong) UIScrollView *scrollView;

// 正在使用的scrollView对象集合
@property (nonatomic, strong) NSMutableSet *visibleBorwesScrollViews;
// 循环复用的scrollView对象集合
@property (nonatomic , strong) NSMutableSet  *reusableBorwesScrollViews;

@property (nonatomic, strong) NSArray *images;

@property (nonatomic, strong) JMPageControl *systemPageCtrol;


@end


@implementation JMPhotoBrowesView


- (UIImage *)placeholderImage {
    if (!_placeholderImage) {
        _placeholderImage = [UIImage imageNamed:@"zhanwei"];
    }
    return _placeholderImage;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    self.backgroundColor = [UIColor colorWithRed:10 / 255. green:10 / 255. blue:10 / 255. alpha:0.9];
    self.visibleBorwesScrollViews = [[NSMutableSet alloc] init];
    self.reusableBorwesScrollViews = [[NSMutableSet alloc] init];
    [self placeholderImage];
}


- (void)setUpUI {
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self setUpPageControl];
    [self setUpScrollView];

    [self showFirstImage];
}
- (void)setUpPageControl {
    if (self.systemPageCtrol) {
        [self.systemPageCtrol removeFromSuperview];
    }
    self.systemPageCtrol = [[JMPageControl alloc] init];
    self.systemPageCtrol.frame = CGRectMake(0, self.mj_h  - 30, self.mj_w, 20);
    self.systemPageCtrol.enabled = NO;
    //    [self.systemPageCtrl addTarget:self action:@selector(pageControlAction:) forControlEvents:UIControlEventValueChanged];
    UIView *nomalView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 3)];
    UIView *selectedView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 3)];
    nomalView.backgroundColor = [UIColor buttonDisabledBorderColor];
    selectedView.backgroundColor = [UIColor buttonEnabledBackgroundColor];
    self.systemPageCtrol.normalPageView = nomalView;
    self.systemPageCtrol.currentPageView = selectedView;
    self.systemPageCtrol.padding = 10;
//    UIWindow *window = [self findTheMainWindow];
    [JMKeyWindow addSubview:self.systemPageCtrol];
//    [self insertSubview:self.systemPageCtrol aboveSubview:self.scrollView];
    
    self.systemPageCtrol.numberOfPages = self.imageCount;
    [self setPageCtrlCurrentPage:self.currentImageIndex];
    
}
- (void)setPageCtrlCurrentPage:(NSInteger)currentPage {
    self.systemPageCtrol.currentPage = currentPage;
}


- (void)setUpScrollView {
//    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
//    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
//    effectView.frame = self.bounds;
//    [self addSubview:effectView];
//    
//    UIImageView *imageV = [UIImageView new];
//    imageV.frame = self.bounds;
//    imageV.userInteractionEnabled = YES;
//    imageV.contentMode = UIViewContentModeScaleAspectFill;
//    imageV.image = [UIImage boxblurImage:[UIImage imageNamed:@"Icon-76"] withBlurNumber:0.5];
//    imageV.clipsToBounds = YES;
//    [self addSubview:imageV];
    
    CGRect rect = self.bounds;
    rect.size.width += 10;    // 图片之间的间隔
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.frame = rect;
    self.scrollView.mj_x = 0;
    self.scrollView.delegate = self;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.backgroundColor = [UIColor clearColor];
    self.scrollView.contentSize = CGSizeMake((self.scrollView.frame.size.width) * self.imageCount, 0);
    [self addSubview:self.scrollView];
    self.scrollView.contentOffset = CGPointMake(self.currentImageIndex * (self.scrollView.frame.size.width), 0);
    if (self.currentImageIndex == 0) { // 修复bug , 如果刚进入的时候是0,不会调用scrollViewDidScroll:方法,不会展示第一张图片
        [self showPhotos];
    }

}
- (void)showPhotos {
    // 只有一张图片
    if (self.imageCount == 1) {
        [self setUpImageForZoomingScrollViewAtIndex:0];
        return;
    }
    
    CGRect visibleBounds = self.scrollView.bounds;
    NSInteger firstIndex = floor((CGRectGetMinX(visibleBounds)) / CGRectGetWidth(visibleBounds));
    NSInteger lastIndex  = floor((CGRectGetMaxX(visibleBounds)-1) / CGRectGetWidth(visibleBounds));
    
    if (firstIndex < 0) {
        firstIndex = 0;
    }
    if (firstIndex >= self.imageCount) {
        firstIndex = self.imageCount - 1;
    }
    if (lastIndex < 0){
        lastIndex = 0;
    }
    if (lastIndex >= self.imageCount) {
        lastIndex = self.imageCount - 1;
    }
    
    // 回收不再显示的zoomingScrollView
    NSInteger zoomingScrollViewIndex = 0;
    for (JMBorwesScrollView *zoomingScrollView in self.visibleBorwesScrollViews) {
        zoomingScrollViewIndex = zoomingScrollView.tag - 100;
        if (zoomingScrollViewIndex < firstIndex || zoomingScrollViewIndex > lastIndex) {
            [self.reusableBorwesScrollViews addObject:zoomingScrollView];
            [zoomingScrollView prepareForReuse];
            [zoomingScrollView removeFromSuperview];
        }
    }
    
    // _visiblePhotoViews 减去 _reusablePhotoViews中的元素
    [self.visibleBorwesScrollViews minusSet:self.reusableBorwesScrollViews];
    while (self.reusableBorwesScrollViews.count > 2) { // 循环利用池中最多保存两个可以用对象
        [self.reusableBorwesScrollViews removeObject:[self.reusableBorwesScrollViews anyObject]];
    }
    
    // 展示图片
    for (NSInteger index = firstIndex; index <= lastIndex; index++) {
        if (![self isShowingZoomingScrollViewAtIndex:index]) {
            [self setUpImageForZoomingScrollViewAtIndex:index];
        }
    }
}

/**
 *   加载指定位置的图片
 */
- (void)setUpImageForZoomingScrollViewAtIndex:(NSInteger)index {
    JMBorwesScrollView *zoomingScrollView = [self dequeueReusableZoomingScrollView];
    zoomingScrollView.browesScrollViewDelegate = self;
    [zoomingScrollView addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)]];
    zoomingScrollView.tag = 100 + index;
    zoomingScrollView.frame = CGRectMake((self.scrollView.mj_w) * index, 0, self.mj_w, self.mj_h);
    self.currentImageIndex = index;
    if (zoomingScrollView.isLoadingImage == NO) {
        if ([self highQualityImageURLForIndex:index]) { // 如果提供了高清大图数据源,就去加载
            [zoomingScrollView showHightQualityImageUrl:[self highQualityImageURLForIndex:index] placeholderImage:[self placeholderImageForIndex:index]];
        } else if ([self assetForIndex:index]) {
            ALAsset *asset = [self assetForIndex:index];
            CGImageRef imageRef = asset.defaultRepresentation.fullScreenImage;
            [zoomingScrollView showImage:[UIImage imageWithCGImage:imageRef]];
            CGImageRelease(imageRef);
        } else {
            [zoomingScrollView showImage:[self placeholderImageForIndex:index]];
        }
        zoomingScrollView.isLoadingImage = YES;
    }
    
    [self.visibleBorwesScrollViews addObject:zoomingScrollView];
    [self.scrollView addSubview:zoomingScrollView];
}
/**
 *  判断指定的某个位置图片是否在显示
 */
- (BOOL)isShowingZoomingScrollViewAtIndex:(NSInteger)index {
    for (JMBorwesScrollView *view in self.visibleBorwesScrollViews) {
        if ((view.tag - 100) == index) {
            return YES;
        }
    }
    return NO;
}
/**
 *  获取指定位置的XLZoomingScrollView , 三级查找,正在显示的池,回收池,创建新的并赋值
 *
 *  @param index 指定位置索引
 */
- (JMBorwesScrollView *)zoomingScrollViewAtIndex:(NSInteger)index {
    for (JMBorwesScrollView* zoomingScrollView in self.visibleBorwesScrollViews) {
        if ((zoomingScrollView.tag - 100) == index) {
            return zoomingScrollView;
        }
    }
    JMBorwesScrollView* zoomingScrollView = [self dequeueReusableZoomingScrollView];
    [self setUpImageForZoomingScrollViewAtIndex:index];
    return zoomingScrollView;
}
/**
 *  从缓存池中获取一个XLZoomingScrollView对象
 */
- (JMBorwesScrollView *)dequeueReusableZoomingScrollView {
    JMBorwesScrollView *photoView = [self.reusableBorwesScrollViews anyObject];
    if (photoView) {
        [self.reusableBorwesScrollViews removeObject:photoView];
    } else {
        photoView = [[JMBorwesScrollView alloc] init];
    }
    return photoView;
}
/**
 *  获取指定位置的高清大图URL,和外界的数据源交互
 */
- (NSURL *)highQualityImageURLForIndex:(NSInteger)index {
    if (self.datasource && [self.datasource respondsToSelector:@selector(photoBrowser:highQualityImageURLForIndex:)]) {
        NSURL *url = [self.datasource photoBrowser:self highQualityImageURLForIndex:index];
        if (!url) {
            NSLog(@"高清大图URL数据 为空,请检查代码 , 图片索引:%zd",index);
            return nil;
        }
        if ([url isKindOfClass:[NSString class]]) {
            url = [NSURL URLWithString:(NSString *)url];
        }
        if (![url isKindOfClass:[NSURL class]]) {
            NSLog(@"高清大图URL数据有问题,不是NSString也不是NSURL , 错误数据:%@ , 图片索引:%zd",url,index);
        }
        //        NSAssert([url isKindOfClass:[NSURL class]], @"高清大图URL数据有问题,不是NSString也不是NSURL");
        return url;
    } else if(self.images.count>index) {
        if ([self.images[index] isKindOfClass:[NSURL class]]) {
            return self.images[index];
        } else if ([self.images[index] isKindOfClass:[NSString class]]) {
            NSURL *url = [NSURL URLWithString:self.images[index]];
            return url;
        } else {
            return nil;
        }
    }
    return nil;
}
/**
 *  获取指定位置的占位图片,和外界的数据源交互
 */
- (UIImage *)placeholderImageForIndex:(NSInteger)index {
    if (self.datasource && [self.datasource respondsToSelector:@selector(photoBrowser:placeholderImageForIndex:)]) {
        return [self.datasource photoBrowser:self placeholderImageForIndex:index];
    } else if(self.images.count>index) {
        if ([self.images[index] isKindOfClass:[UIImage class]]) {
            return self.images[index];
        } else {
            return self.placeholderImage;
        }
    }
    return self.placeholderImage;
}
/**
 *  获取指定位置的 ALAsset,获取图片
 */
- (ALAsset *)assetForIndex:(NSInteger)index
{
    if (self.datasource && [self.datasource respondsToSelector:@selector(photoBrowser:assetForIndex:)]) {
        return [self.datasource photoBrowser:self assetForIndex:index];
    } else if (self.images.count > index) {
        if ([self.images[index] isKindOfClass:[ALAsset class]]) {
            return self.images[index];
        } else {
            return nil;
        }
    }
    return nil;
}
/**
 *  获取多图浏览,指定位置图片的UIImageView视图,用于做弹出放大动画和回缩动画
 */
- (UIView *)sourceImageViewForIndex:(NSInteger)index {
    if (self.datasource && [self.datasource respondsToSelector:@selector(photoBrowser:sourceImageViewForIndex:)]) {
        return [self.datasource photoBrowser:self sourceImageViewForIndex:index];
    }
    return nil;
}

/**
 *  第一个展示的图片 , 点击图片,放大的动画就是从这里来的
 */
- (void)showFirstImage {
    // 获取到用户点击的那个UIImageView对象,进行坐标转化
    CGRect startRect;
    if (self.sourceImageView) {
        
    } else if(self.datasource && [self.datasource respondsToSelector:@selector(photoBrowser:sourceImageViewForIndex:)]) {
        self.sourceImageView = [self.datasource photoBrowser:self sourceImageViewForIndex:self.currentImageIndex];
    } else {
        [UIView animateWithDuration:0.25 animations:^{
            self.alpha = 1.0;
        }];
        NSLog(@"需要提供源视图才能做弹出/退出图片浏览器的缩放动画");
        return;
    }
    startRect = [self.sourceImageView.superview convertRect:self.sourceImageView.frame toView:self];
    
    UIImageView *tempView = [[UIImageView alloc] init];
    tempView.image = [self placeholderImageForIndex:self.currentImageIndex];
    tempView.frame = startRect;
    [self addSubview:tempView];
    
    CGRect targetRect; // 目标frame
    UIImage *image = self.sourceImageView.image;
    CGFloat imageWidthHeightRatio = image.size.width / image.size.height;
    CGFloat width = SCREENWIDTH;
    CGFloat height = SCREENWIDTH / imageWidthHeightRatio;
    CGFloat x = 0;
    CGFloat y;
    if (height > SCREENHEIGHT) {
        y = 0;
    } else {
        y = (SCREENHEIGHT - height ) * 0.5;
    }
    targetRect = CGRectMake(x, y, width, height);
    self.scrollView.hidden = YES;
    self.alpha = 1.0;
    
    // 动画修改图片视图的frame , 居中同时放大
    [UIView animateWithDuration:0.4 animations:^{
        tempView.frame = targetRect;
    } completion:^(BOOL finished) {
        [tempView removeFromSuperview];
        self.scrollView.hidden = NO;
    }];
}

#pragma mark    -   XLZoomingScrollViewDelegate

/**
 *  单击图片,退出浏览
 */
- (void)composeBrowesScrollView:(JMBorwesScrollView *)browesScrollView singleTapDetected:(UITapGestureRecognizer *)singleTap {
    NSInteger currentIndex = browesScrollView.tag - 100;
    UIView *sourceView = [self sourceImageViewForIndex:currentIndex];
    if (sourceView == nil) {
        [self dismiss];
        return;
    }
    self.scrollView.hidden = YES;
    
    CGRect targetTemp = [sourceView.superview convertRect:sourceView.frame toView:self];
    
    UIImageView *tempView = [[UIImageView alloc] init];
    tempView.contentMode = sourceView.contentMode;
    tempView.clipsToBounds = YES;
    tempView.image = browesScrollView.currentShowImage;
    tempView.frame = CGRectMake( - browesScrollView.contentOffset.x + browesScrollView.imageView.mj_x,  - browesScrollView.contentOffset.y + browesScrollView.imageView.mj_y, browesScrollView.imageView.mj_w, browesScrollView.imageView.mj_h);
    [self addSubview:tempView];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    [UIView animateWithDuration:0.4 animations:^{
        [self.systemPageCtrol removeFromSuperview];
        tempView.frame = targetTemp;
        self.backgroundColor = [UIColor clearColor];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self showPhotos];
    NSInteger pageNum = floor((scrollView.contentOffset.x + scrollView.bounds.size.width * 0.5) / scrollView.bounds.size.width);
    self.currentImageIndex = pageNum == self.imageCount ? pageNum - 1 : pageNum;
    [self setPageCtrlCurrentPage:self.currentImageIndex];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger pageNum = floor((scrollView.contentOffset.x + scrollView.bounds.size.width * 0.5) / scrollView.bounds.size.width);
    self.currentImageIndex = pageNum == self.imageCount ? pageNum - 1 : pageNum;
    [self setPageCtrlCurrentPage:self.currentImageIndex];
}









/**
 *  快速创建并进入图片浏览器
 *
 *  @param currentImageIndex 开始展示的图片索引
 *  @param imageCount        图片数量
 *  @param datasource        数据源
 *
 */
+ (instancetype)showPhotoBrowesWihtCurrentImageIndex:(NSInteger)index ImageCount:(NSInteger)count DataSource:(id<JMPhotoBrowesViewDatasource>)dataSource {
    JMPhotoBrowesView *browser = [[JMPhotoBrowesView alloc] init];
    browser.imageCount = count;
    browser.currentImageIndex = index;
    browser.datasource = dataSource;
    [browser show];
    return browser;
}

/**
 *  保存当前展示的图片
 */
- (void)saveCurrentShowImage {
//    [self saveImage];
}
/**
 一行代码展示(在某些使用场景,不需要做很复杂的操作,例如不需要长按弹出actionSheet,从而不需要实现数据源方法和代理方法,那么可以选择这个方法,直接传数据源数组进来,框架内部做处理)
 
 @param images            图片数据源数组(,内部可以是UIImage/NSURL网络图片地址/ALAsset)
 @param currentImageIndex 展示第几张
 
 @return XLPhotoBrowser实例对象
 */
+ (instancetype)showPhotoBrowserWithImages:(NSArray *)images currentImageIndex:(NSInteger)currentImageIndex {
    if (images.count <=0 || images ==nil) {
        NSLog(@"一行代码展示图片浏览的方法,传入的数据源为空,不进入图片浏览,请检查传入数据源");
        return nil;
    }
    
    Class imageClass = [images.firstObject class];
    for (id image in images) {
        if (![image isKindOfClass:imageClass]) {
            NSLog(@"传入的数据源数组内对象类型不一致,暂不支持,请检查");
            return nil;
        }
    }
    
    JMPhotoBrowesView *browser = [[JMPhotoBrowesView alloc] init];
    browser.imageCount = images.count;
    browser.currentImageIndex = currentImageIndex;
    browser.images = images;
    [browser show];
    return browser;
}
- (void)show {
    if (self.imageCount <= 0) {
        return;
    }
    if (self.currentImageIndex >= self.imageCount) {
        self.currentImageIndex = self.imageCount - 1;
    }
    if (self.currentImageIndex < 0) {
        self.currentImageIndex = 0;
    }
//    UIWindow *window = [self findTheMainWindow];
    
    self.frame = JMKeyWindow.bounds;
    self.alpha = 0.0;
    [JMKeyWindow addSubview:self];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    [self setUpUI];
}

/**
 *  退出
 */
- (void)dismiss {
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    [UIView animateWithDuration:0.4 animations:^{
        [self.systemPageCtrol removeFromSuperview];
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)longPress:(UILongPressGestureRecognizer *)longPress {
    if (longPress.state == UIGestureRecognizerStateBegan) {
        
    }
}


- (UIWindow *)findTheMainWindow {
    NSEnumerator *frontToBackWindows = [UIApplication.sharedApplication.windows reverseObjectEnumerator];
    for (UIWindow *window in frontToBackWindows) {
        BOOL windowOnMainScreen = window.screen == UIScreen.mainScreen;
        BOOL windowIsVisible = !window.hidden && window.alpha > 0;
        BOOL windowLevelSupported = (window.windowLevel >= UIWindowLevelNormal);
        
        if(windowOnMainScreen && windowIsVisible && windowLevelSupported) {
            return window;
        }
    }
    return [[[UIApplication sharedApplication] delegate] window];
}
- (void)dealloc {
    [self.reusableBorwesScrollViews removeAllObjects];
    [self.visibleBorwesScrollViews removeAllObjects];
}



@end





































































































































