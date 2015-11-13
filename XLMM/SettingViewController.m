//
//  SettingViewController.m
//  XLMM
//
//  Created by younishijie on 15/10/22.
//  Copyright © 2015年 上海己美. All rights reserved.
//

#import "SettingViewController.h"
#import "MMClass.h"
#import "UIViewController+NavigationBar.h"
#import "AddressViewController.h"
#import "ModifyPasswordViewController.h"
#import "ModifyPhoneController.h"
#import "UIImageView+WebCache.h"

@interface SettingViewController ()

@end

@implementation SettingViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
    
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self createNavigationBarWithTitle:@"设置" selecotr:@selector(backClicked:)];
    self.deleteButton.layer.borderWidth = 1;
    self.deleteButton.layer.borderColor = [UIColor colorWithR:245 G:166 B:35 alpha:1].CGColor;
    self.deleteButton.layer.cornerRadius = 13;
    self.quitBUtton.layer.cornerRadius = 20;
    self.quitBUtton.layer.borderWidth = 1;
    self.quitBUtton.layer.borderColor = [UIColor buttonBorderColor].CGColor;
    
    NSString * path = [NSHomeDirectory() stringByAppendingString:@"/Library/Caches/default/com.hackemist.SDWebImageCache.default"];
    NSLog(@"path = %@", path);
    NSDictionary * dict = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil];
    NSLog(@"%@",[dict objectForKey:NSFileSize]);
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachesDir = [paths objectAtIndex:0];
    
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:path]){
        
     
        
        
        NSLog(@"%llu",  [[manager attributesOfItemAtPath:cachesDir error:nil] fileSize]);
    }

    NSLog(@"caches = %@", cachesDir);
    //清空缓存
   // [self clearTmpPics];
    
}

- (void)clearTmpPics
{
    [[SDImageCache sharedImageCache] clearDisk];
    
    //    [[SDImageCache sharedImageCache] clearMemory];//可有可无
    
//DLog(@"clear disk");
    
//    float tmpSize = [[SDImageCache sharedImageCache] checkTmpSize];
//    
//    NSString *clearCacheName = tmpSize >= 1 ? [NSString stringWithFormat:@"清理缓存(%.2fM)",tmpSize] : [NSString stringWithFormat:@"清理缓存(%.2fK)",tmpSize * 1024];
//    
//    [configDataArray replaceObjectAtIndex:2 withObject:clearCacheName];
//    
//    [configTableView reloadData];
}


///计算缓存文件的大小的M
//- (float ) folderSizeAtPath:(NSString*) folderPath{
//    NSFileManager* manager = [NSFileManager defaultManager];
//    if (![manager fileExistsAtPath:folderPath]) return 0;
//    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];//从前向后枚举器／／／／//
//    NSString* fileName;
//    long long folderSize = 0;
//    while ((fileName = [childFilesEnumerator nextObject]) != nil){
//        NSLog(@"fileName ==== %@",fileName);
//        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
//        NSLog(@"fileAbsolutePath ==== %@",fileAbsolutePath);
//        folderSize += [self fileSizeAtPath:fileAbsolutePath];
//    }
//    NSLog(@"folderSize ==== %lld",folderSize);
//    return folderSize/(1024.0*1024.0);
//}
////////////
-(void)ss{
    // 获取Caches目录路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachesDir = [paths objectAtIndex:0];
    
    NSLog(@"cachesDircachesDir == %@",cachesDir);
    //读取缓存里面的具体单个文件/或全部文件//
    NSString *filePath = [cachesDir stringByAppendingPathComponent:@"com.nickcheng.NCMusicEngine"];
    NSArray *array = [[NSArray alloc]initWithContentsOfFile:filePath];
    NSLog(@"filePathfilePath%@ ==array==== %@",filePath, array);
    
    
    NSFileManager* fm=[NSFileManager defaultManager];
    if([fm fileExistsAtPath:filePath]){
        //取得一个目录下得所有文件名
        NSArray *files = [fm subpathsAtPath:filePath];
        NSLog(@"files1111111%@ == %ld",files,files.count);
        
        // 获得文件名（不带后缀）
        NSString * exestr = [[files objectAtIndex:1] stringByDeletingPathExtension];
        NSLog(@"files2222222%@  ==== %@",[files objectAtIndex:1],exestr);
    }
    
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

- (IBAction)nickButtonClicked:(id)sender {
    NSLog(@"用户昵称");
}

- (IBAction)phoneButtonClicked:(id)sender {
    NSLog(@"手机号");
    ModifyPhoneController *modifyVC = [[ModifyPhoneController alloc] initWithNibName:@"ModifyPhoneController" bundle:nil];
    [self.navigationController pushViewController:modifyVC animated:YES];
    
    

}

- (IBAction)modifyButtonClicked:(id)sender {
    NSLog(@"修改密码");
    ModifyPasswordViewController *modifyVC = [[ModifyPasswordViewController alloc] init];
    [self.navigationController pushViewController:modifyVC animated:YES];
    
    
}

- (IBAction)addressButtonClicked:(id)sender {
    NSLog(@"地址管理");
    AddressViewController *addressVC = [[AddressViewController alloc] initWithNibName:@"AddressViewController" bundle:nil];
    [self.navigationController pushViewController:addressVC animated:YES];
    
}

- (IBAction)versionButtonClicked:(id)sender {
    NSLog(@"版本号");
}

- (IBAction)deleteButtonClicked:(id)sender {
    NSLog(@"清除缓存");
}

- (IBAction)quitButtonClicked:(id)sender {
    NSLog(@"退出");
    [self.navigationController popViewControllerAnimated:YES];
    
}
@end
