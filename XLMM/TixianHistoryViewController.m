//
//  TixianHistoryViewController.m
//  XLMM
//
//  Created by younishijie on 16/1/18.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "TixianHistoryViewController.h"
#import "UIViewController+NavigationBar.h"
#import "MMClass.h"
#import "AFNetworking.h"
#import "TixianTableViewCell.h"
#import "TixianModel.h"




static NSString *CellIdentify = @"TixianCellIdentify";

@interface TixianHistoryViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;


@end

@implementation TixianHistoryViewController


- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return self;

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self createNavigationBarWithTitle:@"提现历史" selecotr:@selector(backClicked:)];
    
    [self createTableView];
    
    [self downloadData];
}

- (void)downloadData{
    [self downLoadWithURLString:[NSString stringWithFormat:@"%@/rest/v1/cashout", Root_URL] andSelector:@selector(fetchedHistoryData:)];
}

- (void)fetchedHistoryData:(NSData *)data{
    if (data== nil) {
        return;
    }
    NSError *error = nil;
    NSDictionary *dicJson = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (error!= nil) {
        NSLog(@"error = %@", error.description);
        
    }
 //   NSLog(@"json = %@", dicJson);
    
    NSArray *results = [dicJson objectForKey:@"results"];
    for (NSDictionary *dic in results) {
        TixianModel *model = [TixianModel modelWithDiction:dic];
        [self.dataArray addObject:model];
    }
    
  
    
    [self.tableView reloadData];
    
}

- (void)downLoadWithURLString:(NSString *)url andSelector:(SEL)aSeletor{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(){
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
        if (data == nil) {
            return ;
        }
        [self performSelectorOnMainThread:aSeletor withObject:data waitUntilDone:YES];
        
    });
}

- (void)createTableView{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT) style:UITableViewStylePlain];
//    self.tableView.backgroundColor = [UIColor orangeColor];
    
    [self.tableView registerClass:[UITableViewCell class]
             forCellReuseIdentifier:CellIdentify];
//    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
     [self.tableView registerNib:[UINib nibWithNibName:@"TixianTableViewCell" bundle:nil] forCellReuseIdentifier:CellIdentify];
    [self.view addSubview:self.tableView];
    
    
    
    
}


#pragma makr --UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TixianTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentify];
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    TixianModel *model = [self.dataArray objectAtIndex:indexPath.row];
    
    [cell fillModel:model];
    
    return cell;
 
  
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (void)backClicked:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
    
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

@end
