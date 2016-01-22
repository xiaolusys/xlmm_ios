//
//  TuijianErweimaViewController.m
//  XLMM
//
//  Created by younishijie on 16/1/21.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "TuijianErweimaViewController.h"
#import "UIViewController+NavigationBar.h"
#import "WXApi.h"
#import "MMClass.h"



@interface TuijianErweimaViewController ()

@end

@implementation TuijianErweimaViewController{
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
    self.title = @"二维码";
    UIImage * image = [UIImage imageNamed:@"erweimaDemo.png"];
    self.imageView.image = image;
    [self downloadImage];
    
}

- (void)downloadImage{
    NSString *imagelink = [NSString stringWithFormat:@"%@%@", Root_URL, self.imagelink];
    NSLog(@"imagelink = %@", imagelink);
   // imagelink = @"http://192.168.1.31:9000/media/mm/coupon.png";
    UIImage *image = [UIImage imagewithURLString:imagelink];
    NSLog(@"image = %@", image);
    NSError *error = nil;
    
    NSURL *url = [NSURL URLWithString:imagelink];
    NSData *data = [NSData dataWithContentsOfURL:url options:NSDataReadingMapped error:&error];
    if (error == nil) {
        NSLog(@"data = %@", data);
    } else{
        NSLog(@"error = %@", error);
    }
    image = [UIImage imageWithData:data];
    self.imageView.image = image;
    
    
    
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

- (IBAction)saveImage:(id)sender {
    NSLog(@"save");
    
     UIImageWriteToSavedPhotosAlbum(self.imageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

- (IBAction)shareImage:(id)sender {
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
