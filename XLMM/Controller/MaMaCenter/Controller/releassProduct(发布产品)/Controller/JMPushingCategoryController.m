//
//  JMPushingCategoryController.m
//  XLMM
//
//  Created by zhang on 16/10/10.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMPushingCategoryController.h"
#import "MMClass.h"
#import "PublishNewPdtViewController.h"
#import "JMStoreManager.h"

// 主页分类 比例布局
#define HomeCategoryRatio               SCREENWIDTH / 320.0
#define HomeCategorySpaceW              25 * HomeCategoryRatio
#define HomeCategorySpaceH              20 * HomeCategoryRatio

@interface JMPushingCategoryController () <UITableViewDataSource,UITableViewDelegate> {
    NSMutableArray *categoryArray;
}


@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;

@end



@implementation JMPushingCategoryController

- (NSMutableArray *)dataSource {
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavigationBarWithTitle:@"每日推送" selecotr:@selector(backClickAction)];
    categoryArray = [NSMutableArray array];
    [self createTableView];
    [self createHeaderView];


}
- (void)createTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT - 104) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellID"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    
    
}

- (void)createHeaderView {
    CGFloat oneRowCellH = (SCREENWIDTH - 5 * HomeCategorySpaceW) / 4 * 1.25 + 30;
    CGFloat twoRowCellH = (SCREENWIDTH - 5 * HomeCategorySpaceW) / 4 * 1.25 * 2 + 30 + HomeCategorySpaceH;

    categoryArray = [JMStoreManager getObjectByFileName:@"categorysArray"];
    
    UIView *headerView = [UIView new];
    if (categoryArray.count <= 4) {
        headerView.frame = CGRectMake(0, 0, SCREENWIDTH, oneRowCellH);
    }else {
        headerView.frame = CGRectMake(0, 0, SCREENWIDTH, twoRowCellH);
    }
    NSInteger imageW = (SCREENWIDTH - 5 * HomeCategorySpaceW) / 4;
    NSInteger imageH = imageW * 1.25;
    for (int i = 0; i < categoryArray.count; i++) {
        NSDictionary *dic = categoryArray[i];
        UIImageView *iconImage = [UIImageView new];
        [iconImage sd_setImageWithURL:[NSURL URLWithString:[dic[@"cat_img"] JMUrlEncodedString]] placeholderImage:nil];
        iconImage.userInteractionEnabled = YES;
        iconImage.contentMode = UIViewContentModeScaleAspectFit;
        [headerView addSubview:iconImage];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
        [iconImage addGestureRecognizer:tap];
        UIView *tapView = [tap view];
        tapView.tag = 100 + i;
        iconImage.tag = 100 + i;
        
        iconImage.frame = CGRectMake(HomeCategorySpaceW + (imageW + HomeCategorySpaceW) * (i % 4), 15 + (imageH + HomeCategorySpaceH) * (i / 4), imageW, imageH);
        
    }
    self.tableView.tableHeaderView = headerView;
    
}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
//    [self configureCell:cell atIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor redColor];
    return cell;
}

- (void)tapClick:(UITapGestureRecognizer *)tap {
    UIView *tapView = [tap view];
    NSInteger index = tapView.tag - 100;
    NSDictionary *dic = categoryArray[index];
    PublishNewPdtViewController *pushVC = [[PublishNewPdtViewController alloc] init];
    pushVC.categoryCidString = [NSString stringWithFormat:@"sale_category=%@",@"69"];
    [self.navigationController pushViewController:pushVC animated:YES];
    
}



- (void)backClickAction {
    [self.navigationController popViewControllerAnimated:YES];
}











@end
