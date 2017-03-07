//
//  JMMaMaFansController.m
//  XLMM
//
//  Created by zhang on 17/3/1.
//  Copyright © 2017年 上海己美. All rights reserved.
//

#import "JMMaMaFansController.h"
#import "UIImage+ColorImage.h"
#import "JMNowFansController.h"
#import "JMAboutFansController.h"


@interface JMMaMaFansController () <VTMagicViewDataSource, VTMagicViewDelegate> {
    NSArray *_itemArr;
}

@end

@implementation JMMaMaFansController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createNavigationBarWithTitle:@"粉丝列表" selecotr:@selector(backClick)];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.magicView.navigationColor = [UIColor whiteColor];
    self.magicView.layoutStyle = VTLayoutStyleDivide;
    self.magicView.switchStyle = VTSwitchStyleDefault;
//    self.magicView.sliderStyle = VTSliderStyleDefault;
    self.magicView.navigationHeight = 45.f;
    self.magicView.itemScale = 1.1;
    [self configCustomSlider];
    
    _itemArr = @[@"我的粉丝",@"关于粉丝"];
//    [self.magicView reloadData];
    [self.magicView reloadDataToPage:0];
    

}
- (void)configCustomSlider {
    UIImageView *sliderView = [[UIImageView alloc] init];
    sliderView.image = [UIImage imageWithColor:[UIColor buttonEnabledBackgroundColor] Frame:CGRectMake(0, 0, SCREENWIDTH / 3, 2.f)];
    sliderView.contentMode = UIViewContentModeScaleAspectFit;
    [self.magicView setSliderView:sliderView];
}
- (NSArray<NSString *> *)menuTitlesForMagicView:(VTMagicView *)magicView {
    return _itemArr;
}
- (UIButton *)magicView:(VTMagicView *)magicView menuItemAtIndex:(NSUInteger)itemIndex {
    static NSString *itemIdentifier = @"itemIdentifier";
    UIButton *menuItem = [magicView dequeueReusableItemWithIdentifier:itemIdentifier];
    if (!menuItem) {
        menuItem = [UIButton buttonWithType:UIButtonTypeCustom];
        [menuItem setTitleColor:[UIColor buttonTitleColor] forState:UIControlStateNormal];
        [menuItem setTitleColor:[UIColor buttonEnabledBackgroundColor] forState:UIControlStateSelected];
        menuItem.titleLabel.font = [UIFont systemFontOfSize:15.f];
    }
    return menuItem;
}
- (UIViewController *)magicView:(VTMagicView *)magicView viewControllerAtPage:(NSUInteger)pageIndex {
    if (pageIndex == 0) {
        static NSString *firstID = @"firstIdentifier";
        JMNowFansController *recomViewController = [magicView dequeueReusablePageWithIdentifier:firstID];
        if (!recomViewController) {
            recomViewController = [[JMNowFansController alloc] init];
        }
        return recomViewController;
    }else {
        static NSString *secondID = @"secondIdentifier";
        JMAboutFansController *recomViewController = [magicView dequeueReusablePageWithIdentifier:secondID];
        if (!recomViewController) {
            recomViewController = [[JMAboutFansController alloc] init];
        }
        recomViewController.fansUrlString = self.aboutFansUrl;
        return recomViewController;
        
    }
    
}
#pragma mark - VTMagicViewDelegate
- (void)magicView:(VTMagicView *)magicView viewDidAppear:(__kindof UIViewController *)viewController atPage:(NSUInteger)pageIndex {
    //    NSLog(@"index:%ld viewDidAppear:%@", (long)pageIndex, viewController.view);
}

- (void)magicView:(VTMagicView *)magicView viewDidDisappear:(__kindof UIViewController *)viewController atPage:(NSUInteger)pageIndex {
    //    NSLog(@"index:%ld viewDidDisappear:%@", (long)pageIndex, viewController.view);
}

- (void)magicView:(VTMagicView *)magicView didSelectItemAtIndex:(NSUInteger)itemIndex {
    //    NSLog(@"didSelectItemAtIndex:%ld", (long)itemIndex);
}


- (void)backClick {
    [self.navigationController popViewControllerAnimated:YES];
}


@end






















