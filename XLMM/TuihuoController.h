//
//  TuihuoController.h
//  XLMM
//
//  Created by younishijie on 15/9/7.
//  Copyright (c) 2015年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PerDingdanModel;

@interface TuihuoController : UIViewController

@property (copy, nonatomic) NSString *dingdanID;
@property (copy, nonatomic) NSString *jiaoyiID;
@property (copy, nonatomic) NSString *refund_or_pro;

@property (copy, nonatomic) NSString *reason;
@property (copy, nonatomic) NSString *modify;
@property (copy, nonatomic) NSString *company;
@property (copy, nonatomic) NSString *sid;
//@property (copy, nonatomic) NSString *





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

@property (nonatomic, strong) PerDingdanModel *dingdanModel;

@property (weak, nonatomic) IBOutlet UITextView *myTextView;

@end
