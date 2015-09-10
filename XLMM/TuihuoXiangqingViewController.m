//
//  TuihuoXiangqingViewController.m
//  XLMM
//
//  Created by younishijie on 15/9/9.
//  Copyright (c) 2015年 上海己美. All rights reserved.
//

#import "TuihuoXiangqingViewController.h"
#import "MMClass.h"
#import "TuihuoModel.h"
#import "ModifyshenqingViewController.h"


@interface TuihuoXiangqingViewController ()<UITextViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong)NSArray *dataArray;

@end

@implementation TuihuoXiangqingViewController{
    NSString *nibName;
    TuihuoModel *xiangqing;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"退货(款)详情";
    self.view.backgroundColor = [UIColor whiteColor];
    
      [self downlaodData];
    
    
    [self createView];
  
}

- (void)downlaodData{
    
    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"url = %@", kRefunds_URL);
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:kRefunds_URL]];
        [self performSelectorOnMainThread:@selector(fetchedRefundData:) withObject:data waitUntilDone:YES];
        
        
    });
    
}

- (void)fetchedRefundData:(NSData *)data{
    if (data == nil) {
        return;
    }
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    NSLog(@"json = %@", json);
    NSArray *array = [json objectForKey:@"results"];
    if (array.count == 0) {
        return;
    }
    NSLog(@"array = %@", array);
    NSMutableArray *mutableArray = [[NSMutableArray alloc] initWithCapacity:0];
    for (NSDictionary *dic in array) {
        TuihuoModel *model = [TuihuoModel new];
        model.ID = [dic objectForKey:@"id"];
        model.url = [dic objectForKey:@"url"];
        model.refund_no = [dic objectForKey:@"refund_no"];
        model.trade_id = [dic objectForKey:@"trade_id"];
        model.order_id = [dic objectForKey:@"order_id"];
        model.buyer_id = [dic objectForKey:@"buyer_id"];
        model.item_id = [dic objectForKey:@"item_id"];
        model.title = [dic objectForKey:@"title"];
        model.sku_id = [dic objectForKey:@"sku_id"];
        model.sku_name = [dic objectForKey:@"sku_name"];
        model.refund_num = [dic objectForKey:@"refund_num"];
        model.buyer_nick = [dic objectForKey:@"buyer_nick"];
        model.mobile = [dic objectForKey:@"mobile"];
        model.phone = [dic objectForKey:@"phone"];
        model.total_fee = [dic objectForKey:@"total_fee"];
        model.payment = [dic objectForKey:@"payment"];
        model.created = [dic objectForKey:@"created"];
        model.company_name = [dic objectForKey:@"company_name"];
        model.sid = [dic objectForKey:@"sid"];
        model.reason = [dic objectForKey:@"reason"];
        model.desc = [dic objectForKey:@"desc"];
        model.feedback = [dic objectForKey:@"feedback"];
        model.has_good_return = [dic objectForKey:@"has_good_return"];
        model.has_good_change = [dic objectForKey:@"has_good_change"];
        model.good_status = [dic objectForKey:@"good_status"];
        model.status = [dic objectForKey:@"status"];
        model.refund_fee = [dic objectForKey:@"refund_fee"];
        
        
        
        
        [mutableArray addObject:model];
        NSLog(@"orderid === %@", model.order_id);
    }
    
    self.dataArray = [[NSArray alloc] initWithArray:mutableArray];
    NSLog(@"dataArray = %@", self.dataArray);
    
}

- (void)createView{
    NSLog(@"xiangqing = %ld",(long) self.status);
    nibName = [NSString stringWithFormat:@"TuihuoXQ%ld",(long) self.status];
    NSLog(@"oredrID = %ld", (long)self.orderID);
    
    for (TuihuoModel *model in self.dataArray) {
        NSLog(@"model.orderID = %@", model.order_id);
        if ([model.order_id integerValue] == self.orderID) {
            xiangqing = model;
            NSLog(@"匹配到对应的orderID");
            
            break;
        }
    }
    
    NSLog(@"nibName = %@", nibName);
    switch (self.status) {
        case 1:
        {
            NSArray *arrayViews = [[NSBundle mainBundle] loadNibNamed:nibName owner:nil options:nil];
            
            UIView *myview = [arrayViews objectAtIndex:0];
            
            UILabel *label1 = (UILabel *)[myview viewWithTag:11];
            label1.text = [NSString stringWithFormat:@"¥%@", xiangqing.refund_fee];
            //label1.text = @"111";
            UILabel *label2 = (UILabel *)[myview viewWithTag:22];
            NSMutableString *string =[[NSMutableString alloc] initWithString:xiangqing.created];
            NSRange range = [string rangeOfString:@"T"];
            [string replaceCharactersInRange:range withString:@" "];
            label2.text = string;
            
            
            
            //label2.text = @"111";
            UILabel *label3 = (UILabel *)[myview viewWithTag:33];
            label3.text = xiangqing.reason;
            
            UITextView *textView = (UITextView *)[myview viewWithTag:44];
            textView.text = xiangqing.desc;
            textView.delegate = self;
            
            [self.view addSubview:myview];
            
            
            
            
            
        }
            break;
        case 2:
        {
            NSArray *arrayViews = [[NSBundle mainBundle] loadNibNamed:nibName owner:nil options:nil];
            UIView *myView = [arrayViews objectAtIndex:0];
            UITextView *textView = (UITextView *)[myView viewWithTag:11];
            textView.delegate = self;
            textView.text = xiangqing.feedback;
            
            UIButton *button = (UIButton *)[myView viewWithTag:22];
            [button addTarget:self action:@selector(lianxikefu:) forControlEvents:UIControlEventTouchUpInside];
            
            UIButton *button2 = (UIButton *)[myView viewWithTag:33];
            [button2 addTarget:self action:@selector(xiugaishengqing:) forControlEvents:UIControlEventTouchUpInside];
            
            
            
            
            
            
            
            
            [self.view addSubview:myView];
        }
            break;
        case 3:
        {
            NSArray *arrayViews = [[NSBundle mainBundle] loadNibNamed:nibName owner:nil options:nil];
            
            UIView *myView = [arrayViews objectAtIndex:0];
            
            UIButton *button = (UIButton *)[myView viewWithTag:666];
            [button addTarget:self action:@selector(lianxikefu:) forControlEvents:UIControlEventTouchUpInside];
            
            
            [self.view addSubview:myView];
        }
            break;
        case 4:
        {
            NSArray *arrayViews = [[NSBundle mainBundle] loadNibNamed:nibName owner:nil options:nil];
            UIView *myView = [arrayViews objectAtIndex:0];
            
            UITextView *textView = (UITextView *)[myView viewWithTag:100];
            textView.delegate = self;
            textView.text = xiangqing.feedback;
            
            UIButton *button = (UIButton *)[myView viewWithTag:200];
            [button addTarget:self action:@selector(lianxikefu:) forControlEvents:UIControlEventTouchUpInside];
            
            UITextField *textField1 = (UITextField *)[myView viewWithTag:300];
            
            UITextField *textField2 = (UITextField *)[myView viewWithTag:400];
            
            textField1.borderStyle = UITextBorderStyleNone;
            textField1.delegate = self;
            textField2.borderStyle = UITextBorderStyleNone;
            textField2.delegate = self;
            
            UIButton *button2 = (UIButton *)[myView viewWithTag:500];
            [button2 addTarget:self action:@selector(commitBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            
            
            
            
            
            [self.view addSubview:myView];
        }
            break;
        case 5:
        {
            NSArray *arrayViews = [[NSBundle mainBundle] loadNibNamed:nibName owner:nil options:nil];
            [self.view addSubview:[arrayViews objectAtIndex:0]];
        }
            break;
        case 6:
        {
            NSArray *arrayViews = [[NSBundle mainBundle] loadNibNamed:nibName owner:nil options:nil];
            [self.view addSubview:[arrayViews objectAtIndex:0]];
        }
            break;
        case 7:
        {
            NSArray *arrayViews = [[NSBundle mainBundle] loadNibNamed:nibName owner:nil options:nil];
            UIView *myView = [arrayViews objectAtIndex:0];
            UILabel *label1 = (UILabel *)[myView viewWithTag:11];
            label1.text = [NSString stringWithFormat:@"¥%@", xiangqing.refund_fee];
           
            
            UILabel *label2 = (UILabel *)[myView viewWithTag:22];
            NSMutableString *string =[[NSMutableString alloc] initWithString:xiangqing.created];
            NSRange range = [string rangeOfString:@"T"];
            [string replaceCharactersInRange:range withString:@" "];
            label2.text = string;
            
            UILabel *label3 = (UILabel *)[myView viewWithTag:33];
            label3.text = xiangqing.reason;
            
            UILabel *label4 = (UILabel *)[myView viewWithTag:44];
            label4.text = xiangqing.title;
            
            UITextView *textView = (UITextView *)[myView viewWithTag:55];
            textView.text = xiangqing.desc;
            textView.delegate = self;
            
            UILabel *label6 = (UILabel *)[myView viewWithTag:66];
            
            label6.text = xiangqing.refund_no;
            
            UILabel *label7 = (UILabel *)[myView viewWithTag:77];
            
            label7.text = xiangqing.company_name;
            
            UILabel *label8 = (UILabel *)[myView viewWithTag:88];
            
            label8.text = xiangqing.sid;
            
            [self.view addSubview:myView];
        }
            break;
            
            
        default:
            break;
    }
}

- (void)lianxikefu:(UIButton *)button{
    NSLog(@"联系客服 ");
}

- (void)commitBtnClicked:(UIButton *)button{
    NSLog(@"提交申请");
    
}

- (void)xiugaishengqing:(UIButton *)button{
    NSLog(@"修改申请");
    ModifyshenqingViewController *modifyVC = [[ModifyshenqingViewController alloc] initWithNibName:@"ModifyshenqingViewController" bundle:nil];
    modifyVC.oid = xiangqing.order_id;
    modifyVC.tid = xiangqing.trade_id;
    
    
        [self.navigationController pushViewController:modifyVC animated:YES];
}


- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [UIView animateWithDuration:0.3 animations:^{
        self.view.frame = CGRectMake(0, -150, SCREENWIDTH, SCREENHEIGHT);
        
    }];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    [UIView animateWithDuration:0.3 animations:^{
        self.view.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT);
        
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    return NO;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
