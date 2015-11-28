//
//  ChiMaBiaoViewController.m
//  XLMM
//
//  Created by younishijie on 15/11/10.
//  Copyright © 2015年 上海己美. All rights reserved.
//

#import "ChiMaBiaoViewController.h"
#import "UIViewController+NavigationBar.h"
#import "MMClass.h"

@interface ChiMaBiaoViewController (){
    UIView *sizeView0;
}

@end




@implementation ChiMaBiaoViewController

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
        [self createNavigationBarWithTitle:@"尺码表" selecotr:@selector(backClicked:)];
        
    }
    return self;
    
}

- (void)backClicked:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSLog(@"%@", self.sizeArray);
    
    [self createSizeTable];
    if (self.isChildClothing) {
        
    } else {
        self.head1Label.hidden = YES;
        self.head2Llabel.hidden = YES;
    }
    
}


- (void)createSizeTable{
    
    
    sizeView0 = [[UIView alloc] init];
    sizeView0.frame = CGRectMake(0, 150, SCREENWIDTH, (self.sizeArray.count +1) * 31);
    sizeView0.backgroundColor = [UIColor whiteColor];
    
        NSInteger width = 0;
        NSInteger height;
       NSMutableArray * mutableSize = [[NSMutableArray alloc] initWithCapacity:5];
       NSMutableArray * mutableSizeName = [[NSMutableArray alloc] initWithCapacity:5];
        if (self.sizeArray.count != 0) {
    
    
            height = self.sizeArray.count;
        }
        for (NSDictionary *dic in self.sizeArray) {
            // NSLog(@"dic = %@", dic);
    
            id object = [[dic objectForKey:@"size_of_sku"] objectForKey:@"result"];
            if ([object isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dic2 = (NSDictionary *)object;
                [mutableSize addObject:dic2];
                [mutableSizeName addObject:[dic objectForKey:@"name"]];
                NSInteger result = dic2.count;
                NSInteger max = 10;
                if (result > max) {
                    result = max;
                }
    
                width = result;
    
                NSLog(@"result = %ld", (long)result);
                self.noHaveLabel.hidden = YES;
            } else {
                self.noHaveLabel.hidden = NO;
                sizeView0.hidden = YES;
            }
    
        }
      CGFloat labelWidth = SCREENWIDTH / (width + 1);
        CGFloat labelHeight = 30.0;
        NSArray *keysArray;
        if (mutableSize.count != 0) {
            NSDictionary *result = [mutableSize objectAtIndex:0];
            keysArray = [result allKeys];
        }
        NSLog(@"keysArray = %@", keysArray);
    NSMutableArray * orderKeyArray  = [[NSMutableArray alloc] init];
    NSArray *allSizeKeys =  @[@"领围",@"肩宽",@"胸围",@"袖长",
                              @"插肩袖",@"袖口",@"腰围",
                              @"衣长",@"裙腰",@"裤腰",
                              @"臀围",@"下摆围",@"下摆宽",@"前档",
                              @"后档",@"大腿围",@"小腿围",
                              @"脚口",@"裙长",@"裤长",
                              @"建议身高"];
    
        for (NSString *key1 in allSizeKeys) {
            for (NSString *key2 in keysArray) {
                if ([key1 isEqualToString:key2]) {
                    [orderKeyArray addObject:key2];
                }
            }
        }
        NSLog(@"orderKey = %@", orderKeyArray);
    
    
        NSLog(@"mutable = %@", mutableSize);
    
        NSLog(@"mutable = %@", mutableSizeName);
    
    
    
    
        UIView *headview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENHEIGHT, 31)];
        [sizeView0 addSubview:headview];
    
    
        headview.backgroundColor = [UIColor colorWithR:74 G:74 B:74 alpha:1];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, labelWidth, labelHeight)];
        //[label sizeToFit];
      //  label.backgroundColor = [UIColor redColor];
        label.text = @"尺码";
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:12];
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 0;
        [headview addSubview:label];
        for (int i = 0; i< width; i++) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(labelWidth * i + labelWidth, 0, labelWidth, labelHeight)];
            //[label sizeToFit];
            //  label.backgroundColor = [UIColor redColor];
            label.text = [orderKeyArray objectAtIndex:i];
            label.textColor = [UIColor whiteColor];
            label.font = [UIFont systemFontOfSize:12];
            label.textAlignment = NSTextAlignmentCenter;
            label.numberOfLines = 0;
    
            [headview addSubview:label];
        }
     //   CGFloat sizeViewWidth;
        CGFloat sizeViewHeight = 31;
    
    
        for (int i = 0; i < mutableSize.count; i++) {
            UIView *sizeView = [[UIView alloc] initWithFrame:CGRectMake(0, sizeViewHeight *i + sizeViewHeight, SCREENWIDTH, sizeViewHeight)];
            sizeView.tag = 600 + i;
            sizeView.backgroundColor = [UIColor whiteColor];
    
            if (i == mutableSize.count -1) {
                UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, sizeViewHeight - 1, SCREENWIDTH, 1)];
                line.backgroundColor = [UIColor colorWithR:222 G:223 B:224 alpha:1];
                [sizeView addSubview:line];
            } else {
                UIView *line = [[UIView alloc] initWithFrame:CGRectMake(8, sizeViewHeight - 1, SCREENWIDTH - 16, 1)];
                line.backgroundColor = [UIColor colorWithR:222 G:223 B:224 alpha:1];
                [sizeView addSubview:line];
            }
    
    
    
            [sizeView0 addSubview:sizeView];
        }
        for (int i = 0; i < mutableSize.count; i++) {
            UIView *sizeView = [sizeView0 viewWithTag:(i + 600)];
    
    
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, labelWidth, labelHeight)];
            //[label sizeToFit];
            //  label.backgroundColor = [UIColor redColor];
            label.text = [mutableSizeName objectAtIndex:i];
            label.textColor = [UIColor colorWithR:74 G:74 B:74 alpha:1];
            label.font = [UIFont systemFontOfSize:12];
            label.textAlignment = NSTextAlignmentCenter;
            label.numberOfLines = 0;
            [sizeView addSubview:label];
            for (int j = 0; j< width; j++) {
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(labelWidth * j + labelWidth, 0, labelWidth, labelHeight)];
                //[label sizeToFit];
                //  label.backgroundColor = [UIColor redColor];
                label.text = [[mutableSize objectAtIndex:i] objectForKey:[orderKeyArray objectAtIndex:j]];
                label.textColor = [UIColor colorWithR:74 G:74 B:74 alpha:1];
                label.font = [UIFont systemFontOfSize:9];
                label.textAlignment = NSTextAlignmentCenter;
                label.numberOfLines = 0;
    
                [sizeView addSubview:label];
            }
            
            
        }
    
    [self.view addSubview:sizeView0];
    
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
