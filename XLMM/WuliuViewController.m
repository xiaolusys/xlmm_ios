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
    
    NSString *urlString = [NSString stringWithFormat:@"%@/rest/wuliu/?tid=%@", Root_URL, self.tradeId];
    NSURL *url = [NSURL URLWithString:urlString];
    NSLog(@"%@", urlString);
    
    NSData *responseData = [NSData dataWithContentsOfURL:url];
    
    NSDictionary *dicJson = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:nil];
    NSLog(@"json = %@", dicJson);
    NSInteger code = [[dicJson objectForKey:@"code"] integerValue];
    if (code == 0) {
        NSDictionary *responseContent = [dicJson objectForKey:@"response_content"];
        BOOL RESULT = [responseContent objectForKey:@"result"];
        if (RESULT == YES) {
            NSArray *infoArray = [responseContent objectForKey:@"ret"];
            NSInteger length = infoArray.count;
            
            if (length > 0) {
                NSDictionary *lastWuliuInfo = [infoArray lastObject];
                NSString *timeText = [lastWuliuInfo objectForKey:@"time"];
                timeText = [self spaceFormatTimeString:timeText];
            
                NSString *infoText = [lastWuliuInfo objectForKey:@"content"];
                [self displayLastWuliuInfoWithTime: timeText andInfo:infoText];
                
                // display wuliu company name and wuliu miandan id
                self.wuliuCompanyName.text = [lastWuliuInfo objectForKey:@"logistics_company"];
                self.wuliuMiandanId.text = [lastWuliuInfo objectForKey:@"out_sid"];
            }
            NSInteger MAX = 4; // we only display at most 3 wuliu info.
            if (length < MAX) {
                MAX = length;
            }
            for (int i=1; i<MAX; ++i) {
                NSDictionary *wuliuInfo =  infoArray[length-1-i];
                NSString *timeText = [wuliuInfo objectForKey:@"time"];
                timeText = [self spaceFormatTimeString:timeText];
                
                NSString *infoText = [wuliuInfo objectForKey:@"content"];
                [self displayWuliuInfoWithOrder:i andTime:timeText andInfo:infoText];
            }
        } else {
            // future work:
            // here we should do some process to have more friendly UI display
        }
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
