
//  MaMaPersonCenterViewController.m
//  XLMM
//
//  Created by younishijie on 16/1/11.
//  Copyright © 2016年 上海己美. All rights reserved.

#import "MaMaPersonCenterViewController.h"
#import "FSLineChart.h"
#import "MMClass.h"
#import "UIColor+FSPalette.h"
#import "MaMaOrderTableViewCell.h"
#import "MaMaOrderModel.h"
#import "PublishNewPdtViewController.h"
#import "AFNetworking.h"
#import "TixianViewController.h"
#import "MaMaOrderListViewController.h"
#import "MaMaCarryLogViewController.h"
#import "TuijianErweimaViewController.h"
#import "ActivityViewController2.h"
#import "MaMaShareSubsidiesViewController.h"
#import "ProductSelectionListViewController.h"
#import "FensiListViewController.h"
#import "MaMaShareSubsidiesViewController.h"
#import "UIViewController+NavigationBar.h"
#import "SVProgressHUD.h"
#import "MaMaHuoyueduViewController.h"
#import "MaClassifyCarryLogViewController.h"
#import "NSArray+Reverse.h"
#import "ShopPreviousViewController.h"
#import "TodayVisitorViewController.h"

#import "DotLineView.h"
#import "SelectedActivitiesViewController.h"
#import "WebViewController.h"
#import "MyInvitationViewController.h"
#import "JMMaMaCenterFansController.h"
#import "JMMaMaCenterTopView.h"
#import "JMWithdrawShortController.h"




@interface MaMaPersonCenterViewController ()<JMMaMaCenterTopViewDelegate,UITableViewDataSource, UITabBarDelegate, UITableViewDelegate, UIScrollViewDelegate>{
    NSMutableArray *dataArray;
    CGFloat widthOfChart;
    float ticheng;
    NSInteger dingdanshu;
//    UIView *circleView;
//    UIView *lineView;
    
    NSString *nickName;
    float ableTixianJine;
    int quxiaodays;

    float mamahuoyueduValue;
    UIView *orongeCircleView;
    
    NSMutableArray *allDingdan;
    
    CGPoint scrollViewContentOffset;
    
    NSString *share_mmcode;
    
//    NSMutableDictionary *_diction;
    
//    NSNumber *_money;
//    NSNumber *_clickTotalMoney;
}
/**
 *  字典中存储在webView中使用的值
 */
@property (nonatomic,strong) NSMutableDictionary *diction;

@property (nonatomic, strong)FSLineChart *lineChart;

@property (nonatomic, copy) NSString *huoyueduString;


@property (nonatomic, strong) NSMutableArray *anotherLabelArray;

@property (nonatomic, strong) UIView *anotherOrongeView;


@property (nonatomic, strong)NSMutableArray *dataArr;
@property (nonatomic, strong) NSMutableArray *lastweeknames;

@property (nonatomic, strong)NSString *earningsRecord;
@property (nonatomic, strong)NSString *orderRecord;

@property (nonatomic, copy) NSArray *mamaOrderArray;
@property (nonatomic, strong) NSMutableArray *labelArray;


//分享点击补贴
@property (weak, nonatomic) IBOutlet UILabel *clickNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *clickMoney;

@property (weak, nonatomic) IBOutlet UILabel *updateClickMoenyLabel;

@property (nonatomic, strong)NSNumber *money;
@property (nonatomic, strong)NSNumber *clickTotalMoney;

@property (copy, nonatomic) NSString *mamalink;
@property (nonatomic, strong) UIImageView *mamaHuoyueduImageView;

@property (nonatomic, strong)NSNumber *activeValueNum;

@property (nonatomic, strong)NSNumber *fansNum;

@property (nonatomic, strong)NSNumber *visitorDate;
@property (nonatomic, strong)NSNumber *carryValue;

@property (nonatomic, strong) NSNumber *weekDay;

@property (nonatomic, strong)NSString *eventLink;

@property (nonatomic, strong)NSString *myInvitation;
/**
 *  妈妈中心顶部视图
 */
@property (nonatomic, strong) JMMaMaCenterTopView *mamatopView;

@end

@implementation MaMaPersonCenterViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
}
- (NSMutableDictionary *)diction {
    if (!_diction) {
        _diction = [NSMutableDictionary dictionary];
    }
    return _diction;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.visitorDate = [NSNumber numberWithInt:0];
    // Do any additional setup after loading the view from its nib.
    dataArray = [[NSMutableArray alloc] initWithCapacity:30];
    self.dataArr = [[NSMutableArray alloc] init];
    allDingdan = [[NSMutableArray alloc] init];
    self.labelArray = [[NSMutableArray alloc] init];
    self.lastweeknames = [[NSMutableArray alloc] init];
    self.anotherLabelArray = [[NSMutableArray alloc] init];
    
    widthOfChart = 50;
    self.headViewWidth.constant = SCREENWIDTH;
    
    self.earningsRecord = @"0.00";
    self.orderRecord = @"0";
    self.carryValue = [NSNumber numberWithInt:0];
    
    [self.mamaTableView registerNib:[UINib nibWithNibName:@"MaMaOrderTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"MaMaOrder"];
    
    self.mamaTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.rootScrollView];
//    NSString *string = [NSString stringWithFormat:@"%@/rest/v1/pmt/xlmm", Root_URL];
    
    //点击分享补贴
    UITapGestureRecognizer *tapShare = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickShareView)];
    [self.shareSubsidies addGestureRecognizer:tapShare];
    
//    [self downloadData];
   // [self downloadDataWithUrlString:string selector:@selector(fetchedMaMaData:)];
    [self downloadDataWithUrlString:[NSString stringWithFormat:@"%@/rest/v1/pmt/xlmm/agency_info", Root_URL] selector:@selector(fetchedInfoData:)];
//    [self downloadDataWithUrlString:[NSString stringWithFormat:@"%@/rest/v1/pmt/shopping", Root_URL] selector:@selector(fetchedDingdanjilu:)];
    
    //主页新的数据
    NSString *str = [NSString stringWithFormat:@"%@/rest/v2/mama/fortune", Root_URL];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:str parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self updateMaMaHome:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
    
    
    [self createWeekDay];
    
    
    [self prepareData];
    [self createChart:dataArray];

    // 创建顶部视图
    [self createMMCenterTopViwe];
    
}
#pragma mark --- 顶部视图创建
- (void)createMMCenterTopViwe {
    JMMaMaCenterTopView *mamatopView = [[JMMaMaCenterTopView alloc] init];
    [self.mmCenterTopView addSubview:mamatopView];
    mamatopView.frame = CGRectMake(0, -20, SCREENWIDTH, 240);
    self.mamatopView = mamatopView;
    self.mamatopView.delegate = self;
}
- (void)composeBackPageup:(JMMaMaCenterTopView *)backPageup Index:(NSInteger)index {
    // 100 -> 返回按钮    111 -> 账户余额(提现界面)   112 -> 累计收益   113 -> 活跃度
    if (index == 100) {
        [self.navigationController popViewControllerAnimated:YES];
    }else if (index == 111) {
        
        if ([self.carryValue floatValue] > 100) {
            TixianViewController *vc = [[TixianViewController alloc] init];
            vc.carryNum = self.carryValue;
            vc.activeValue = [self.activeValueNum integerValue];
            [self.navigationController pushViewController:vc animated:YES];
        }else {
            JMWithdrawShortController *shortVC = [[JMWithdrawShortController alloc] init];
            shortVC.myBalance = [self.carryValue floatValue];
            [self.navigationController pushViewController:shortVC animated:YES];
        }
        
        
    }else if (index == 113) {
        MaMaHuoyueduViewController *VC = [[MaMaHuoyueduViewController alloc] init];
        VC.activeValueNum = self.activeValueNum;
        [self.navigationController pushViewController:VC animated:YES];
    }
}


- (void)createWeekDay{
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *now;
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags =NSYearCalendarUnit | NSMonthCalendarUnit |NSDayCalendarUnit | NSWeekdayCalendarUnit |
    NSHourCalendarUnit |NSMinuteCalendarUnit | NSSecondCalendarUnit;
    now=[NSDate date];
    comps = [calendar components:unitFlags fromDate:now];
    NSLog(@"comps = %@", comps);
    self.weekDay = [NSNumber numberWithInteger:[comps weekday]];
    
    NSLog(@"今天是周%@", self.weekDay);
    
}

//新接口数据
- (void)updateMaMaHome:(NSDictionary *)dic {
    NSDictionary *fortune = [dic objectForKey:@"mama_fortune"];
    if (fortune == nil) {
        return;
    }
    if ([fortune class] == [NSNull class]) {
        self.huoyuedulabel.text = @"0";
        self.huoyueduString = nil;
        
        
        [self createHuoYueDuView];

        return;
    }
    if ([fortune[@"active_value_num"] class] == [NSNull class] || [fortune[@"active_value_num"] integerValue]==0) {
        self.activeValueNum = [NSNumber numberWithInteger:0];
    }else {
        self.activeValueNum = fortune[@"active_value_num"];
    }
    
    nickName = [fortune objectForKey:@"mama_name"];
    
    //账户金额
    self.jineLabel.text = [NSString stringWithFormat:@"%.2f", [[fortune objectForKey:@"cash_value"] floatValue]];
    self.carryValue = [fortune objectForKey:@"cash_value"];
    
    self.huoyuedulabel.text = [NSString stringWithFormat:@"%@", [fortune objectForKey:@"active_value_num"]];
  
    self.huoyueduString = [[fortune objectForKey:@"active_value_num"] stringValue];
    mamahuoyueduValue = [[fortune objectForKey:@"active_value_num"] floatValue];
    [self createHuoYueDuView];

    if ([[fortune objectForKey:@"fans_num"] class] == [NSNull class] || [[fortune objectForKey:@"fans_num"] integerValue]==0) {
        self.fansNum = [NSNumber numberWithInteger:0];
    }else {
        self.fansNum = [fortune objectForKey:@"fans_num"];
    }
    //邀请数，粉丝，订单，收益
    self.inviteLabel.text = [NSString stringWithFormat:@"%@位", [fortune objectForKey:@"invite_num"]];
    self.fensilabel.text = [NSString stringWithFormat:@"%@人", [fortune objectForKey:@"fans_num"]];
    self.order.text = [NSString stringWithFormat:@"%@个", [fortune objectForKey:@"order_num"]];
    self.account.text = [NSString stringWithFormat:@"%.2f元", [[fortune objectForKey:@"carry_value"] floatValue]];
    self.earningsRecord = [NSString stringWithFormat:@"%.2f", [[fortune objectForKey:@"carry_value"] floatValue]];
    self.orderRecord = [NSString stringWithFormat:@"%@", [fortune objectForKey:@"order_num"]];
    
    //精选活动链接
    self.eventLink = [fortune objectForKey:@"mama_event_link"];
    
    //我的邀请链接
//    self.myInvitation = [fortune objectForKey:@"share_code"];
}

- (void)createHuoYueDuView{
  self.huoyueduView.transform = CGAffineTransformMakeRotation(M_PI * 24/180);
    
    
    NSInteger huoyuezhi = arc4random()%(NSInteger)(SCREENWIDTH);

    huoyuezhi = SCREENWIDTH /2;
    NSLog(@"huoyuezhi = %ld", huoyuezhi);
    self.huoyueduRight.constant = SCREENWIDTH - 36;
    
    
    if (self.huoyueduString == nil) {
       return;
    }
    
    if ([self.huoyueduString integerValue] == 0) {
        return;
    }
    
    NSLog(@"huoyuedu = %f", mamahuoyueduValue);
    
    CGRect frame = self.mamaHuoyueduView.frame;
  //  mamahuoyueduValue = 200.0;
    
    huoyuezhi = mamahuoyueduValue/100 * SCREENWIDTH;
    if (mamahuoyueduValue >= 100) {
        huoyuezhi = SCREENWIDTH;
        
    }
    frame.origin.x -= huoyuezhi;
    self.mamaHuoyueduView.frame = frame;
    
    frame.origin.x += huoyuezhi;
    
    NSLog(@"huoyuezhi = %ld", huoyuezhi);
    if (huoyuezhi < 36) {
        huoyuezhi = 36;
    }
    [UIView animateWithDuration:1.0 animations:^{
         self.huoyueduRight.constant = SCREENWIDTH - huoyuezhi;

        self.mamaHuoyueduView.frame = frame;
        
    
    } completion:^(BOOL finished) {

    }];
    
}


- (void)downloadData{
    NSString *string = [NSString stringWithFormat:@"%@/rest/v1/pmt/fanlist", Root_URL];
    NSLog(@"string = %@", string);
    [self downLoadWithURLString:string andSelector:@selector(fetchedData:)];
    
}

- (void)fetchedData:(NSData *)data{
    if (data == nil) {
        return;
    }
//    NSError *error = nil;
//    NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
//    if (error == nil) {
//        self.fensilabel.text = [NSString stringWithFormat:@"%ld", array.count];
//
//        if (array.count == 0) {
//            NSLog(@"您的粉丝列表为空");
//        } else {
//                       //生成粉丝列表。。。
//           // [self createFanlistWithArray:array];
//        }
//    } else {
//        NSLog(@"error = %@", error);
//    }
    
}

// 返回一周的订单数。。。。
- (float)sumofoneWeek:(NSArray *)weekArray{
    float sum = 0.0;
    for (int i = 0; i < weekArray.count; i++) {
        sum += [weekArray[i] floatValue];
    }
    return sum;
    
}

#pragma mark --获取历史积累收益

- (void)fetchedInfoData:(NSData *)data{
    if (data == nil) {
        return;
    }
    NSError *error = nil;
    NSDictionary *dicJson = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (!error) {
     //   NSString *mco = [[dicJson objectForKey:@"mmclog"] objectForKey:@"mci"];
        share_mmcode = [dicJson objectForKey:@"share_mmcode"];
        self.mamalink = [dicJson objectForKey:@"mama_link"];
        
        self.myInvitation = [dicJson objectForKey:@"share_mmcode"];
       }
}


#pragma mark --获取小鹿妈妈信息：等级，账户余额， 可提现金额， 名称等。。。

- (void)fetchedMaMaData:(NSData *)data{
    if (data == nil) {
        return;
    }
    NSError *error = nil;
    NSArray *arrJson = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (!error) {
    //    NSLog(@"dicJson = %@", arrJson);
        if (arrJson.count == 0) {
            return;
        }
        NSDictionary *dic = [arrJson objectAtIndex:0];
//        self.levelLabel.text = [NSString stringWithFormat:@"%d", (int)[[dic objectForKey:@"agencylevel"] integerValue]];
//      //  NSLog(@"%@",[NSString stringWithFormat:@"%d", (int)[[dic objectForKey:@"agencylevel"] integerValue]]);
//        self.jineLabel.text = [NSString stringWithFormat:@"%.2f",[[dic objectForKey:@"get_cash_display"] floatValue]];
        ableTixianJine = [[dic objectForKey:@"coulde_cashout"] floatValue];
        nickName = [dic objectForKey:@"weikefu"];
    }
    
}

#pragma mark --ScrollViewDelegate 

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
  //  NSLog(@"%f", scrollView.contentOffset.x/SCREENWIDTH);
    NSInteger page = scrollView.contentOffset.x/SCREENWIDTH;
    
    
    scrollViewContentOffset = scrollView.contentOffset;
    NSInteger count = allDingdan.count;
   // NSLog(@"count = %ld", count);
    
    NSInteger days = (count - page - 1)*7;
    self.visitorDate = [NSNumber numberWithInteger:days];
  
    NSLog(@"days = %ld", (long)days);
    
     NSDictionary *dic = self.mamaOrderArray[days];
   // NSLog(@"dic = %@", dic);
    self.dingdanLabel.text = [[dic objectForKey:@"order_num"] stringValue];
    self.shouyiLabel.text = [NSString stringWithFormat:@"%.2f", [dic[@"carry"] floatValue]];
    self.todayNum.text = [dic[@"visitor_num"] stringValue];
    
    //改变竖线的位置。。。。
    [self createChart:allDingdan];
    
}


- (void)downloadDataWithUrlString:(NSString *)urlString selector:(SEL)aSelector{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]];
        [self performSelectorOnMainThread:aSelector withObject:data waitUntilDone:YES];
    });
}





 //根据订单数据 画表格。。。。
- (void)createChart:(NSMutableArray *)chartData {
    
    NSInteger count = [chartData count];
    self.mamaScrollView.contentSize = CGSizeMake(SCREENWIDTH * count, 120);
    self.mamaScrollView.bounces = NO;
    self.mamaScrollView.showsHorizontalScrollIndicator = NO;
    self.mamaScrollView.delegate = self;
    self.mamaScrollView.contentOffset = scrollViewContentOffset;
    self.mamaScrollView.pagingEnabled = YES;
    
    NSArray *array = self.mamaScrollView.subviews;
    for (UIView *view in array) {
        [view removeFromSuperview];
    }
    if (allDingdan.count == 0) {
        self.mamaScrollView.scrollEnabled = NO;
        return;
    } else {
        self.mamaScrollView.scrollEnabled = YES;
        
    }
    
    
    for (int i = 0; i < allDingdan.count; i++) {
        UIView *shartView = [[UIView alloc] initWithFrame:CGRectMake(SCREENWIDTH * i + 20, 30, SCREENWIDTH - 40, 150)];
        shartView.tag = 1001 + i;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClicked:)];
        [shartView addGestureRecognizer:tap];
        
        NSMutableArray *mutabledingdan = [allDingdan[i] mutableCopy];
        
        
//        float sum = [self sumofoneWeek:allDingdan[i]];
//        if (sum == 0) {
//            UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(SCREENWIDTH * 0.5 - 40 + SCREENWIDTH, SCREENHEIGHT * 0.5 - 40 + SCREENHEIGHT, 80, 80)];
//            imageV.backgroundColor = [UIColor redColor];
//            imageV.image = [UIImage imageNamed:@"defaultPig"];
//            
//            [self.mamaScrollView bringSubviewToFront:imageV];
//            continue;
//        }
        
        
       // NSLog(@"每周订单数%@", mutabledingdan);
        
        FSLineChart *linechart = [self chart2:mutabledingdan];
        [shartView addSubview:linechart];
        
        UIView * circleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 6, 6)];
        circleView.backgroundColor = [UIColor orangeThemeColor];
        circleView.layer.cornerRadius = 3;
        circleView.tag = 300;
        [shartView addSubview:circleView];
        UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 2, 80)];
        lineView.backgroundColor = [UIColor orangeThemeColor];
        lineView.tag = 400;
        [shartView addSubview:lineView];
        
        if (i == 0) {
            CGPoint point = [linechart getPointForIndex:6];
            circleView.frame = CGRectMake(point.x - 3, point.y - 3, 6, 6);
            lineView.frame = CGRectMake(point.x - 1, point.y, 2, 115- point.y);
            
        } else {
            CGPoint point = [linechart getPointForIndex:(6 - quxiaodays)];
            circleView.frame = CGRectMake(point.x - 3, point.y - 3, 6, 6);
            lineView.frame = CGRectMake(point.x - 1, point.y, 2, 115- point.y);
            if (6 - quxiaodays + 1 < 7) {
                point = [linechart getPointForIndex:(6 - quxiaodays + 1)];
                NSLog(@"%@", NSStringFromCGPoint(point));
                
                UIView *whiteLine = [[UIView alloc] initWithFrame:CGRectMake(point.x, point.y - 1, SCREENWIDTH - point.x, 2)];
                whiteLine.backgroundColor = [UIColor whiteColor];
                [shartView addSubview:whiteLine];
                
                
            }
        }
      
        
        [self.mamaScrollView addSubview:shartView];
        
        
        
        
        
        orongeCircleView = [[UIView alloc] init];
        orongeCircleView.layer.cornerRadius = 10;
        orongeCircleView.backgroundColor = [UIColor orangeThemeColor];
        //   orongeCircleView.alpha = 0.3;
        
        [self.mamaScrollView addSubview:orongeCircleView];
        
        self.anotherOrongeView = [[UIView alloc] init];
        self.anotherOrongeView.layer.cornerRadius = 10;
        self.anotherOrongeView.backgroundColor = [UIColor orangeThemeColor];
        //   orongeCircleView.alpha = 0.3;
        
        [self.mamaScrollView addSubview:self.anotherOrongeView];
        
        
        
        for (int j = 0; j < 7; j++) {
            CGPoint point2 = [linechart getPointForIndex:j];

            NSLog(@"%@", NSStringFromCGPoint(point2));
            UIColor *lineColor = [UIColor orangeColor];
            if (i == 1) {
                if ([self.weekDay integerValue] != 1 && [self.weekDay integerValue] < j+2  ) {
                    lineColor = [UIColor imageViewBorderColor];
                }
            }
            
            
            DotLineView *line = [[DotLineView alloc] initWithFrame:CGRectMake(point2.x, 0 , 1, point2.y) andColor:lineColor];
            line.backgroundColor = [UIColor clearColor];
            
            [shartView addSubview:line];
            
            
        }
    }
    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(20, 148, SCREENWIDTH - 40, 0.5)];
    bottomLine.backgroundColor = [UIColor lineGrayColor];
    [self.mamaScrollView addSubview:bottomLine];
    
    bottomLine = [[UIView alloc] initWithFrame:CGRectMake(SCREENWIDTH + 20, 148, SCREENWIDTH - 40, 0.5)];
    bottomLine.backgroundColor = [UIColor lineGrayColor];
    [self.mamaScrollView addSubview:bottomLine];
    
    
    
    //画圆圈
    

    
    
    //本周日期
    NSArray *text = @[@"一", @"二", @"三", @"四",@"五",@"六",@"日"];
    for (int i = 0; i < 7; i++) {
        UILabel *label = [[UILabel alloc]  initWithFrame:CGRectMake(SCREENWIDTH + i * (SCREENWIDTH - 50)/6 + 5, 8, 40, 20)];
        label.text = text[i];
        label.font = [UIFont systemFontOfSize:14];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor orangeThemeColor];
        label.tag = 8000+ i;
        label.userInteractionEnabled = NO;
        [self.mamaScrollView addSubview:label];
        [self.labelArray addObject:label];
    }
   // NSLog(@"%@", self.labelArray);
    
    
   
    
    //下周日期
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *now;
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags =NSYearCalendarUnit | NSMonthCalendarUnit |NSDayCalendarUnit | NSWeekdayCalendarUnit |
    NSHourCalendarUnit |NSMinuteCalendarUnit | NSSecondCalendarUnit;
    now=[NSDate date];
    
    NSLog(@"now = %@", now);
    comps = [calendar components:unitFlags fromDate:now];
    NSLog(@"comps = %@", comps);
    now = [calendar dateFromComponents:comps];
    
    NSLog(@"now = %@", now);
    self.weekDay = [NSNumber numberWithInteger:[comps weekday]];
    
    //self.weekDay
    NSLog(@"%@", self.weekDay);
    int today = (int)[self.weekDay integerValue];
    int lastday = 0;
    switch (today) {
        case 1:
            lastday = 7;
            break;
        case 2:
            lastday = 1;
            break;
        case 3:
            lastday = 2;
            break;
        case 4:
            lastday = 3;
            break;
        case 5:
            lastday = 4;
            break;
        case 6:
            lastday = 5;
            break;
        case 7:
            lastday = 6;
            break;
            
        default:
            break;
    }
    lastday += 7;
    NSLog(@"lastDay = %d", lastday);
    
    int tag = (today + 6)%7;
    if (tag == 0) {
        tag = 7;
    }
    UILabel *label = [self.mamaScrollView viewWithTag:8000 + tag - 1];
   // label.textColor = [UIColor redColor];
    
    
    [UIView animateWithDuration:0 animations:^{
        orongeCircleView.frame = label.frame;
    } completion:^(BOOL finished) {
        label.textColor = [UIColor whiteColor];
    }];
    
    
    
    [self.lastweeknames removeAllObjects];
    
    for (int i = 0; i < 7; i++) {
        NSTimeInterval timeInterval = -(lastday - i - 1) * 24 * 60 * 60;
        NSDate *lastDate = [NSDate dateWithTimeIntervalSinceNow:timeInterval];
        
        comps = [calendar components:unitFlags fromDate:lastDate];

        NSLog(@"lastDate = %@", comps);
        
        NSString *string = [NSString stringWithFormat:@"%ld/%ld", (long)[comps month], (long)[comps day]];
        [self.lastweeknames addObject:string];
    }
    
    NSLog(@"%@", self.lastweeknames);
    
    
    
    for (int i = 0; i < 7; i++) {
        UILabel *label = [[UILabel alloc]  initWithFrame:CGRectMake(i * (SCREENWIDTH - 50)/6 + 5, 8, 40, 20)];
        label.text = self.lastweeknames[i];
        label.font = [UIFont systemFontOfSize:14];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor orangeThemeColor];
        label.tag = 80+ i;
        label.userInteractionEnabled = NO;
        [self.mamaScrollView addSubview:label];
        [self.anotherLabelArray addObject:label];
        if (i == 6) {
            label.textColor = [UIColor whiteColor];
            self.anotherOrongeView.frame = label.frame;
            
            
        }
    }
    
    
    [self createButtons];
    
}
- (void)createButtons{
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeSystem];
    btn1.frame = CGRectMake(SCREENWIDTH - 20, 60, 20, 30);
    [btn1 addTarget:self action:@selector(btn1Clicked) forControlEvents:UIControlEventTouchUpInside];
    [self.mamaScrollView addSubview:btn1];
    [btn1 setBackgroundImage:[UIImage imageNamed:@"zhexianyou.png"] forState:UIControlStateNormal];
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeSystem];
    btn2.frame = CGRectMake(SCREENWIDTH, 60, 20, 30);
    [btn2 addTarget:self action:@selector(btn2Clicked) forControlEvents:UIControlEventTouchUpInside];
    [self.mamaScrollView addSubview:btn2];
    [btn2 setBackgroundImage:[UIImage imageNamed:@"zhexianzuo.png"] forState:UIControlStateNormal];
    
    
    
    UIButton *btn4 = [UIButton buttonWithType:UIButtonTypeSystem];
    btn4.frame = CGRectMake(0, 60, 20, 30);
    [self.mamaScrollView addSubview:btn4];
    [btn4 setBackgroundImage:[UIImage imageNamed:@"zhexianzuo.png"] forState:UIControlStateNormal];
    
}
- (void)btn2Clicked{
    NSLog(@"quxiazhou");
    
    [UIView animateWithDuration:0.3 animations:^{
        self.mamaScrollView.contentOffset = CGPointMake(0, 0);
    } completion:^(BOOL finished) {
        
    }];
}

- (void)btn1Clicked{
    NSLog(@"qubenzhou");
    [UIView animateWithDuration:0.3 animations:^{
        self.mamaScrollView.contentOffset = CGPointMake(SCREENWIDTH, 0);
    } completion:^(BOOL finished) {
        
    }];
}
// 点击表格 更新数据
- (void)tapClicked:(UITapGestureRecognizer *)recognizer{

    
    UIView *weekView = [recognizer view];
    weekView.backgroundColor = [UIColor redColor];
    
    
    NSInteger week = weekView.tag - 1000;
    
    if (week == 2) {
        week =1;
    } else if (week == 1){
        week = 2;
    }
    
    NSLog(@"第 %ld 周订单数据", week);
    
   // NSLog(@"weekView subView = %@", [weekView subviews]);
    

    CGPoint location = [recognizer locationInView:recognizer.view];
  //  NSLog(@"location = %@", NSStringFromCGPoint(location));
    CGFloat width = location.x;
   // NSLog(@"width = %f", width);
    CGFloat unitwidth = (SCREENWIDTH - 50)/6;
  //  NSLog(@"unit = %.0f", unitwidth);
    int index = (int)((width + unitwidth/2 - 5 ) /unitwidth);
    
    NSLog(@"index = %d", index);
    NSInteger days = (6 - index) + (week - 1)*7;
    if (days - quxiaodays < 0) {
        return;
    }

    FSLineChart *linechart = [weekView subviews][0];
    UIView *circleView = [weekView viewWithTag:300];
    UIView *lineView = [weekView viewWithTag:400];
    

    
    CGPoint point = [linechart getPointForIndex:index];
   // NSLog(@"point = %@", NSStringFromCGPoint(point));
    
    
    circleView.frame = CGRectMake(point.x - 3, point.y - 3, 6, 6);
    lineView.frame = CGRectMake(point.x - 1, point.y, 2, 115- point.y);
    

    
    self.visitorDate = [NSNumber numberWithInteger:days - quxiaodays];
    NSLog(@"days = %ld", days - quxiaodays);
   // NSLog(@"array = %@", self.mamaOrderArray);
   // NSLog(@"%ld", quxiaodays);
    
   
    
    NSDictionary *dic = self.mamaOrderArray[days - quxiaodays];
    
    NSLog(@"info = %@", dic);
    
    
    self.dingdanLabel.text = [[dic objectForKey:@"order_num"] stringValue];
    self.shouyiLabel.text = [NSString stringWithFormat:@"%.2f", [dic[@"carry"] floatValue]];
    self.todayNum.text = [dic[@"visitor_num"] stringValue];
    
    if (week == 1) {
   
        __block UILabel *label = (UILabel *)self.labelArray[index];
        CGRect rect = label.frame;
        
        label = [self.mamaScrollView viewWithTag:(8000 + index)];
        NSLog(@"label = %@", label);
        
        for (int i = 0; i < 7; i++) {
            UILabel *theLabel = [self.mamaScrollView viewWithTag:(8000 + i)];
            theLabel.textColor = [UIColor orangeThemeColor];
        }
        [UIView animateWithDuration:0.3 animations:^{
            orongeCircleView.frame = rect;
        } completion:^(BOOL finished) {
            label.textColor = [UIColor whiteColor];
            
            
        }];
    } else if(week == 2) {
        NSLog(@"index = %ld", (long)index);
    
        __block UILabel *label = (UILabel *)self.anotherLabelArray[index];
        CGRect rect = label.frame;
        
        label = [self.mamaScrollView viewWithTag:(80 + index)];
        NSLog(@"label = %@", label);
        
        for (int i = 0; i < 7; i++) {
            UILabel *theLabel = [self.mamaScrollView viewWithTag:(80 + i)];
            theLabel.textColor = [UIColor orangeThemeColor];
        }
        [UIView animateWithDuration:0.3 animations:^{
            self.anotherOrongeView.frame = rect;
        } completion:^(BOOL finished) {
            label.textColor = [UIColor whiteColor];
            
            
        }];

    }
   
    
    
 
}


//制作表格。。。
-(FSLineChart*)chart2:(NSMutableArray *)chartData {
    // Creating the line chart
    self.lineChart = [[FSLineChart alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH - 40, 120)];
    self.lineChart.verticalGridStep = 1;
    self.lineChart.horizontalGridStep = 6;
    self.lineChart.color = [UIColor fsOrange];
    self.lineChart.fillColor = nil;
    
    self.lineChart.bezierSmoothing = NO;
    self.lineChart.animationDuration = 1;
    self.lineChart.drawInnerGrid = NO;
    
    
    [self.lineChart setChartData:chartData];
  
    [self.lineChart showLineViewAfterDelay:self.lineChart.animationDuration];
   
    return self.lineChart;
}

//  获取表格数据  2016 － 3-30 订单折线图 改为收益折线图。。。。

- (void)prepareData{
    
    NSString *chartUrl = [NSString stringWithFormat:@"%@/rest/v2/mama/dailystats?from=0&days=14", Root_URL];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:chartUrl parameters:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (!responseObject)return ;
        NSArray *arr = responseObject[@"results"];
        if (arr.count == 0)return;
        NSArray *data = [NSArray reverse:arr];
//        NSArray *data = [NSArray arrayWithObjects:@"0.00",@"0.00", @"0.00",@"0.00",@"0.00",@"0.00",@"0.00",@"0.00",@"0.00",@"0.00",@"0.00",@"0.00",@"0.00",@"0.00", nil];
        
        //遍历数据如果都为零的时候显示默认图
//        BOOL have = [self isHaveData:data];
//        
//        if (!have) {
//            self.mamaimage.hidden = NO;
//            self.mamalabel.hidden = NO;
//            return;
//        }
    
        self.mamaOrderArray = data;
        
        NSDictionary *dic = data[0];
    //    NSLog(@"info = %@", dic);
        
        
        self.dingdanLabel.text = [[dic objectForKey:@"order_num"] stringValue];
        self.shouyiLabel.text = [NSString stringWithFormat:@"%.2f", [dic[@"carry"] floatValue]];
        self.todayNum.text = [dic[@"visitor_num"] stringValue];
        
        
        NSLog(@"orderArray = %@", self.mamaOrderArray);
        data = arr;
        
        NSLog(@"%@", arr);
        
//        for (NSMutableDictionary *testDic in data) {
//            testDic[@"carry"] = [NSNumber numberWithFloat:0.00];
//        }
        
        
        NSMutableArray *weekArray = [[NSMutableArray alloc] init];
        int xingqiji = (int)[self.weekDay integerValue];
        switch (xingqiji) {
            case 1:
                quxiaodays = 0;
                break;
            case 2:
                quxiaodays = 6;
                break;
            case 3:
                quxiaodays = 5;
                break;
            case 4:
                quxiaodays = 4;
                break;
            case 5:
                quxiaodays = 3;
                break;
            case 6:
                quxiaodays = 2;
                break;
            case 7:
                quxiaodays = 1;
                break;
                
            default:
                break;
        }
        
        for (int i = quxiaodays; i < data.count + quxiaodays; i++) {
            if (i>data.count - 1) {
                [weekArray addObject:@0.01];
            } else {
                float number = [[data[i] objectForKey:@"carry"] floatValue] + 0.01;
                NSNumber *order_num = [NSNumber numberWithFloat:number];

                NSLog(@"------carry = %@, shouyi = %@",[data[i] objectForKey:@"carry"], order_num);
                
                [weekArray addObject:order_num];
                
            }
            
//            if ((i +1 - quxiaodays)%7 == 0)
            if ((i + 1 - quxiaodays)% 7 == 0) {
                
                NSLog(@" weekarray = %@", weekArray);
                float sum = [self sumofoneWeek:weekArray];
                //   NSLog(@"第%d周订单的和为：%ld",(int)i/7, sum);
                if (sum == 0) {
                    break;
                }
                
                [allDingdan addObject:[weekArray copy]];
                
                NSLog(@"weekArray ＝ %@", weekArray);
                
                [weekArray removeAllObjects];
            }
            
        }
        
        
//        [allDingdan removeAllObjects];
//        if (allDingdan.count == 0) {
//            return;
//        }
      
        if (allDingdan.count > 0) {
            self.mamaimage.hidden = YES;
            self.mamalabel.hidden = YES;
        }
        scrollViewContentOffset = CGPointMake(SCREENWIDTH * allDingdan.count - SCREENWIDTH, 0);
       [self createChart:allDingdan];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

//便利数组
- (BOOL)isHaveData:(NSArray *)arr {
    for (NSDictionary *daysDic in arr) {
        CGFloat carry = [[daysDic objectForKey:@"carry"] floatValue];
        if (carry > 0.000001) {
            return YES;
        }
    }
    return NO;
}

//创建默认图片
- (void)createDefaultPicture {
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(SCREENWIDTH * 0.5 - 40, SCREENHEIGHT * 0.5 - 40, 80, 80)];
    imageV.backgroundColor = [UIColor redColor];
    imageV.image = [UIImage imageNamed:@"defaultPig"];
    
    [self.mamaScrollView bringSubviewToFront:imageV];
//    [self.mamaScrollView addSubview:imageV];
    
    NSLog(@"%@", NSStringFromCGRect(self.mamaScrollView.frame));
}

#pragma mark --TableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    self.tableViewHeight.constant = self.dataArr.count *80;
    
   return (self.dataArr.count);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
        MaMaOrderTableViewCell *cell = (MaMaOrderTableViewCell*)[tableView  dequeueReusableCellWithIdentifier:@"MaMaOrder" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (cell == nil) {
            cell = [[MaMaOrderTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MaMaOrder"];
        }
        MaMaOrderModel *orderM = self.dataArr[indexPath.row];
        [cell fillDataOfCell:orderM];
        
        return cell;
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

- (void)backClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)sendProduct:(id)sender {
    PublishNewPdtViewController *publish = [[PublishNewPdtViewController alloc] init];
    [self.navigationController pushViewController:publish animated:YES];
}
#pragma mark --- 订单记录按钮
- (IBAction)MamaOrderClicked:(id)sender {
    MaMaOrderListViewController *orderList = [[MaMaOrderListViewController alloc] init];
    orderList.orderRecord = self.orderRecord;
    [self.navigationController pushViewController:orderList animated:YES];
}
#pragma mark --- 收益记录按钮
- (IBAction)MamaCarryLogClicked:(id)sender {
//    MaMaCarryLogViewController *carry = [[MaMaCarryLogViewController alloc] init];
//    
//    carry.earningsRecord = self.earningsRecord;
    MaClassifyCarryLogViewController *carry = [[MaClassifyCarryLogViewController alloc] init];
    carry.earningsRecord = self.earningsRecord;
    [self.navigationController pushViewController:carry animated:YES];
}

- (IBAction)erweima:(id)sender {
    
    NSLog(@"点击我的邀请");
    
//    TuijianErweimaViewController *erweima = [[TuijianErweimaViewController alloc] init];
//    [self.navigationController pushViewController:erweima animated:YES];
    if ([self.myInvitation class] == [NSNull class])return;
    
//    MyInvitationViewController *invitation = [[MyInvitationViewController alloc] init];
//    
//    invitation.requestURL = self.myInvitation;
//    [self.navigationController pushViewController:invitation animated:YES];
    
    WebViewController *activity = [[WebViewController alloc] init];
//    _diction = [NSMutableDictionary dictionary];
//    _diction = nil;
    NSString *active = @"myInvite";
    NSString *titleName = @"我的邀请";
    [self.diction setValue:self.myInvitation forKey:@"web_url"];
    [self.diction setValue:active forKey:@"type_title"];
    [self.diction setValue:titleName forKey:@"name_title"];
    
    activity.webDiction = _diction;
    activity.isShowNavBar = true;
    activity.isShowRightShareBtn = false;
    
    [self.navigationController pushViewController:activity animated:YES];
}
#pragma mark ---- 我的精选
- (IBAction)jingxuanliebiao:(id)sender {
    
    ShopPreviousViewController *previous = [[ShopPreviousViewController alloc] init];
    [self.navigationController pushViewController:previous animated:YES];
    
//    MaMaShopViewController *shop = [[MaMaShopViewController alloc] init];
//    [self.navigationController pushViewController:shop animated:YES];
}
#pragma mark --- 选品上架
- (IBAction)xuanpinliebiao:(id)sender {
    ProductSelectionListViewController *product = [[ProductSelectionListViewController alloc] init];
    [self.navigationController pushViewController:product animated:YES];
}

- (IBAction)shareSubsidiesAction:(id)sender {
    MaMaShareSubsidiesViewController *share = [[MaMaShareSubsidiesViewController alloc] init];
    share.clickTotalMoeny = self.clickTotalMoney;
    share.todayMoney = self.money;
    
    [self.navigationController pushViewController:share animated:YES];
}

#pragma mark --- 我的粉丝按钮
- (IBAction)fansList:(id)sender {
//    FensiListViewController *fensiVC = [[FensiListViewController alloc] init];
//    fensiVC.fansNum = self.fansNum;
//    [self.navigationController pushViewController:fensiVC animated:YES];
    JMMaMaCenterFansController *mamaCenterFansVC = [[JMMaMaCenterFansController alloc] init];
    mamaCenterFansVC.fansNum = self.fansNum;
    [self.navigationController pushViewController:mamaCenterFansVC animated:YES];
}

- (IBAction)boutiqueActivities:(id)sender {
    //精品活动
    if (self.eventLink == nil || self.eventLink.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"活动还未开始"];
        return;
    }
    WebViewController *activity = [[WebViewController alloc] init];
    
//    _diction = nil;
    
    NSString *active = @"myInvite";
    NSString *titleName = @"精品活动";
    
    [self.diction setValue:self.eventLink forKey:@"web_url"];
    [self.diction setValue:active forKey:@"type_title"];
    [self.diction setValue:titleName forKey:@"name_title"];
    
    activity.webDiction = _diction;//[NSMutableDictionary dictionaryWithDictionary:_diction];
    activity.isShowNavBar = true;
    activity.isShowRightShareBtn = true;
    activity.share_model.share_link = self.eventLink;
    activity.share_model.title = @"精品活动";
    activity.share_model.desc = @"更多精选活动,尽在小鹿美美~~";
    activity.share_model.share_img = @"http://7xogkj.com2.z0.glb.qiniucdn.com/1181123466.jpg";
    activity.share_model.share_type = @"link";
    [self.navigationController pushViewController:activity animated:YES];
    
}

- (IBAction)todayVisitor:(id)sender {
    TodayVisitorViewController *today = [[TodayVisitorViewController alloc] init];
    today.visitorDate = self.visitorDate;
    [self.navigationController pushViewController:today animated:YES];
}

- (IBAction)todayOrder:(id)sender {
    MaMaOrderListViewController *order = [[MaMaOrderListViewController alloc] init];
    order.orderRecord = self.orderRecord;
    [self.navigationController pushViewController:order animated:YES];
}

- (IBAction)todayCarry:(id)sender {
    MaClassifyCarryLogViewController *carry = [[MaClassifyCarryLogViewController alloc] init];
    carry.earningsRecord = self.earningsRecord;
    [self.navigationController pushViewController:carry animated:YES];
}

- (void)clickShareView {
//    MaMaShareSubsidiesViewController *share = [[MaMaShareSubsidiesViewController alloc] init];
//    share.clickDate = _clickDate;
//    share.todayMoney = _money;
//    [self.navigationController pushViewController:share animated:YES];
}

@end
