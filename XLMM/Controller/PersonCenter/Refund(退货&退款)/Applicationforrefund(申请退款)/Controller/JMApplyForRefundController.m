//
//  JMApplyForRefundController.m
//  XLMM
//
//  Created by zhang on 17/2/5.
//  Copyright © 2017年 上海己美. All rights reserved.
//

#import "JMApplyForRefundController.h"
#import "JMRichTextTool.h"
#import "JMSelecterButton.h"


@interface JMApplyForRefundController ()

@property (nonatomic, strong) JMSelecterButton *submitButton;

@end

@implementation JMApplyForRefundController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavigationBarWithTitle:@"申请退款" selecotr:@selector(backClick)];
    [self createUI];
    
    

}


- (void)createUI {
    UIScrollView *baseScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
    [self.view addSubview:baseScrollView];
    baseScrollView.backgroundColor = [UIColor buttonDisabledBackgroundColor];
    
    UIView *refundDescView = [UIView new];
    [baseScrollView addSubview:refundDescView];
    refundDescView.mj_origin = CGPointMake(0, 0);
    refundDescView.mj_size = CGSizeMake(SCREENWIDTH, 80);
    refundDescView.backgroundColor = [UIColor orangeColor];
    
    UILabel *refundTitle = [UILabel new];
    [refundDescView addSubview:refundTitle];
    refundTitle.font = [UIFont systemFontOfSize:14.];
    refundTitle.textColor = [UIColor buttonTitleColor];
    refundTitle.text = @"测试数据";
    
    UILabel *refundDescTitle = [UILabel new];
    [refundDescView addSubview:refundDescTitle];
    refundDescTitle.numberOfLines = 0;
    refundDescTitle.font = [UIFont systemFontOfSize:12.];
    refundDescTitle.textColor = [UIColor dingfanxiangqingColor];
    NSString *descText = @"兔子跑到山上，那里有大片大片的草坪。怎么形容呢，绿油油的，在风里就有些泛出淡淡黄色了，可能是今天下午的斜阳把它染黄了吧，兔子这样想。 兔子把自己平坦的铺在草丛上，虽然他肉肉的，但还是很平坦，像一方凸起来的井。他自己并不这样想，吸了一口气，喝了一肚子的冷风，打了个喷嚏。哈秋。 他从厚实的肉垫里慢慢的挣扎出尖利的爪子，握了几次才握住那瓶酒，对着瓶子和月亮看了一会，咕吨咕吨喝起来，第一次觉得这啤酒也挺好喝的。兔子跑到山上，那里有大片大片的草坪。怎么形容呢，绿油油的，在风里就有些泛出淡淡黄色了，可能是今天下午的斜阳把它染黄了吧，兔子这样想。 兔子把自己平坦的铺在草丛上，虽然他肉肉的，但还是很平坦，像一方凸起来的井。他自己并不这样想，吸了一口气，喝了一肚子的冷风，打了个喷嚏。哈秋。 他从厚实的肉垫里慢慢的挣扎出尖利的爪子，握了几次才握住那瓶酒，对着瓶子和月亮看了一会，咕吨咕吨喝起来，第一次觉得这啤酒也挺好喝的。兔子跑到山上，那里有大片大片的草坪。怎么形容呢，绿油油的，在风里就有些泛出淡淡黄色了，可能是今天下午的斜阳把它染黄了吧，兔子这样想。 兔子把自己平坦的铺在草丛上，虽然他肉肉的，但还是很平坦，像一方凸起来的井。他自己并不这样想，吸了一口气，喝了一肚子的冷风，打了个喷嚏。哈秋。 他从厚实的肉垫里慢慢的挣扎出尖利的爪子，握了几次才握住那瓶酒，对着瓶子和月亮看了一会，咕吨咕吨喝起来，第一次觉得这啤酒也挺好喝的。兔子跑到山上，那里有大片大片的草坪。怎么形容呢，绿油油的，在风里就有些泛出淡淡黄色了，可能是今天下午的斜阳把它染黄了吧，兔子这样想。 兔子把自己平坦的铺在草丛上，虽然他肉肉的，但还是很平坦，像一方凸起来的井。他自己并不这样想，吸了一口气，喝了一肚子的冷风，打了个喷嚏。哈秋。 他从厚实的肉垫里慢慢的挣扎出尖利的爪子，握了几次才握住那瓶酒，对着瓶子和月亮看了一会，咕吨咕吨喝起来，第一次觉得这啤酒也挺好喝的。";//self.refundDic[@"desc"];
    refundDescTitle.text = descText;
    
    
    
    CGFloat stringHeight = [descText heightWithWidth:(SCREENWIDTH - 20) andFont:12.].height;
    
    [refundTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(refundDescView).offset(10);
    }];
    [refundDescTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(refundTitle.mas_bottom).offset(5);
        make.left.equalTo(refundTitle);
        make.width.mas_equalTo(@(SCREENWIDTH - 20));
    }];
    
    refundDescView.mj_h = stringHeight + 40;
    
    
    
    // ==============            ==================== //
    
    
    UIView *goodsView = [UIView new];
    goodsView.frame = CGRectMake(0, refundDescView.mj_h + 20, SCREENWIDTH, 90);
    goodsView.backgroundColor = [UIColor redColor];
    [baseScrollView addSubview:goodsView];
    
    // ==============            ==================== //
    
    UIView *applyForNumView = [UIView new];
    applyForNumView.frame = CGRectMake(0, goodsView.mj_y + 91, SCREENWIDTH, 45);
    [baseScrollView addSubview:applyForNumView];
    applyForNumView.backgroundColor = [UIColor orangeColor];
    
    UILabel *shenqingshuliangTitle = [UILabel new];
    [applyForNumView addSubview:shenqingshuliangTitle];
    shenqingshuliangTitle.font = [UIFont systemFontOfSize:14.];
    shenqingshuliangTitle.textColor = [UIColor buttonTitleColor];
    shenqingshuliangTitle.text = @"申请数量";
    
    [shenqingshuliangTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(applyForNumView).offset(10);
        make.centerY.equalTo(applyForNumView.mas_centerY);
    }];
    UIButton *jianButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [applyForNumView addSubview:jianButton];
    [jianButton setImage:[UIImage imageNamed:@"shopping_cart_jian"] forState:UIControlStateNormal];  // shopping_cart_add.png
    jianButton.imageEdgeInsets = UIEdgeInsetsMake(0, 9, 0, 9);
    
    UILabel *numLabel = [UILabel new];
    [applyForNumView addSubview:numLabel];
    numLabel.font = [UIFont systemFontOfSize:14.];
    numLabel.textColor = [UIColor buttonTitleColor];
    numLabel.textAlignment = NSTextAlignmentCenter;
    numLabel.text = @"1";
    
    UIButton *jiaButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [applyForNumView addSubview:jiaButton];
    [jiaButton setImage:[UIImage imageNamed:@"shopping_cart_add"] forState:UIControlStateNormal];  // shopping_cart_add.png
    jiaButton.imageEdgeInsets = UIEdgeInsetsMake(0, 9, 0, 9);
    
    [jianButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(applyForNumView.mas_centerY);
        make.right.equalTo(numLabel.mas_left).offset(10);
        make.width.height.mas_equalTo(40);
    }];
    [numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(applyForNumView.mas_centerY);
        make.right.equalTo(jiaButton.mas_left).offset(10);
        make.width.height.mas_equalTo(40);
    }];
    [jiaButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(applyForNumView.mas_centerY);
        make.right.equalTo(applyForNumView);
        make.width.height.mas_equalTo(40);
    }];
    
    // ==============            ==================== //
    
    UIView *applyForValueView = [UIView new];
    applyForValueView.frame = CGRectMake(0, applyForNumView.mj_y + 46, SCREENWIDTH, 45);
    [baseScrollView addSubview:applyForValueView];
    applyForValueView.backgroundColor = [UIColor orangeColor];
    
    UILabel *tuikuanjineTitle = [UILabel new];
    [applyForValueView addSubview:tuikuanjineTitle];
    tuikuanjineTitle.font = [UIFont systemFontOfSize:14.];
    tuikuanjineTitle.textColor = [UIColor buttonTitleColor];
    tuikuanjineTitle.text = @"退款金额";
    
    NSString *valueText = @"¥666.66";
    NSString *allValueText = [NSString stringWithFormat:@"可退金额%@",valueText];
    UILabel *tuikuanValueTitle = [UILabel new];
    [applyForValueView addSubview:tuikuanValueTitle];
    tuikuanValueTitle.font = [UIFont systemFontOfSize:14.];
    tuikuanValueTitle.textColor = [UIColor buttonTitleColor];
//    tuikuanValueTitle.text = valueText;
    tuikuanValueTitle.attributedText = [JMRichTextTool cs_changeFontAndColorWithSubFont:[UIFont systemFontOfSize:16.] SubColor:[UIColor buttonEnabledBackgroundColor] AllString:allValueText SubStringArray:@[valueText]];
    
    [tuikuanjineTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(applyForValueView).offset(10);
        make.centerY.equalTo(applyForValueView.mas_centerY);
    }];
    [tuikuanValueTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(applyForValueView).offset(-10);
        make.centerY.equalTo(applyForValueView.mas_centerY);
    }];
    
    
    
    
    
    
    
    // ==============            ==================== //
    
    UIView *refundCauseView = [UIView new];
    [baseScrollView addSubview:refundCauseView];
    refundCauseView.frame = CGRectMake(0, applyForValueView.mj_y + 65, SCREENWIDTH, 160);
    refundCauseView.backgroundColor = [UIColor greenColor];
    
    // ==============            ==================== //
    
    UILabel *tuikuanyuanyinTitle = [UILabel new];
    [refundCauseView addSubview:tuikuanyuanyinTitle];
    tuikuanyuanyinTitle.font = [UIFont systemFontOfSize:14.];
    tuikuanyuanyinTitle.textColor = [UIColor buttonTitleColor];
    tuikuanyuanyinTitle.text = @"退款原因";
    
    
    
    // ==============            ==================== //
    
    UIView *submitView = [UIView new];
    [baseScrollView addSubview:submitView];
    submitView.frame = CGRectMake(0, refundCauseView.mj_y + 161, SCREENWIDTH, 60);
    submitView.backgroundColor = [UIColor purpleColor];
    
    JMSelecterButton *submitButton = [JMSelecterButton buttonWithType:UIButtonTypeCustom];
    [submitView addSubview:submitButton];
    [submitButton setSureBackgroundColor:[UIColor buttonDisabledBackgroundColor] CornerRadius:20];
    self.submitButton = submitButton;
    [self disableTijiaoButton];
    
    [submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(submitView);
        make.width.mas_equalTo(@(SCREENWIDTH - 30));
        make.height.mas_equalTo(@40);
    }];
    
    baseScrollView.contentSize = CGSizeMake(SCREENWIDTH, submitView.mj_y + 60);
    
    
    
}



- (void)backClick {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)enableTijiaoButton{
    self.submitButton.enabled = YES;
    self.submitButton.backgroundColor = [UIColor buttonEnabledBackgroundColor];
    self.submitButton.layer.borderColor = [UIColor buttonBorderColor].CGColor;
}

- (void)disableTijiaoButton{
    self.submitButton.enabled = NO;
    self.submitButton.backgroundColor = [UIColor buttonDisabledBackgroundColor];
    self.submitButton.layer.borderColor = [UIColor buttonDisabledBorderColor].CGColor;
}










@end


















































