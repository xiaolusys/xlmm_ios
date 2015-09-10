//
//  ModifyshenqingViewController.h
//  XLMM
//
//  Created by younishijie on 15/9/10.
//  Copyright (c) 2015年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ModifyshenqingViewController : UIViewController

@property (nonatomic, copy)NSString *oid;
@property (nonatomic, copy)NSString *tid;


@property (weak, nonatomic) IBOutlet UIImageView *myImageView;
@property (weak, nonatomic) IBOutlet UILabel *dingdanjine;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *sizename;
@property (weak, nonatomic) IBOutlet UILabel *danjia;
@property (weak, nonatomic) IBOutlet UILabel *number;

@property (weak, nonatomic) IBOutlet UIButton *jianbutton;

@property (weak, nonatomic) IBOutlet UIButton *jiabutton;

- (IBAction)jianclicked:(id)sender;

- (IBAction)jiaClicked:(id)sender;



@property (weak, nonatomic) IBOutlet UITextField *myTextField1;
@property (weak, nonatomic) IBOutlet UITextField *myTextField2;

- (IBAction)commit:(id)sender;


@property (weak, nonatomic) IBOutlet UITextView *myTextView;


@end
