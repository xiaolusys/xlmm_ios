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
#import "AFNetworking.h"


@interface TuihuoXiangqingViewController ()<UITextViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong)NSArray *dataArray;

@end

@implementation TuihuoXiangqingViewController{
    NSString *nibName;
    TuihuoModel *xiangqing;
    UITextField *textField1;
    UITextField *textField2;

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
            myView.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT);
            UIButton *button = (UIButton *)[myView viewWithTag:666];
            [button addTarget:self action:@selector(lianxikefu:) forControlEvents:UIControlEventTouchUpInside];
            
            
            [self.view addSubview:myView];
        }
            break;
        case 4:
        {
            NSArray *arrayViews = [[NSBundle mainBundle] loadNibNamed:nibName owner:nil options:nil];
            UIView *myView = [arrayViews objectAtIndex:0];
            myView.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT);

            UITextView *textView = (UITextView *)[myView viewWithTag:100];
            textView.delegate = self;
            textView.text = xiangqing.feedback;
            
            UIButton *button = (UIButton *)[myView viewWithTag:200];
            [button addTarget:self action:@selector(lianxikefu:) forControlEvents:UIControlEventTouchUpInside];
            
           textField1 = (UITextField *)[myView viewWithTag:300];
            
           textField2 = (UITextField *)[myView viewWithTag:400];
            
            textField1.borderStyle = UITextBorderStyleNone;
            textField1.delegate = self;
            textField2.borderStyle = UITextBorderStyleNone;
            textField2.delegate = self;
           NSString *itemID = xiangqing.item_id;
            NSLog(@"item_id = %@", itemID);
            //  http://192.168.1.63:8000/rest/v1/products/421
            NSString *urlstring = [NSString stringWithFormat:@"%@/rest/v1/products/%@", Root_URL, itemID];
            NSLog(@"url = %@", urlstring);
            
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlstring]];
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            NSLog(@"json = %@", json);
            NSString *wear_by = [json objectForKey:@"ware_by"];
            
            NSLog(@"wear_by = %@", wear_by);
            NSLog(@"hh");
            
           
            
            NSString *backAddress1 = @"上海市松江区佘山镇吉业路245号5号楼优尼世界";
            NSString *phone1 = @"021-50939326-818";
            NSString *youbian1 = @"201602";
            
            NSString *shouhuoren1 = @"售后(收)";
            NSString *shouhuoren2 = @"售后(收)";
            NSString *backAddress2 = @"广州市白云区太和镇永兴村龙归路口悦博大酒店对面龙门公寓3楼";
            NSString *phone2 = @"15821245603";
            NSString *youbian2 = @"510000";
            
            NSDictionary *dic1 = @{@"address":backAddress1,
                                   @"phone":phone1,
                                   @"youbian":youbian1,
                                   @"shouhuoren":shouhuoren1
                               
                                   };
            NSDictionary *dic2 = @{@"address":backAddress2,
                                   @"phone":phone2,
                                   @"youbian":youbian2,
                                  @"shouhuoren":shouhuoren2
                                   };
            NSArray *array = @[dic1, dic1, dic2];
            NSLog(@"array = %@", array);
            NSDictionary *infoDic ;
            if ([wear_by integerValue] == 0) {
                infoDic = [array objectAtIndex:0];
            }else if ([wear_by integerValue] == 1){
                infoDic = [array objectAtIndex:1];

            }else if ([wear_by integerValue] == 2){
                infoDic = [array objectAtIndex:2];

            }
            
            UILabel *label1 = (UILabel *)[myView viewWithTag:1000];
            UILabel *label2 = (UILabel *)[myView viewWithTag:2000];
            UILabel *label3 = (UILabel *)[myView viewWithTag:3000];
            UILabel *label4 = (UILabel *)[myView viewWithTag:4000];
            
            label1.text = [infoDic objectForKey:@"address"];
             label2.text = [infoDic objectForKey:@"phone"];
             label3.text = [infoDic objectForKey:@"shouhuoren"];
             label4.text = [infoDic objectForKey:@"youbian"];
            
            
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
            UIView *myView = [arrayViews objectAtIndex:0];
            UIButton *button = (UIButton *)[myView viewWithTag:888];
            [button addTarget:self action:@selector(lianxikefu:) forControlEvents:UIControlEventTouchUpInside];
            
            
            
            
            [self.view addSubview:myView];
            
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
    if ([textField1.text isEqualToString:@""] ||[textField2.text isEqualToString:@""]) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"快递公司和快递编号不能为空" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        return;
        
    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSString *urlString = [NSString stringWithFormat:@"%@/rest/v1/refunds", Root_URL];
    NSLog(@"urlstring = %@", urlString);
    
    NSString *refund_or_pro;
    if ([xiangqing.status isEqual:@"已付款"]) {
        refund_or_pro = @"0";
        
    } else if ([xiangqing.status isEqual:@"已发货"]){
        refund_or_pro = @"1";
    }else{
         refund_or_pro = @"1";
    }
    NSLog(@"1111");
    
    
    NSLog(@"%@",xiangqing.order_id );
     NSLog(@"%@", xiangqing.trade_id);
     NSLog(@"%@", refund_or_pro);
     NSLog(@"%@", xiangqing.refund_num);
     NSLog(@"%@", xiangqing.refund_fee);
     NSLog(@"%@", xiangqing.feedback);
     NSLog(@"%@", xiangqing.reason);
     NSLog(@"%@", @2);
     NSLog(@"%@", textField1.text);
     NSLog(@"%@", textField2.text);
   //  NSLog(@"%@", );
    NSDictionary *parameters = @{@"id":xiangqing.order_id,
                                 @"tid":xiangqing.trade_id,
                                 @"refund_or_pro":refund_or_pro,
                                 @"num":xiangqing.refund_num,
                                 @"sum_price":xiangqing.refund_fee,
                                 @"feedback":xiangqing.feedback,
                                 @"reason":xiangqing.reason,
                                 @"modify":@2,
                                 @"company":textField1.text,
                                 @"sid":textField2.text
                                 };
    
    NSLog(@"parameters = %@", parameters);
    
    [manager POST:urlString parameters:parameters
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              
              NSLog(@"JSON: %@", responseObject);
              NSLog(@"perration = %@", operation);
              [self.navigationController popViewControllerAnimated:YES];
              
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              
              NSLog(@"Error: %@", error);
              NSLog(@"erro = %@\n%@", error.userInfo, error.description);
              NSLog(@"perration = %@", operation);
              
              
          }];
    
    
    
    
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
        self.view.frame = CGRectMake(0, -216, SCREENWIDTH, SCREENHEIGHT);
        
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
