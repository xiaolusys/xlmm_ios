//
//  PersonCenterViewController.m
//  XLMM
//
//  Created by younishijie on 15/8/3.
//  Copyright (c) 2015年 上海己美. All rights reserved.
//

#import "PersonCenterViewController.h"
#import "PersonCenterViewController1.h"
#import "PersonCenterViewController2.h"
#import "PersonCenterViewController3.h"
#import "PersonCenterViewController4.h"
#import "PersonCenterViewController5.h"
#import "PersonCenterViewController6.h"
#import "PersonCenterViewController7.h"
#import "PersonCenterViewController8.h"
#import "PersonCenterViewController9.h"
#import "PersonCenterViewController10.h"

#import "MMClass.h"

@interface PersonCenterViewController ()

@end

@implementation PersonCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人中心";
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



- (IBAction)button1:(id)sender {
    //PersonCenterViewController1 *PCVC1 = [[PersonCenterViewController1 alloc] init];
    PERSONCENTER(PersonCenterViewController1);
    NSLog(@"1");
}

- (IBAction)button2:(id)sender {
    PERSONCENTER(PersonCenterViewController2);
    NSLog(@"2");
}

- (IBAction)button3:(id)sender {
    PERSONCENTER(PersonCenterViewController3);
    NSLog(@"3");
}

- (IBAction)button4:(id)sender {
    PERSONCENTER(PersonCenterViewController4);
    NSLog(@"4");
}

- (IBAction)button5:(id)sender {
    PERSONCENTER(PersonCenterViewController5);
    NSLog(@"5");
}

- (IBAction)button6:(id)sender {
    PERSONCENTER(PersonCenterViewController6);
    NSLog(@"6");
}

- (IBAction)button7:(id)sender {
    PERSONCENTER(PersonCenterViewController7);
    NSLog(@"7");
}

- (IBAction)button8:(id)sender {
    PERSONCENTER(PersonCenterViewController8);
    NSLog(@"8");
}

- (IBAction)button9:(id)sender {
    PERSONCENTER(PersonCenterViewController9);
    NSLog(@"9");
}

- (IBAction)button10:(id)sender {
    PERSONCENTER(PersonCenterViewController10);
    NSLog(@"10");
}

- (IBAction)buttonExit:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
