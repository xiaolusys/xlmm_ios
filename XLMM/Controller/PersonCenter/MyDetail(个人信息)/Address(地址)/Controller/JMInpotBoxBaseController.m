//
//  JMInpotBoxBaseController.m
//  XLMM
//
//  Created by zhang on 17/2/20.
//  Copyright © 2017年 上海己美. All rights reserved.
//

#import "JMInpotBoxBaseController.h"
#import "UIView+RGSize.h"

@interface JMInpotBoxBaseController () {
    CGFloat _totalYOffset;
}


@end

@implementation JMInpotBoxBaseController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        _totalYOffset = 0;
    }
    
    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];

    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [JMNotificationCenter addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [JMNotificationCenter addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [JMNotificationCenter addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [JMNotificationCenter addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [JMNotificationCenter addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    [JMNotificationCenter addObserver:self selector:@selector(keyboardDidChangeFrame:) name:UIKeyboardDidChangeFrameNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [JMNotificationCenter removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [JMNotificationCenter removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [JMNotificationCenter removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    [JMNotificationCenter removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [JMNotificationCenter removeObserver:self name:UIKeyboardDidHideNotification object:nil];
    [JMNotificationCenter removeObserver:self name:UIKeyboardDidChangeFrameNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)noti
{
    CGFloat keyboardHeight = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;;
    [self.view.layer removeAllAnimations];
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    UIView *firstResponderView = [keyWindow performSelector:@selector(findFirstResponder)];
    
    CGRect rect = [[UIApplication sharedApplication].keyWindow convertRect:firstResponderView.frame fromView:firstResponderView.superview];
    
    CGFloat bottom = rect.origin.y + rect.size.height;
    CGFloat keyboardY = self.view.window.mj_size.height - keyboardHeight;
    if (bottom > keyboardY) {
        _totalYOffset += bottom - (self.view.window.mj_size.height - keyboardHeight);
        [UIView animateWithDuration:[noti.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue]
                              delay:0
                            options:[noti.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue]
                         animations:^{
                             self.view.mj_y -= _totalYOffset;
                         }
                         completion:nil];
    }
}

- (void)keyboardWillHide:(NSNotification *)noti
{
    [UIView animateWithDuration:[noti.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue]
                          delay:0
                        options:[noti.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue]
                     animations:^{
                         self.view.mj_y = 0.f; // += _totalYOffset;
                     }
                     completion:nil];
    _totalYOffset = 0;
}

- (void)keyboardWillChangeFrame:(NSNotification *)noti
{
    
}

- (void)keyboardDidShow:(NSNotification *)noti
{
}

- (void)keyboardDidHide:(NSNotification *)noti
{
}

- (void)keyboardDidChangeFrame:(NSNotification *)noti
{
}


- (void)dealloc
{
    [JMNotificationCenter removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end









