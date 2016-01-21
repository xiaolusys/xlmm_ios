//
//  PublishNewPdtViewController.m
//  XLMM
//
//  Created by 张迎 on 16/1/6.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "PublishNewPdtViewController.h"
#import "UIViewController+NavigationBar.m"
#import "PicCollectionViewCell.h"
#import "PicHeaderCollectionReusableView.h"
#import "PicFooterCollectionReusableView.h"
#import "PhotoView.h"
#import "AFNetworking.h"
#import "MMClass.h"
#import "SharePicModel.h"
#import "SVProgressHUD.h"
#import "CountdownView.h"
#import "UILabel+CustomLabel.h"


#define CELLWIDTH (([UIScreen mainScreen].bounds.size.width - 82)/3)

@interface PublishNewPdtViewController ()

@property (nonatomic, strong)UICollectionView *picCollectionView;
@property (nonatomic, strong)PhotoView *photoView;

@property (nonatomic, strong)UIView *backView;

@property (nonatomic, strong)NSMutableArray *dataArr;
@property (nonatomic, assign)NSInteger saveIndex;
@property (nonatomic, strong)NSMutableArray *currentArr;



@end

@implementation PublishNewPdtViewController{
  
    NSTimer *theTimer;
    UIView *bottomView;
    CountdownView *countdowmView;
}

- (NSMutableArray *)dataArr {
    if (!_dataArr) {
        self.dataArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataArr;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
    if ([theTimer isValid]) {
        [theTimer invalidate];
    }
}

- (PhotoView *)photoView {
    if (!_photoView) {
        self.photoView = [[PhotoView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    }
    return _photoView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor backgroundlightGrayColor];
    self.navigationController.navigationBarHidden = NO;
    
    [self createNavigationBarWithTitle:@"发布产品" selecotr:@selector(backClickAction)];
    [self createCollectionView];
    
    [self showDefaultView];
    
}

- (void)showDefaultView{
    bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 180)];
    bottomView.backgroundColor = [UIColor backgroundlightGrayColor];
    countdowmView = [[CountdownView alloc] initWithFrame:CGRectMake(0, 0, 180, 180)];
    countdowmView.center = CGPointMake(SCREENWIDTH * 0.5, 125);
    [bottomView addSubview:countdowmView];
    [self.backView addSubview:bottomView];
    theTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:countdowmView selector:@selector(updateTimeView) userInfo:nil repeats:YES];
    
}

- (void)backClickAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)createCollectionView {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
   // CGFloat rightSize = ([UIScreen mainScreen].bounds.size.width - 78)/3;
    flowLayout.sectionInset = UIEdgeInsetsMake(10, 63, 10, 15);
    flowLayout.minimumInteritemSpacing = 1.5;
    flowLayout.minimumLineSpacing = 1.5;
    
    
    self.picCollectionView = [[UICollectionView alloc]initWithFrame:[UIScreen mainScreen].bounds collectionViewLayout:flowLayout];
    NSInteger hour = [self getCurrentTime];
    if (hour > 21) {
        self.picCollectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        [self.view addSubview:self.picCollectionView];
    }else {
       
        self.picCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 300, SCREENWIDTH, SCREENHEIGHT - 100) collectionViewLayout:flowLayout];
        
        [self showDefaultView];
        self.backView.backgroundColor = [UIColor redColor];
        self.picCollectionView.contentInset = UIEdgeInsetsMake(200, 0, 0, 0);
        [self.view addSubview:self.picCollectionView];
        
//        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
//        UIView *backView = [[UIView alloc] initWithFrame:self.scrollView.frame];
//        
//        [self.scrollView addSubview:backView];
//        backView.backgroundColor = [UIColor redColor];
//        
//        self.picCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 300, SCREENWIDTH,500) collectionViewLayout:flowLayout];
//        self.picCollectionView
//        [self.scrollView addSubview:self.picCollectionView];
//        self.picCollectionView.backgroundColor = []
//        [self showDefaultView];
//        [self.view addSubview:self.scrollView];
//        UIView *backView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 300, SCREENWIDTH, SCREENHEIGHT - 300)];
//        backView1.backgroundColor = [UIColor grayColor];
//        [backView1 addSubview:self.picCollectionView];
//        [self.scrollView addSubview:self.picCollectionView];
//        self.scrollView.contentSize = CGSizeMake(SCREENWIDTH, 1000);
//        [self.view addSubview:self.scrollView];
        
    }
    
    self.picCollectionView.backgroundColor = [UIColor whiteColor];
    
    self.picCollectionView.delegate = self;
    self.picCollectionView.dataSource = self;
    
    [self.picCollectionView registerNib:[UINib nibWithNibName:@"PicCollectionViewCell" bundle:nil]  forCellWithReuseIdentifier:@"picCollectionCell"];
    [self.picCollectionView registerNib:[UINib nibWithNibName:@"PicHeaderCollectionReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"picHeader"];
    [self.picCollectionView registerNib:[UINib nibWithNibName:@"PicFooterCollectionReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"picFooter"];
    
    //网络请求
    AFHTTPRequestOperationManager *manage = [AFHTTPRequestOperationManager manager];
    NSString *requestURL = [NSString stringWithFormat:@"%@/rest/v1/ninepic", Root_URL];
    [manage GET:requestURL parameters:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *arrPic = responseObject;
        [self requestData:arrPic];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //未登录处理
//        [self showDefaultView];
    }];
}

- (NSInteger)getCurrentTime{
    NSDateFormatter *formatter =[[NSDateFormatter alloc] init] ;
    [formatter setTimeStyle:NSDateFormatterMediumStyle];
    NSDate *date = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSInteger unitFlags = NSCalendarUnitYear |
    NSCalendarUnitMonth |
    NSCalendarUnitDay |
    NSCalendarUnitHour |
    NSCalendarUnitMinute |
    NSCalendarUnitSecond;
    NSDateComponents * comps = [calendar components:unitFlags fromDate:date];
    int hour = (int)[comps hour];
    return hour;
}

- (void)requestData:(NSArray *)data {
//    if (data.count == 0) {
//        [self showDefaultView];
//    }
    
    for (NSMutableDictionary *oneTurns in data) {
        SharePicModel *sharePic = [[SharePicModel alloc] init];
        [sharePic setValuesForKeysWithDictionary:oneTurns];
        
        [self.dataArr addObject:sharePic];
    }
    
    [self.picCollectionView reloadData];
}

#pragma mark --collection的代理方法
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.dataArr.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    SharePicModel *picModel = self.dataArr[section];
    return picModel.pic_arry.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PicCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"picCollectionCell" forIndexPath:indexPath];
    SharePicModel *picModel = self.dataArr[indexPath.section];
    [cell createImageForCellImageView:picModel.pic_arry[indexPath.row]];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(CELLWIDTH, CELLWIDTH);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    //图片查看
    PicCollectionViewCell *cell = (PicCollectionViewCell *)[self.picCollectionView cellForItemAtIndexPath:indexPath];
    
    //取到当前数组
    SharePicModel *picModel = self.dataArr[indexPath.section];
    self.photoView.picArr = [picModel.pic_arry mutableCopy];
    self.photoView.index = indexPath.row;

    [self.photoView createScrollView];
    [self.photoView fillData:indexPath.row cellFrame:cell.frame];
    [[[UIApplication sharedApplication].delegate window]addSubview:self.photoView];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (kind == UICollectionElementKindSectionHeader) {
        //返回页眉
        PicHeaderCollectionReusableView *headerV = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"picHeader" forIndexPath:indexPath];
        SharePicModel *picModel = self.dataArr[indexPath.section];
        headerV.timeLabel.text = [self turnsTime:picModel.start_time];
        headerV.propagandaLabel.text = picModel.title;
        NSString *name = [NSString stringWithFormat:@"%dlun", [picModel.turns_num intValue] - 1];
        headerV.turnsImageView.image = [UIImage imageNamed:name];
        return headerV;
        
    }else{
        PicFooterCollectionReusableView *footerV = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"picFooter" forIndexPath:indexPath];
        SharePicModel *picModel = self.dataArr[indexPath.section];
        if ([picModel.could_share intValue]) {
            footerV.savePhotoBtn.tag = 100 + indexPath.section;
            
            [footerV.savePhotoBtn addTarget:self action:@selector(tapSaveImageToIphone:currentPicArr:) forControlEvents:UIControlEventTouchUpInside];
            return footerV;
        }else {
            footerV.savePhotoBtn.enabled = NO;
            return footerV;
        }
       
    }

}

- (NSString *)turnsTime:(NSString *)timeStr {
    NSMutableString *timestext= [NSMutableString stringWithString:timeStr];
    NSRange range;
    range = [timestext rangeOfString:@"T"];
    [timestext replaceCharactersInRange:range withString:@" "];
    
    range = NSMakeRange(0, 10);
    [timestext deleteCharactersInRange:range];
    range = NSMakeRange(timestext.length - 4, 3);
    [timestext deleteCharactersInRange:range];
    return timestext;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake([UIScreen mainScreen].bounds.size.width, 58);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeMake([UIScreen mainScreen].bounds.size.width, 54);
}

#pragma mark --保存事件
- (void)tapSaveImageToIphone:(UIButton *)sender
               currentPicArr:(NSMutableArray *)currentPicArr {
    
    NSInteger saveIndex = sender.tag - 100;
    self.saveIndex = saveIndex;
    SharePicModel *picModel = self.dataArr[saveIndex];
    
    UIPasteboard *pab = [UIPasteboard generalPasteboard];
    NSString *str = picModel.title;
    [pab setString:str];
    if (pab == nil) {
        [SVProgressHUD showErrorWithStatus:@"请重写复制"];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"已复制，图片正在保存" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    }
    if (self.currentArr == nil) {
        self.currentArr = [picModel.pic_arry mutableCopy];
        [self saveNext];
    }else if (self.currentArr.count > 0){
        [self.currentArr addObjectsFromArray:picModel.pic_arry];
    }else {
        [self.currentArr addObjectsFromArray:picModel.pic_arry];
        [self saveNext];
    }

}

- (void)saveNext {
    if (self.currentArr.count > 0) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_BLOCK_DETACHED, 0), ^{
            NSString *joinUrl = [NSString stringWithFormat:@"%@?imageMogr2/thumbnail/289/format/jpg/quality/90", self.currentArr[0]];
            UIImageWriteToSavedPhotosAlbum([UIImage imagewithURLString:joinUrl], self, @selector(savedPhotoImage:didFinishSavingWithError:contextInfo:), nil);
        });
    }else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"已存入手机相册" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    }
}

-(void)savedPhotoImage:(UIImage*)image didFinishSavingWithError: (NSError *)error contextInfo: (void *)contextInfo {
    if (error) {
//        NSLog(@"%@", error.localizedDescription);
    }else {
        [self.currentArr removeObjectAtIndex:0];
    }
    [self saveNext];
}

#pragma mark -- scrollView代理
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.photoView.contentOffY = scrollView.contentOffset.y;
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
