//
//  WuliuViewController.m
//  XLMM
//
//  Created by younishijie on 15/11/17.
//  Copyright © 2015年 上海己美. All rights reserved.
//

#import "WuliuViewController.h"
#import "UIViewController+NavigationBar.h"
#import "MMClass.h"
#import "UIColor+RGBColor.h"

@interface WuliuViewController ()

@end

@implementation WuliuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createNavigationBarWithTitle:@"物流信息" selecotr:@selector(goback)];
    
    [self getWuliuInfoFromServer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)goback{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) getWuliuInfoFromServer{
    //self.tradeId = @"xd15081955d45da07263e";
    
    NSString *urlString = [NSString stringWithFormat:@"%@/rest/v1/wuliu/get_wuliu_by_tid?tid=%@", Root_URL, self.tradeId];
    NSLog(@"%@", urlString);
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]];
        [self performSelectorOnMainThread:@selector(fetchedWuliuData:)withObject:data waitUntilDone:YES];
    });
    
    
  }

- (void)fetchedWuliuData:(NSData *)responseData{
    NSLog(@"%@",responseData);
    if (responseData == nil) {
        return;
    }
    
    
    NSDictionary *dicJson = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:nil];
    NSLog(@"json = %@", dicJson);
    
    
    self.wuliuCompanyName.text = [dicJson objectForKey:@"name"];
    self.wuliuMiandanId.text = [dicJson objectForKey:@"order"];
    
 
        NSArray *infoArray = [dicJson objectForKey:@"data"];
        NSInteger length = infoArray.count;
    if (length == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"您的订单暂无物流信息，请稍候查询" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    }
        
        if (length > 0) {
                NSDictionary *lastWuliuInfo = [infoArray firstObject];
                NSString *timeText = [lastWuliuInfo objectForKey:@"time"];
                timeText = [self spaceFormatTimeString:timeText];
                
                NSString *infoText = [lastWuliuInfo objectForKey:@"content"];
                [self displayLastWuliuInfoWithTime: timeText andInfo:infoText];
                
           
            
           
        }
        NSInteger MAX = 4; // we only display at most 3 wuliu info.
        if (length < MAX) {
            MAX = length;
        }
        for (int i=1; i<MAX; ++i) {
            NSDictionary *wuliuInfo =  infoArray[i];
            NSString *timeText = [wuliuInfo objectForKey:@"time"];
            timeText = [self spaceFormatTimeString:timeText];
            
            NSString *infoText = [wuliuInfo objectForKey:@"content"];
            [self displayWuliuInfoWithOrder:i andTime:timeText andInfo:infoText];
        }
   
    

}

-(NSString*) spaceFormatTimeString:(NSString*)timeString{
    NSMutableString *ms = [NSMutableString stringWithString:timeString];
    NSRange range = {10,1};
    [ms replaceCharactersInRange:range withString:@" "];
    return ms;
}

-(void)displayLastWuliuInfoWithTime:(NSString*)timeText andInfo:(NSString*)infoText{
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"WuliuInfoView" owner:nil options:nil];
    UIView *view = views[0];
    UIView *circleView = [view viewWithTag:100];
    UILabel *timeLabel = [view viewWithTag:200];
    UILabel *infoLabel = [view viewWithTag:300];
    
    timeLabel.text = timeText;
    infoLabel.text = infoText;
    UIColor *color = [UIColor orangeThemeColor];
    timeLabel.textColor = color;
    infoLabel.textColor = color;
    
    circleView.layer.cornerRadius = 4.5;
    circleView.backgroundColor = color;
    
    view.frame = CGRectMake(0, 17, SCREENWIDTH, 80);
    [self.wuliuInfoChainView addSubview:view];
}


-(void)displayWuliuInfoWithOrder:(NSInteger)order andTime:(NSString*)timeText andInfo:(NSString*)infoText{
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"WuliuInfoView" owner:nil options:nil];
    UIView *view = views[0];
    UIView *circleView = [view viewWithTag:100];
    UILabel *timeLabel = [view viewWithTag:200];
    UILabel *infoLabel = [view viewWithTag:300];
    
    timeLabel.text = timeText;
    infoLabel.text = infoText;
    
    UIColor *normalColor = [UIColor colorWithR:98 G:98 B:98 alpha:1];
    timeLabel.textColor = normalColor;
    infoLabel.textColor = normalColor;
    
    circleView.layer.cornerRadius = 4.5;
    circleView.backgroundColor = normalColor;
    
    NSInteger originY = 17 + order*72;
    
    view.frame = CGRectMake(0, originY, SCREENWIDTH, 80);
    [self.wuliuInfoChainView addSubview:view];
    
    
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
