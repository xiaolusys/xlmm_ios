//
//  ActivityErweimaViewController.m
//  XLMM
//
//  Created by younishijie on 16/1/22.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "ActivityErweimaViewController.h"
#import "MMClass.h"
#import "WXApi.h"



@interface ActivityErweimaViewController ()

@end

@implementation ActivityErweimaViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [MobClick beginLogPageView:@"ActivityErweimaViewController"];
    
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
    [MobClick endLogPageView:@"ActivityErweimaViewController"];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self createNavigationBarWithTitle:@"活动二维码" selecotr:@selector(backClicked:)];
    self.saveButton.layer.cornerRadius = 15;
    self.saveButton.layer.borderWidth = 1;
    self.saveButton.layer.borderColor = [UIColor buttonEmptyBorderColor].CGColor;
    
    self.shareButton.layer.cornerRadius = 15;
    self.shareButton.layer.borderWidth = 1;
    self.shareButton.layer.borderColor = [UIColor buttonEmptyBorderColor].CGColor;
    
    
    
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

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    
    if (error == nil) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"已存入手机相册" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        
    }else{
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"保存失败" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    }
    
}

- (IBAction)saveClicked:(id)sender {
    NSLog(@"save");
    NSLog(@"save");
    
    UIImageWriteToSavedPhotosAlbum(self.imageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);

}

- (IBAction)shareClicked:(id)sender {
    NSLog(@"share");
    
    
    WXMediaMessage *message = [WXMediaMessage message];
    
    WXImageObject *ext = [WXImageObject object];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"erweimaDemo" ofType:@"png"];
    ext.imageData = [NSData dataWithContentsOfFile:filePath];
    UIImage* image = [UIImage imageWithData:ext.imageData];
    ext.imageData = UIImagePNGRepresentation(image);
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = 1;
    
    [WXApi sendReq:req];

}
@end
