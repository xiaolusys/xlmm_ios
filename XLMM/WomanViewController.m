//
//  WomanViewController.m
//  XLMM
//
//  Created by younishijie on 15/8/1.
//  Copyright (c) 2015年 上海己美. All rights reserved.
//

#import "WomanViewController.h"
#import "LogInViewController.h"
#import "MMClass.h"
#import "PeopleCollectionCell.h"
#import "PeopleModel.h"
#import "UIImageView+WebCache.h"

#define kReuseIdentifier @"PeopleCollectionCell"

@interface WomanViewController ()



@property (nonatomic, strong)NSMutableArray *dataArray;


@end

@implementation WomanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"时尚女装";
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0, 0, 30, 30);
    [rightButton setBackgroundImage:LOADIMAGE(@"goodsthumb.png") forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    
   
    [self.womanCollectionView registerClass:[PeopleCollectionCell class] forCellWithReuseIdentifier:@"PeopleCollectionCell"];
    
    //[self.womanCollectionView registerNib:[UINib nibWithNibName:@"PeopleCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"PeopleCollectionCell"];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake(172, 220)];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical]; flowLayout.sectionInset = UIEdgeInsetsMake(8, 10, 0, 10);
    [self.womanCollectionView setCollectionViewLayout:flowLayout];
    
    dispatch_sync(kBgQueue, ^{
        NSData *data = [NSData dataWithContentsOfURL:kLoansRRL(kLADY_LIST_URL)];
        [self performSelectorOnMainThread:@selector(mmParseData:) withObject:data waitUntilDone:YES];
    });
   // NSLog(@"333333");
}

- (void)mmParseData:(NSData *)responseData{
    NSError *error;
    self.dataArray = [[NSMutableArray alloc] init];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
    
    NSArray *array = [json objectForKey:@"results"];
    for (NSDictionary *dic in array) {
        PeopleModel *model = [[PeopleModel alloc] init];
        model.imageURL = [dic objectForKey:@"pic_path"];
        model.name = [dic objectForKey:@"name"];
        model.price = [dic objectForKey:@"agent_price"];
        model.oldPrice = [dic objectForKey:@"std_sale_price"];
        [self.dataArray addObject:model];
    }
    for (PeopleModel *model in self.dataArray) {
       // MMLOG(model.imageURL);
        MMLOG(model.name);
//        MMLOG(model.price);
//        MMLOG(model.oldPrice);
    }
    [self.womanCollectionView reloadData];
}

#pragma mark -----CollectionViewDelegate----

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 10;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
  
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kReuseIdentifier forIndexPath:indexPath];
    
    return cell;
}

#pragma mark  -----btnClicked:-----

- (void)login:(UIButton *)button{
    NSLog(@"登录");
    LogInViewController *loginVC = [[LogInViewController alloc] init];
    [self.navigationController pushViewController:loginVC animated:YES];
}

- (IBAction)btnClicked:(UIButton *)sender {
    if (sender.tag == 3) {
        NSLog(@"333");
    } else if (sender.tag == 4){
        NSLog(@"4444");
    }
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
