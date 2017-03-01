//
//  JMPushingCategoryController.m
//  XLMM
//
//  Created by zhang on 16/10/10.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMPushingCategoryController.h"
#import "PublishNewPdtViewController.h"
#import "JMStoreManager.h"



@interface JMPushingCategoryController () { //<UITableViewDataSource,UITableViewDelegate>
    NSMutableArray *categoryArray;
    CGFloat twoRowCellOffsetY;
}


@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableDictionary *contentOffsetYDic;
@property (nonatomic, strong) UIView *headerV;

@end



@implementation JMPushingCategoryController

- (NSMutableArray *)dataSource {
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
- (NSMutableDictionary *)contentOffsetYDic {
    if (!_contentOffsetYDic) {
        self.contentOffsetYDic = [NSMutableDictionary dictionaryWithCapacity:0];
    }
    return _contentOffsetYDic;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavigationBarWithTitle:@"每日推送" selecotr:@selector(backClickAction)];
    categoryArray = [NSMutableArray array];
//    [self createTableView];
    [self createHeaderView];
    NSLog(@"class name>> %@",NSStringFromClass([self class]));

}
//- (void)createTableView {
//    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT - 104) style:UITableViewStylePlain];
//    self.tableView.delegate = self;
//    self.tableView.dataSource = self;
//    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellID"];
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    [self.view addSubview:self.tableView];
//    
//    
//    
//}

- (void)createHeaderView {
    CGFloat oneRowCellH = (SCREENWIDTH - 5 * HomeCategorySpaceW) / 4 * 1.25 + 60;
    CGFloat twoRowCellH = (SCREENWIDTH - 5 * HomeCategorySpaceW) / 4 * 1.25 * 2 + 60 + HomeCategorySpaceH;
    categoryArray = (NSMutableArray *)[JMStoreManager getDataArray:@"categorysArray.xml"];
    
    UIView *headerV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, twoRowCellH)];
    headerV.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:headerV];
    self.headerV = headerV;
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 25)];
    [headerV addSubview:topView];
    UILabel *topLabel = [UILabel new];
    [topView addSubview:topLabel];
    topLabel.textColor = [UIColor buttonTitleColor];
    topLabel.font = CS_SYSTEMFONT(16.);
    topLabel.text = @"热门分类";
    [topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(topView.mas_centerY);
        make.left.equalTo(topView).offset(HomeCategorySpaceW);
    }];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 25, SCREENWIDTH, twoRowCellH - 40)];
    [headerV addSubview:headerView];
    if (categoryArray.count <= 4) {
        headerView.frame = CGRectMake(0, 25, SCREENWIDTH, oneRowCellH - 40);
    }else {
        headerView.frame = CGRectMake(0, 25, SCREENWIDTH, twoRowCellH - 40);
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
        
        iconImage.frame = CGRectMake(HomeCategorySpaceW + (imageW + HomeCategorySpaceW) * (i % 4), 10 + (imageH + HomeCategorySpaceH) * (i / 4), imageW, imageH);
        
    }
//    self.tableView.tableHeaderView = headerView;
    UIView *bottomV = [[UIView alloc] initWithFrame:CGRectMake(0, twoRowCellH - 15, SCREENWIDTH, 15)];
    bottomV.backgroundColor = [UIColor countLabelColor];
    [headerV addSubview:bottomV];
    
    
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.picCollectionView) {
        CGFloat contentOffY = scrollView.contentOffset.y;
        if (scrollView.dragging) {
            if (contentOffY >= 0) {
                //隐藏
                [UIView animateWithDuration:0.5 animations:^{
//                    self.picCollectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
                    self.headerV.alpha = 0.;
                }];
            }else if(contentOffY < 0){
                //显示
                [UIView animateWithDuration:0.5 animations:^{
                    self.headerV.alpha = 1.0;
//                    self.picCollectionView.contentInset = UIEdgeInsetsMake((SCREENWIDTH - 5 * HomeCategorySpaceW) / 4 * 1.25 * 2 + 60 + HomeCategorySpaceH, 0, 0, 0);
                }];
            }
        }
    }
    
    
}


//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return 0;
//}
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
////    [self configureCell:cell atIndexPath:indexPath];
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    cell.backgroundColor = [UIColor redColor];
//    return cell;
//}

- (void)tapClick:(UITapGestureRecognizer *)tap {
    UIView *tapView = [tap view];
    NSInteger index = tapView.tag - 100;
    NSDictionary *dic = categoryArray[index];
    NSString *urlString = CS_DSTRING(Root_URL,@"/rest/v1/pmt/ninepic");
    urlString = [NSString stringWithFormat:@"%@?%@",urlString,[NSString stringWithFormat:@"sale_category=%@",dic[@"id"]]];
    PublishNewPdtViewController *pushVC = [[PublishNewPdtViewController alloc] init];
//    pushVC.isPushingDays = YES;
    pushVC.pushungDaysURL = urlString;
    [self.navigationController pushViewController:pushVC animated:YES];
    
}



- (void)backClickAction {
    [self.navigationController popViewControllerAnimated:YES];
}











@end
