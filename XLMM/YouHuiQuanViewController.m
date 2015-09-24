//
//  YouHuiQuanViewController.m
//  XLMM
//
//  Created by younishijie on 15/8/20.
//  Copyright (c) 2015年 上海己美. All rights reserved.
//

#import "YouHuiQuanViewController.h"
#import "AddYouhuiquanViewController.h"
#import "MMClass.h"
#import "YHQCollectionCell.h"

@interface YouHuiQuanViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, retain) UICollectionView *myCollectionView;

@property (nonatomic, copy) NSArray *dataArray;


@end

static NSString *ksimpleCell = @"youhuiCell";

@implementation YouHuiQuanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self createInfo];
    
     [self createCollectionView];
   // self.containerView.hidden = YES;
    
    [self downLoadData];
}

- (void)downLoadData{
    NSString *urlString = [NSString stringWithFormat:@"%@", KUserCoupins_URL];
    NSLog(@"url = %@", urlString);
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]];
    if (data == nil) {
        return;
    }
    NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    NSLog(@"array = %@", array);
    self.dataArray = array;
    
}
- (void)createCollectionView{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 8, 0);
    
    self.myCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT - 64) collectionViewLayout:flowLayout];
    
    self.myCollectionView.backgroundColor = [UIColor whiteColor];
    
    self.myCollectionView.delegate = self;
    self.myCollectionView.dataSource = self;
    self.myCollectionView.showsVerticalScrollIndicator = NO;
    
    
    [self.myCollectionView registerClass:[YHQCollectionCell class] forCellWithReuseIdentifier:ksimpleCell];
   
    [self.containerView addSubview:self.myCollectionView];
    
    
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    return self.dataArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    YHQCollectionCell *cell = (YHQCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:ksimpleCell forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor whiteColor];
    
    NSDictionary *dic = [self.dataArray objectAtIndex:indexPath.row];
    
    if ([[dic objectForKey:@"status"] integerValue] == 1) {
        cell.myimageView.image = [UIImage imageNamed:@"youhuiquan4.png"];
    }
    cell.name1.text = [dic objectForKey:@"title"];
    cell.name2.text = @"";
    cell.time1.text = [NSString stringWithFormat:@"%@ －",[dic objectForKey: @"created"]];
    cell.time2.text = [dic objectForKey: @"deadline"];
    
    
    
    
       return cell;;
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(SCREENWIDTH, SCREENWIDTH*164/590);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 4;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 4;
}




- (void)createInfo{
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    label.text = @"优惠券";
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:26];
    label.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = label;
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon-fanhui.png"]];
    imageView.frame = CGRectMake(8, 8, 18, 31);
    [button addSubview:imageView];
    [button addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIButton *button2 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    UIImageView *imageView2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon-jia.png"]];
    imageView2.frame = CGRectMake(8, 8, 30, 30);
    [button2 addSubview:imageView2];
    [button2 addTarget:self action:@selector(addBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:button2];
    self.navigationItem.rightBarButtonItem = rightItem;
    
}

- (void)addBtnClicked:(UIButton *)button{
    NSLog(@"获得优惠券");
    
    AddYouhuiquanViewController *addVC = [[AddYouhuiquanViewController alloc] initWithNibName:@"AddYouhuiquanViewController" bundle:nil];
    [self.navigationController pushViewController:addVC animated:YES];
    
}

- (void)backBtnClicked:(UIButton *)button{
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
