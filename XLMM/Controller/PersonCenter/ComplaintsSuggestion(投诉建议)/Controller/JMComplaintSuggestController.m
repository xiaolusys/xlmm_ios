//
//  JMComplaintSuggestController.m
//  XLMM
//
//  Created by zhang on 16/6/21.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMComplaintSuggestController.h"
#import "JMTextView.h"
#import "UIViewController+NavigationBar.h"
#import "JMCompSugView.h"
#import "UIColor+RGBColor.h"
#import "JMSelecterButton.h"
#import "Masonry.h"
#import "MMClass.h"
#import "AFNetworking.h"
#import "WebViewController.h"


@interface JMComplaintSuggestController ()<UITextViewDelegate,JMCompSugViewDelegate>

@property (nonatomic,strong) JMTextView *textView;

@property (nonatomic,strong) UIBarButtonItem *rightItem;

@property (nonatomic,strong) UIButton *selectedBtn;

@property (nonatomic,strong) JMSelecterButton *commitButton;

@property (nonatomic,strong) JMCompSugView *compSugV;

@property (nonatomic,strong) UIView *keyView;

@property (nonatomic,strong) UITapGestureRecognizer *tap;

@end

@implementation JMComplaintSuggestController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavigationBarWithTitle:@"投诉建议" selecotr:@selector(backClick:)];
    self.view.backgroundColor = [UIColor lineGrayColor];
    
    self.keyView = [[UIView alloc] initWithFrame:self.view.frame];
    self.keyView.backgroundColor = [UIColor clearColor];
    [self.keyView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKyeborad)]];
    
    [self createRightButonItem];
    [self createComSug];
    [self setUpTextView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doneButtonShow:) name:UIKeyboardDidShowNotification object:nil]
    ;
}

- (void)setUpTextView {
    JMTextView *textView = [[JMTextView alloc] initWithFrame:CGRectMake(0, 124, SCREENWIDTH, 200)];
    [self.view addSubview:textView];
    self.textView = textView;
    self.textView.placeHolder = @"请描述您的具体问题,我们将尽快为你解决!";
    self.textView.delegate = self;
}

#pragma mark ---- 导航栏右侧体现历史
- (void) createRightButonItem{
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 40)];
    [rightBtn addTarget:self action:@selector(rightClicked:) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setTitle:@"投诉历史" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:15.];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)rightClicked:(UIButton *)button{

    CommonWebViewViewController *common = [[CommonWebViewViewController alloc] initWithUrl:HISTORYCOMMONPROBLEM_URL title:@"投诉历史"];
    [self.navigationController pushViewController:common animated:YES];

}

#pragma mark -- 创建按钮工具条 提交按钮
- (void)createComSug {
    JMCompSugView *compSugV = [[JMCompSugView alloc] initWithFrame:CGRectMake(0, 64, SCREENWIDTH, 40)];
    compSugV.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:compSugV];
    compSugV.delegate = self;
    
    JMSelecterButton *commitButton = [JMSelecterButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:commitButton];
    [commitButton setSureBackgroundColor:[UIColor buttonDisabledBackgroundColor] CornerRadius:20];
    self.commitButton = commitButton;
    self.commitButton.enabled = NO;
    [self.commitButton setTitle:@"提交" forState:UIControlStateNormal];
    self.commitButton.frame = CGRectMake(40, 354, SCREENWIDTH - 80, 40);
    [self.commitButton addTarget:self action:@selector(commitClick:) forControlEvents:UIControlEventTouchUpInside];
    
}
- (void)composeShareBtn:(JMCompSugView *)shareBtn Button:(UIButton *)button didClickBtn:(NSInteger)index {
    for (int i = 1 ; i < 5; i++) {
        UIButton *btni = (UIButton *)[self.view viewWithTag:i];
        UIButton *btnTag = (UIButton *)[self.view viewWithTag:index];
        if (i == index) {
            btnTag.selected = YES;
        }else {
            btni.selected = NO;
        }
    }
}

#pragma mark -- 提交按钮点击
- (void)commitClick:(UIButton *)sender {
    NSString *text = self.textView.text;
    NSUInteger length = text.length;
    if (length <= 0) {
        return ;
    }
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/rest/v1/complain",Root_URL];
    NSDictionary *dic = @{@"com_content":self.textView.text};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:urlStr parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject == nil)return;
            [self successCommit];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}
#pragma mark -- textViewDelegate 协议方法
- (void)textViewDidBeginEditing:(UITextView *)textView {
    self.textView.hidePlaceHolder = YES;
}
- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length > 0 && self.commitButton.enabled == NO) {
        [self enableTijiaoButton];
    }
    if (textView.text.length <= 0 && self.commitButton.enabled == YES) {
        [self disableTijiaoButton];
    }
}
- (void)textViewDidEndEditing:(UITextView *)textView {
    if (textView.text.length <= 0) {
        self.textView.hidePlaceHolder = NO;
    }
}

#pragma mark -- 提交成功
- (void)successCommit{
    NSLog(@"提交投诉意见");
    UIAlertView *laterView = [[UIAlertView alloc] initWithTitle:nil message:@"提交成功!\n谢谢您的反馈，我们将不断完善，给您最好的服务!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [laterView show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
#pragma -- 监听键盘弹出
- (void)doneButtonShow:(NSNotification *)notification {
    [self.view addSubview:self.keyView];
}
- (void)hideKyeborad {
    [self.keyView removeFromSuperview];
    [self.textView resignFirstResponder];
}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    [textView resignFirstResponder];
    return YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //    [_textView becomeFirstResponder];
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
- (void)backClick:(UIButton *)btn {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.textView resignFirstResponder];
}
- (void)enableTijiaoButton{
    self.commitButton.enabled = YES;
    self.commitButton.backgroundColor = [UIColor buttonEnabledBackgroundColor];
//    self.commitButton.layer.borderColor = [UIColor buttonBorderColor].CGColor;
}

- (void)disableTijiaoButton{
    self.commitButton.enabled = NO;
    self.commitButton.backgroundColor = [UIColor buttonDisabledBackgroundColor];
//    self.commitButton.layer.borderColor = [UIColor buttonDisabledBorderColor].CGColor;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
}
@end

/**
 [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChange) name:UITextViewTextDidChangeNotification object:nil];

 *  - (void)textChange {
 //判断textView有没有内容
 if (self.textView.text.length) {
 self.textView.hidePlaceHolder = YES;
 //历史显示按钮是否选择展示或不展示
 
 }else {
 self.textView.hidePlaceHolder = NO;
 }
 
 }
 
 按钮工具条点击判断
 if (button.selected == NO) {
 button.selected = YES;
 self.selectedBtn = button;
 }else {
 button.selected = NO;
 self.selectedBtn = button;
 }
 */






































