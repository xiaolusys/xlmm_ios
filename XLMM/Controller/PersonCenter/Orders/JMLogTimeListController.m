//
//  JMLogTimeListController.m
//  XLMM
//
//  Created by 崔人帅 on 16/6/6.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMLogTimeListController.h"
#import "JMOrderGoodsModel.h"
#import "SVProgressHUD.h"
#import "AFNetworking.h"
#import "MMClass.h"
#import "UIColor+RGBColor.h"

@interface JMLogTimeListController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSMutableArray *dataSource;

@end

@implementation JMLogTimeListController
- (NSMutableArray *)dataSource {
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
- (void)viewDidLoad {
    [super viewDidLoad];

    
    [self createTableView];
    
    
}
- (void)setTimeListArr:(NSMutableArray *)timeListArr {
    _timeListArr = timeListArr;
}

- (void)setUrlStr:(NSString *)urlStr {
    _urlStr = urlStr;
}

- (void)createTableView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 60) style:UITableViewStylePlain];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    //    self.tableView.tableFooterView = [UIView new];
    self.tableView.scrollEnabled = NO;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
//    if (!self.islogisInfo) {
        NSDictionary *wuliuInfo =  [self.timeListArr objectAtIndex:indexPath.row];
        NSString *timeText = [wuliuInfo objectForKey:@"time"];
        timeText = [self spaceFormatTimeString:timeText];
        
        NSString *infoText = [wuliuInfo objectForKey:@"content"];
        if(0 == indexPath.row){
            [self displayLastWuliuInfoWithTime:cell time:timeText andInfo:infoText];
        }
        else{
            [self displayWuliuInfoWithOrder:cell andTime:timeText andInfo:infoText];
        }
        
//    }
    return cell;
}
-(NSString*) spaceFormatTimeString:(NSString*)timeString{
    NSMutableString *ms = [NSMutableString stringWithString:timeString];
    NSRange range = {10,1};
    [ms replaceCharactersInRange:range withString:@" "];
    return ms;
}

-(void)displayLastWuliuInfoWithTime:(UITableViewCell *)cell time:(NSString*)timeText andInfo:(NSString*)infoText{
    cell.backgroundColor = [UIColor whiteColor];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0, SCREENWIDTH, 80)];
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(18, 0, 1, 80)];
    [view addSubview:lineView];
    UIView *circleView = [[UIView alloc] initWithFrame:CGRectMake(14, 0, 9, 9)];
    [view addSubview:circleView];
    
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(38, 0, 200, 17)];
    [view addSubview:timeLabel];
    UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(38, 20, 260, 35)];
    [view addSubview:infoLabel];
    
    timeLabel.text = timeText;
    timeLabel.font = [UIFont systemFontOfSize:14];
    
    infoLabel.text = infoText;
    infoLabel.font = [UIFont systemFontOfSize:14];
    infoLabel.lineBreakMode = NSLineBreakByWordWrapping;
    infoLabel.numberOfLines = 2;
    
    UIColor *color = [UIColor orangeThemeColor];
    timeLabel.textColor = color;
    infoLabel.textColor = color;
    
    circleView.layer.cornerRadius = 4.5;
    circleView.backgroundColor = color;
    
    lineView.backgroundColor = color;
    [cell addSubview:view];
}


-(void)displayWuliuInfoWithOrder:(UITableViewCell *)cell andTime:(NSString*)timeText andInfo:(NSString*)infoText{
    
    cell.backgroundColor = [UIColor whiteColor];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0, SCREENWIDTH, 80)];
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(18, 0, 1, 80)];
    [view addSubview:lineView];
    UIView *circleView = [[UIView alloc] initWithFrame:CGRectMake(14, 0, 9, 9)];
    [view addSubview:circleView];
    
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(38, 0, 200, 17)];
    [view addSubview:timeLabel];
    UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(38, 20, 260, 35)];
    [view addSubview:infoLabel];
    
    timeLabel.text = timeText;
    timeLabel.font = [UIFont systemFontOfSize:14];
    
    infoLabel.text = infoText;
    infoLabel.font = [UIFont systemFontOfSize:14];
    infoLabel.lineBreakMode = NSLineBreakByWordWrapping;
    infoLabel.numberOfLines = 2;
    
    UIColor *normalColor = [UIColor textDarkGrayColor];
    timeLabel.textColor = normalColor;
    infoLabel.textColor = normalColor;
    
    circleView.layer.cornerRadius = 4.5;
    circleView.backgroundColor = normalColor;
    
    lineView.backgroundColor = normalColor;
    
    [cell addSubview:view];
    
    
}


@end





























