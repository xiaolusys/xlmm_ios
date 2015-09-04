//
//  MMDetailsViewController.m
//  XLMM
//
//  Created by younishijie on 15/9/2.
//  Copyright (c) 2015年 上海己美. All rights reserved.
//

#import "MMDetailsViewController.h"
#import "UIImageView+WebCache.h"

@interface MMDetailsViewController (){
    
}

@property (weak, nonatomic) IBOutlet UIImageView *imageview1;

@property (weak, nonatomic) IBOutlet UIImageView *imageView2;

@property (weak, nonatomic) IBOutlet UIImageView *imageView3;

@property (weak, nonatomic) IBOutlet UIImageView *imageView4;

@end

@implementation MMDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"商品详情";
    NSLog(@"%@", self.urlString);
    
    [self.imageview1 sd_setImageWithURL:[NSURL URLWithString:@"http://image.xiaolu.so/kexuanchima.png"]];
    [self.imageView2 sd_setImageWithURL:[NSURL URLWithString:@"http://image.xiaolu.so/xuanchuan.png"]];
    [self.imageView3 sd_setImageWithURL:[NSURL URLWithString:@"http://image.xiaolu.so/shangpincanshu.png"]];
    [self.imageView4 sd_setImageWithURL:[NSURL URLWithString:@"http://image.xiaolu.so/chimabiao.png"]];
    
    
    
     [self downloadData];
}
//  http://image.xiaolu.so/kexuanchima.png

//   http://image.xiaolu.so/xuanchuan.png

//    http://image.xiaolu.so/shangpincanshu.png

//    http://image.xiaolu.so/chimabiao.png

- (void)downloadData{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:_urlString]];
        [self performSelectorOnMainThread:@selector(fetchedCollectionData:)withObject:data waitUntilDone:YES];
        
    });
    
}
- (void)fetchedCollectionData:(NSData *)data{
    if (data == nil) {
        NSLog(@"urlstring = %@", _urlString);
        NSLog(@"集合页面数据下载失败");
    }
    NSError *error;
   // [self.dataArray removeAllObjects];
    NSArray *collections = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    
    NSLog(@"collections = %@", collections);
   
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
