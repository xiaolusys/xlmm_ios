//
//  DetailViewController.m
//  XLMM
//
//  Created by younishijie on 15/8/4.
//  Copyright (c) 2015年 上海己美. All rights reserved.
//

#import "DetailViewController.h"
#import "UIImageView+WebCache.h"
#import "MMClass.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBarHidden = NO;
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[self.contentImageUrlArray objectAtIndex:1]]]];
    self.imageWidth.constant = SCREENWIDTH;
    self.imageHeight.constant = image.size.height *SCREENWIDTH/600;
    [self.imageView sd_setImageWithURL:[self.contentImageUrlArray objectAtIndex:1]];
    
    NSLog(@"%@\n, %@", self.headImageUrlArray, self.contentImageUrlArray);
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
