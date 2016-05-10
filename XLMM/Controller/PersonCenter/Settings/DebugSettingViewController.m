//
//  DebugSettingViewController.m
//  XLMM
//
//  Created by wulei on 5/10/16.
//  Copyright © 2016 上海己美. All rights reserved.
//

#import "DebugSettingViewController.h"
#import "AFNetworking.h"
#import "LGViews.h"

@interface DebugSettingViewController ()

@property (strong, nonatomic) UIScrollView          *scrollView;
@property (strong, nonatomic) LGRadioButtonsView    *radioButtons1;
@property (strong, nonatomic) LGRadioButtonsView    *radioButtons2;
@property (strong, nonatomic) LGRadioButtonsView    *radioButtons3;

@end

@implementation DebugSettingViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];

    
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initView];
}

- (void)initView{
    self.title = @"Debug设置";
    
    // -----
    
    _scrollView = [UIScrollView new];
    _scrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_scrollView];
    
    UIImage *circleImageNormal = [UIImage imageNamed:@"Circle_Normal"];
    
    UIImage *circleImageHighlighted = [UIImage imageNamed:@"Circle_Selected"];
    
    _radioButtons1 = [[LGRadioButtonsView alloc] initWithNumberOfButtons:3
       actionHandler:^(LGRadioButtonsView *radioButtonsView, NSString *title, NSUInteger index)
                      {
                          NSLog(@"%@, %i", title, (int)index);
                      }];
    _radioButtons1.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.f];
    _radioButtons1.contentEdgeInsets = UIEdgeInsetsMake(10.f, 10.f, 10.f, 10.f);
    [_radioButtons1 setButtonsTitles:@[@"m.xiaolumeimei.com", @"staging.xiaolumeimei.com", @"192.168.1.31:9000"] forState:UIControlStateNormal];
    [_radioButtons1 setButtonsTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_radioButtons1 setButtonsImage:circleImageNormal forState:UIControlStateNormal];
    [_radioButtons1 setButtonsImage:circleImageHighlighted forState:UIControlStateHighlighted];
    [_radioButtons1 setButtonsImage:circleImageHighlighted forState:UIControlStateSelected];
    [_radioButtons1 setButtonsAdjustsImageWhenHighlighted:NO];
    [_radioButtons1 setButtonsContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
    [_scrollView addSubview:_radioButtons1];
    
    _scrollView.frame = CGRectMake(0.f, 0.f, self.view.frame.size.width, self.view.frame.size.height);
    
    CGFloat shift = 10.f;
    
    CGSize radioButtonsSize1 = [_radioButtons1 sizeThatFits:CGSizeMake(self.view.frame.size.width-shift*2, CGFLOAT_MAX)];
    CGRect radioButtonsFrame1 = CGRectMake(shift, shift, radioButtonsSize1.width, radioButtonsSize1.height);
    radioButtonsFrame1 = CGRectIntegral(radioButtonsFrame1);
    _radioButtons1.frame = radioButtonsFrame1;
    
    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width, _radioButtons1.frame.origin.y+_radioButtons1.frame.size.height+shift);
}

@end
