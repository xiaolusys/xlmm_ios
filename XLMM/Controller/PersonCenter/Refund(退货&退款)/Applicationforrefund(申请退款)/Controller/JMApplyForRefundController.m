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
#import <QuartzCore/QuartzCore.h>
#import <CoreGraphics/CoreGraphics.h>
#import "JMOrderGoodsModel.h"
#import "JMRefundView.h"
#import "JMPopViewAnimationSpring.h"



@interface JMApplyForRefundController () <UITextViewDelegate,UIActionSheetDelegate,UIScrollViewDelegate,JMRefundViewDelegate> {
    NSArray *_dataArray;
    UIVisualEffectView *effectView;
    int reasonCode;
    int number;
    int maxNumber;
    float refundPrice;
}

@property (nonatomic, strong) UIScrollView *baseScrollView;
@property (nonatomic, strong) JMSelecterButton *submitButton;
@property (nonatomic, strong) UITextView *refundDescTextView;
@property (nonatomic, strong) UILabel *textViewPlaceholdLabel;
@property (nonatomic, strong) UIView *reasonView;
@property (nonatomic, strong) UILabel *refundCauseLabel;
@property (nonatomic, strong) UILabel *tuikuanValueTitle;
@property (nonatomic, strong) UILabel *numberLabel;

@property (nonatomic,strong) UIView *maskView;
@property (nonatomic, strong) JMRefundView *popView;

@end

@implementation JMApplyForRefundController

- (void)registerForKeyboardNotifications {
    [JMNotificationCenter addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    [JMNotificationCenter addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)unregisterForKeyboardNotifications {
    [JMNotificationCenter removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [JMNotificationCenter removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self registerForKeyboardNotifications];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self unregisterForKeyboardNotifications];
}
- (void)keyboardWasShown:(NSNotification *)Notification {
    CGRect keyboardFrame = [Notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat height = keyboardFrame.size.height;
    CGFloat scrollY = self.baseScrollView.contentOffset.y + 64;
    CGFloat maxY = self.refundDescTextView.superview.mj_y + 160 - scrollY;
    if ((SCREENHEIGHT - maxY) < height) {
        [UIView animateWithDuration:0.3 animations:^{
//            self.view.frame = CGRectMake(0, -height, SCREENWIDTH, height + SCREENHEIGHT);
            self.view.mj_y = -height + SCREENHEIGHT - maxY - 75;
        }];
    }
}

- (void)keyboardWillBeHidden:(NSNotification *)aNotification{
    [UIView animateWithDuration:0 animations:^{
        self.view.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT);
    }];

    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavigationBarWithTitle:@"申请退款" selecotr:@selector(backClick)];
//    self.view.translatesAutoresizingMaskIntoConstraints = YES;
    [self createUI];
    [self loadReasonView];
    
    _dataArray = @[
                       @"错拍",//1
                       @"缺货",
                       @"商品质量问题",//3
                       @"发错货/漏发",//4
                       @"没有发货",//5
                       @"未收到货",//6
                       @"与描述不符",//7
                       @"退运费",//8
                       @"发票问题",
                       @"七天无理由退换货",//10
                       @"其他"//0
                       ];

}

- (void)setDingdanModel:(JMOrderGoodsModel *)dingdanModel {
    _dingdanModel = dingdanModel;
}
- (void)setRefundDic:(NSDictionary *)refundDic {
    _refundDic = refundDic;
}
- (void)setTid:(NSString *)tid {
    _tid = tid;
}



- (void)loadReasonView{
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:2];
    //  毛玻璃view 视图
    effectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    //添加到要有毛玻璃特效的控件中
    effectView.frame = CGRectMake(0, SCREENHEIGHT, SCREENWIDTH, SCREENHEIGHT);
    [self.view addSubview:effectView];
    //设置模糊透明度
    effectView.alpha = 1.0f;
    
    
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"SelectedReasonsView" owner:nil options:nil];
    self.reasonView = [views objectAtIndex:0];
    UIButton *cancelButton = (UIButton *)[self.reasonView viewWithTag:200];
    cancelButton.layer.cornerRadius = 20;
    cancelButton.layer.borderWidth = 1;
    cancelButton.layer.borderColor = [UIColor buttonBorderColor].CGColor;
    [cancelButton addTarget:self action:@selector(cancelSeleted:) forControlEvents:UIControlEventTouchUpInside];
    UIView *listView = (UIView *)[self.reasonView viewWithTag:100];
    
    listView.layer.masksToBounds = YES;
    listView.layer.cornerRadius = 10;
    
    
    UIScrollView *scrollView = (UIScrollView *)[self.reasonView viewWithTag:886];
    scrollView.contentOffset = CGPointMake(0, -150);
    // scrollView.bounces = NO;
    // scrollView.showsVerticalScrollIndicator = NO;
    self.reasonView.frame = CGRectMake(0, SCREENHEIGHT, SCREENWIDTH, SCREENHEIGHT);
    self.reasonView.alpha = 0.9;
    self.reasonView.hidden = YES;
    [self.view addSubview:self.reasonView];
    //  UIButton *button0 = (UIButton *)[reasonView viewWithTag:800];
    for (int i = 0; i < 11; i++) {
        UIButton *button = (UIButton *)[self.reasonView viewWithTag:800 + i];
        [button setTitleColor:[UIColor orangeThemeColor] forState:UIControlStateHighlighted];
        
        button.showsTouchWhenHighlighted = NO;
        //  button.highlighted = NO;
        [button addTarget:self action:@selector(selectReason:) forControlEvents:UIControlEventTouchUpInside];
        NSLog(@"uibuton = %@", button);
    }
}
- (void)hiddenReasonView{
    self.reasonView.hidden = YES;
    [UIView animateWithDuration:0.3 animations:^{
        self.reasonView.frame = CGRectMake(0, SCREENHEIGHT, SCREENWIDTH, SCREENHEIGHT);
        effectView.frame = CGRectMake(0, SCREENHEIGHT, SCREENWIDTH, SCREENHEIGHT);
        self.navigationController.navigationBarHidden = NO;
    }completion:^(BOOL finished) {
        
        
    }];
    
}
- (void)showReasonView{
    self.reasonView.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.reasonView.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT);
        effectView.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT);
        self.navigationController.navigationBarHidden = YES;
    }completion:^(BOOL finished) {
        
    }];
}

- (void)createUI {
    UIScrollView *baseScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
    [self.view addSubview:baseScrollView];
    baseScrollView.delegate = self;
    baseScrollView.backgroundColor = [UIColor countLabelColor];
    self.baseScrollView = baseScrollView;
    
    UIView *refundDescView = [UIView new];
    [baseScrollView addSubview:refundDescView];
    refundDescView.mj_origin = CGPointMake(0, 0);
    refundDescView.mj_size = CGSizeMake(SCREENWIDTH, 80);
    refundDescView.backgroundColor = [UIColor whiteColor];
    
    UILabel *refundTitle = [UILabel new];
    [refundDescView addSubview:refundTitle];
    refundTitle.font = [UIFont systemFontOfSize:14.];
    refundTitle.textColor = [UIColor buttonTitleColor];
    refundTitle.text = self.refundDic[@"name"];
    
    UILabel *refundDescTitle = [UILabel new];
    [refundDescView addSubview:refundDescTitle];
    refundDescTitle.numberOfLines = 0;
    refundDescTitle.font = [UIFont systemFontOfSize:12.];
    refundDescTitle.textColor = [UIColor dingfanxiangqingColor];
    NSString *descText = self.refundDic[@"desc"];
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
    [baseScrollView addSubview:goodsView];
    goodsView.backgroundColor = [UIColor whiteColor];
    
    UIImageView *iconImage = [UIImageView new];
    [goodsView addSubview:iconImage];
    iconImage.userInteractionEnabled = YES;
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapViewClick:)];
//    [iconImage addGestureRecognizer:tap];
    [iconImage sd_setImageWithURL:[NSURL URLWithString:[[self.dingdanModel.pic_path imageGoodsOrderCompression] JMUrlEncodedString]]];
    iconImage.contentMode = UIViewContentModeScaleAspectFill;
    iconImage.layer.masksToBounds = YES;
    iconImage.layer.borderWidth = 0.5;
    iconImage.layer.borderColor = [UIColor dingfanxiangqingColor].CGColor;
    iconImage.layer.cornerRadius = 5;
    
    UILabel *titleLabel = [UILabel new];
    [goodsView addSubview:titleLabel];
    titleLabel.font = [UIFont systemFontOfSize:13.];
    titleLabel.numberOfLines = 2;
    
    UILabel *PriceLabel = [UILabel new];
    [goodsView addSubview:PriceLabel];
    PriceLabel.font = [UIFont boldSystemFontOfSize:12.];
    PriceLabel.textColor = [UIColor buttonEnabledBackgroundColor];
    
    UILabel *sizeLabel = [UILabel new];
    [goodsView addSubview:sizeLabel];
    sizeLabel.font = [UIFont boldSystemFontOfSize:12.];
    sizeLabel.textColor = [UIColor dingfanxiangqingColor];
    
    UILabel *goodsNumLabel = [UILabel new];
    [goodsView addSubview:goodsNumLabel];
    goodsNumLabel.font = [UIFont systemFontOfSize:12.];
    goodsNumLabel.textColor = [UIColor dingfanxiangqingColor];
    
    [iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(goodsView).offset(10);
        make.width.height.mas_equalTo(@70);
    }];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(iconImage);
        make.left.equalTo(iconImage.mas_right).offset(10);
        make.right.equalTo(goodsView).offset(-10);
    }];
    
    [sizeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).offset(10);
        make.left.equalTo(titleLabel);
        make.right.equalTo(goodsView).offset(-10);
        //        make.width.mas_equalTo(@(SCREENWIDTH - 180));
    }];
    
    [PriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(iconImage.mas_bottom);
        make.left.equalTo(titleLabel);
    }];
    
    [goodsNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(PriceLabel);
        make.left.equalTo(PriceLabel.mas_right).offset(10);
    }];
    
    
    
    
    // ==============            ==================== //
    
    UIView *applyForNumView = [UIView new];
    applyForNumView.frame = CGRectMake(0, goodsView.mj_y + 91, SCREENWIDTH, 45);
    [baseScrollView addSubview:applyForNumView];
    applyForNumView.backgroundColor = [UIColor whiteColor];
    
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
    [jianButton addTarget:self action:@selector(reduceRefundNumClick) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *numLabel = [UILabel new];
    [applyForNumView addSubview:numLabel];
    numLabel.font = [UIFont systemFontOfSize:14.];
    numLabel.textColor = [UIColor buttonTitleColor];
    numLabel.textAlignment = NSTextAlignmentCenter;
    self.numberLabel = numLabel;
    
    UIButton *jiaButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [applyForNumView addSubview:jiaButton];
    [jiaButton setImage:[UIImage imageNamed:@"shopping_cart_add"] forState:UIControlStateNormal];  // shopping_cart_add.png
    jiaButton.imageEdgeInsets = UIEdgeInsetsMake(0, 9, 0, 9);
    [jiaButton addTarget:self action:@selector(addRefundNumClick) forControlEvents:UIControlEventTouchUpInside];
    
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
    applyForValueView.backgroundColor = [UIColor whiteColor];
    
    UILabel *tuikuanjineTitle = [UILabel new];
    [applyForValueView addSubview:tuikuanjineTitle];
    tuikuanjineTitle.font = [UIFont systemFontOfSize:14.];
    tuikuanjineTitle.textColor = [UIColor buttonTitleColor];

    UILabel *tuikuanValueTitle = [UILabel new];
    [applyForValueView addSubview:tuikuanValueTitle];
    tuikuanValueTitle.font = [UIFont systemFontOfSize:14.];
    tuikuanValueTitle.textColor = [UIColor dingfanxiangqingColor];
    self.tuikuanValueTitle = tuikuanValueTitle;
//    tuikuanValueTitle.text = valueText;
    
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
    refundCauseView.backgroundColor = [UIColor whiteColor];
    
    UILabel *tuikuanyuanyinTitle = [UILabel new];
    [refundCauseView addSubview:tuikuanyuanyinTitle];
    tuikuanyuanyinTitle.font = [UIFont systemFontOfSize:14.];
    tuikuanyuanyinTitle.textColor = [UIColor buttonTitleColor];
    tuikuanyuanyinTitle.text = @"退款原因";
    
    UIButton *chooseRefundBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [refundCauseView addSubview:chooseRefundBtn];
    chooseRefundBtn.backgroundColor = [UIColor whiteColor];
    chooseRefundBtn.layer.cornerRadius = 4;
    chooseRefundBtn.layer.borderWidth = 0.5f;
    chooseRefundBtn.layer.borderColor = [UIColor lineGrayColor].CGColor;
    [chooseRefundBtn addTarget:self action:@selector(chooseRefundClick:) forControlEvents:UIControlEventTouchUpInside];
    // downArrow1@2x
    UILabel *refundCauseLabel = [UILabel new];
    [refundCauseView addSubview:refundCauseLabel];
    refundCauseLabel.font = [UIFont systemFontOfSize:14.];
    refundCauseLabel.textColor = [UIColor dingfanxiangqingColor];
    refundCauseLabel.text = @"请选择退款原因";
    self.refundCauseLabel = refundCauseLabel;
    UIImageView *downArrowImage = [UIImageView new];
    [chooseRefundBtn addSubview:downArrowImage];
    downArrowImage.image = [UIImage imageNamed:@"downArrow1"];
    
    UITextView *refundDescTextView = [[UITextView alloc] init];
    [refundCauseView addSubview:refundDescTextView];
    refundDescTextView.layer.cornerRadius = 4;
    refundDescTextView.layer.borderWidth = 0.5f;
    refundDescTextView.layer.borderColor = [UIColor lineGrayColor].CGColor;
    refundDescTextView.delegate = self;
    self.refundDescTextView = refundDescTextView;
    
    self.textViewPlaceholdLabel = [UILabel new];
    [refundCauseView addSubview:self.textViewPlaceholdLabel];
    self.textViewPlaceholdLabel.font = [UIFont systemFontOfSize:14.];
    self.textViewPlaceholdLabel.textColor = [UIColor dingfanxiangqingColor];
    self.textViewPlaceholdLabel.text = @"请输入退款说明";
    
    [tuikuanyuanyinTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(refundCauseView).offset(10);
    }];
    [chooseRefundBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(tuikuanyuanyinTitle);
        make.top.equalTo(tuikuanyuanyinTitle.mas_bottom).offset(5);
        make.width.mas_equalTo(@(SCREENWIDTH - 20));
        make.height.mas_equalTo(@35);
    }];
    [refundCauseLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(chooseRefundBtn).offset(8);
        make.centerY.equalTo(chooseRefundBtn.mas_centerY);
    }];
    [downArrowImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(chooseRefundBtn).offset(-8);
        make.centerY.equalTo(chooseRefundBtn.mas_centerY);
        make.width.height.mas_equalTo(@(16));
    }];
    [self.refundDescTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(tuikuanyuanyinTitle);
        make.top.equalTo(chooseRefundBtn.mas_bottom).offset(5);
        make.width.mas_equalTo(@(SCREENWIDTH - 20));
        make.height.mas_equalTo(@75);
    }];
    [self.textViewPlaceholdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(chooseRefundBtn.mas_bottom).offset(13);
        make.left.equalTo(tuikuanyuanyinTitle).offset(8);
    }];
    
    
    // ==============            ==================== //
    
    UIView *submitView = [UIView new];
    [baseScrollView addSubview:submitView];
    submitView.frame = CGRectMake(0, refundCauseView.mj_y + 161, SCREENWIDTH, 60);
    submitView.backgroundColor = [UIColor whiteColor];
    
    JMSelecterButton *submitButton = [JMSelecterButton buttonWithType:UIButtonTypeCustom];
    [submitView addSubview:submitButton];
    [submitButton setSureBackgroundColor:[UIColor buttonDisabledBackgroundColor] CornerRadius:20];
    [submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submitButton setTitle:@"提交申请" forState:UIControlStateNormal];
    self.submitButton = submitButton;
    [submitButton addTarget:self action:@selector(submitClick:) forControlEvents:UIControlEventTouchUpInside];
    [self disableTijiaoButton];
    
    [submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(submitView);
        make.width.mas_equalTo(@(SCREENWIDTH - 30));
        make.height.mas_equalTo(@40);
    }];
    
    baseScrollView.contentSize = CGSizeMake(SCREENWIDTH, submitView.mj_y + 60);
    
    number = [self.dingdanModel.num intValue];
    maxNumber = [self.dingdanModel.num intValue];
    if(number != 0){
        PriceLabel.text = [NSString stringWithFormat:@"¥%.2f",[self.dingdanModel.total_fee floatValue]/number];
    }
    titleLabel.text = self.dingdanModel.title;
    sizeLabel.text = self.dingdanModel.sku_name;
    goodsNumLabel.text = [NSString stringWithFormat:@"x%@", self.dingdanModel.num];
    tuikuanjineTitle.text = @"退款金额";
    NSString *valueText = [NSString stringWithFormat:@"¥%.02f", [self.dingdanModel.payment floatValue]];
    NSString *allValueText = [NSString stringWithFormat:@"可退金额%@",valueText];
    tuikuanValueTitle.attributedText = [JMRichTextTool cs_changeFontAndColorWithSubFont:[UIFont systemFontOfSize:16.] SubColor:[UIColor buttonEnabledBackgroundColor] AllString:allValueText SubStringArray:@[valueText]];
    numLabel.text = [NSString stringWithFormat:@"%i", maxNumber];
    refundPrice = [self.dingdanModel.payment floatValue];
    
    
    
    
    
    

}

- (void)reduceRefundNumClick {
    NSLog(@"减一件");
    if (number-- <= 1) {
        number++;
        return;
    }
    //   http://192.168.1.31:9000/rest/v1/refunds
    NSDictionary *parameters = @{@"id": self.dingdanModel.orderGoodsID,
                                 @"modify":@3,
                                 @"num": [NSNumber numberWithInt:number]
                                 };
    NSLog(@"params = %@", parameters);
    
    NSString *string = [NSString stringWithFormat:@"%@/rest/v1/refunds", Root_URL];
    
    NSLog(@"string = %@", string);
    [JMHTTPManager requestWithType:RequestTypePOST WithURLString:string WithParaments:parameters WithSuccess:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] == 0) {
            refundPrice = [responseObject[@"apply_fee"] floatValue];
            NSString *valueText = [NSString stringWithFormat:@"¥%.02f", [responseObject[@"apply_fee"] floatValue]];
            NSString *allValueText = [NSString stringWithFormat:@"可退金额%@",valueText];
            self.tuikuanValueTitle.attributedText = [JMRichTextTool cs_changeFontAndColorWithSubFont:[UIFont systemFontOfSize:16.] SubColor:[UIColor buttonEnabledBackgroundColor] AllString:allValueText SubStringArray:@[valueText]];
            self.numberLabel.text = [NSString stringWithFormat:@"%d", number];
        }else {
            [MBProgressHUD showWarning:responseObject[@"info"]];
        }
    } WithFail:^(NSError *error) {
    } Progress:^(float progress) {
    }];
}
- (void)addRefundNumClick {
    if (number++ > maxNumber - 1) {
        number--;
        return;
    }
    //   http://192.168.1.31:9000/rest/v1/refunds
    NSDictionary *parameters = @{@"id": self.dingdanModel.orderGoodsID,
                                 @"modify":@3,
                                 @"num": [NSNumber numberWithInt:number]
                                 };
    NSLog(@"params = %@", parameters);
    NSString *string = [NSString stringWithFormat:@"%@/rest/v1/refunds", Root_URL];
    NSLog(@"string = %@", string);
    [JMHTTPManager requestWithType:RequestTypePOST WithURLString:string WithParaments:parameters WithSuccess:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] == 0) {
            NSString *valueText = [NSString stringWithFormat:@"¥%.02f", [responseObject[@"apply_fee"] floatValue]];
            NSString *allValueText = [NSString stringWithFormat:@"可退金额%@",valueText];
            self.tuikuanValueTitle.attributedText = [JMRichTextTool cs_changeFontAndColorWithSubFont:[UIFont systemFontOfSize:16.] SubColor:[UIColor buttonEnabledBackgroundColor] AllString:allValueText SubStringArray:@[valueText]];
            self.numberLabel.text = [NSString stringWithFormat:@"%d", number];
        }else {
            [MBProgressHUD showWarning:responseObject[@"info"]];
        }
    } WithFail:^(NSError *error) {
    } Progress:^(float progress) {
    }];
}
- (void)submitClick:(UIButton *)button {
    [self.refundDescTextView resignFirstResponder];
    [MBProgressHUD showLoading:@"退款处理中....."];
    NSString *refundChannel = self.refundDic[@"refund_channel"];
    if ([refundChannel isEqualToString:@"budget"]) {
        [MobClick event:@"refundChannel_budget"];
    }else {
        [MobClick event:@"refundChannel_audit"];
    }
    NSString *urlString = [NSString stringWithFormat:@"%@/rest/v1/refunds", Root_URL];
    NSString *descStr = self.refundDescTextView.text;
    if ([NSString isStringEmpty:self.refundDescTextView.text]) {
        descStr = @"七天无理由退货";
    }
    NSDictionary *parameters = @{@"id":self.dingdanModel.orderGoodsID,
                                 @"reason":[NSNumber numberWithInt:reasonCode],
                                 @"num":self.numberLabel.text,
                                 @"sum_price":[NSNumber numberWithFloat:refundPrice],
                                 @"description":descStr,
                                 @"refund_channel":refundChannel
                                 };
    [JMHTTPManager requestWithType:RequestTypePOST WithURLString:urlString WithParaments:parameters WithSuccess:^(id responseObject) {
        NSDictionary *dic = responseObject;
        if (dic.count == 0) return;
        NSInteger code = [dic[@"code"] integerValue];
        if (code == 0) {
            [MBProgressHUD hideHUD];
            [MobClick event:@"refundChannel_audit_budget_success"];
            [self returnPopView];
        }else {
            [MBProgressHUD showError:dic[@"info"]];
            NSDictionary *temp_dict = @{@"code" : [NSString stringWithFormat:@"%ld",code]};
            [MobClick event:@"refundChannel_audit_budget_fail" attributes:temp_dict];
        }
    } WithFail:^(NSError *error) {
        [MBProgressHUD showError:@"退款失败,请稍后重试."];
    } Progress:^(float progress) {
        
    }];
    
    
    
}


- (void)selectReason:(UIButton *)button{
    NSLog(@"tag = %ld", (long)button.tag);
    self.refundCauseLabel.text = _dataArray[button.tag - 800];
    int num = (int)button.tag - 800+1;
    reasonCode = num %11;
    NSLog(@"reason Code = %d", reasonCode);
    [self hiddenReasonView];
    [self enableTijiaoButton];
}
- (void)cancelSeleted:(UIButton *)button{
    [self hiddenReasonView];
}
- (void)chooseRefundClick:(UIButton *)button {
    [self.refundDescTextView resignFirstResponder];
    [self showReasonView];
}
- (void)backClick {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)enableTijiaoButton{
    self.submitButton.enabled = YES;
    self.submitButton.backgroundColor = [UIColor buttonEnabledBackgroundColor];
}

- (void)disableTijiaoButton{
    self.submitButton.enabled = NO;
    self.submitButton.backgroundColor = [UIColor buttonDisabledBackgroundColor];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.refundDescTextView resignFirstResponder];
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.refundDescTextView resignFirstResponder];
}


#pragma mark --TextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView{
    // textView.text = @" ";
    self.textViewPlaceholdLabel.hidden = YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    if (textView.text.length==0) {
        self.textViewPlaceholdLabel.hidden = NO;
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
    //return YES;
    
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    return YES;
}

#pragma mark -- 弹出视图
- (void)returnPopView {
    self.maskView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.maskView.backgroundColor = [UIColor blackColor];
    self.maskView.alpha = 0.3;
    [self.maskView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideRefundpopView)]];
    JMRefundView *popView = [JMRefundView defaultPopView];
    self.popView = popView;
    self.popView.titleStr = @"1:极速退款,退款即时到账哦!请注意查收。\n 2:退款请求提交成功，客服会在24小时完成审核，您可以在退款界面查询进展，审核通过后请注意查看钱包余额，谢谢。";
    self.popView.delegate = self;
    [self.view addSubview:self.maskView];
    [self.view addSubview:self.popView];
    [JMPopViewAnimationSpring showView:self.popView overlayView:self.maskView];
}
- (void)composeRefundButton:(JMRefundView *)refundButton didClick:(NSInteger)index {
    if (index == 100) {
        [self hideRefundpopView];
    }else {
        [self hideRefundpopView];
    }
}
/**
 *  隐藏
 */
- (void)hideRefundpopView {
    [JMPopViewAnimationSpring dismissView:self.popView overlayView:self.maskView];
    [self.navigationController popViewControllerAnimated:YES];
}





@end


















































