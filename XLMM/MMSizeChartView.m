//
//  MMSizeChartView.m
//  CustomSizeView2
//
//  Created by younishijie on 15/10/21.
//  Copyright © 2015年 上海己美网络科技有限公司. All rights reserved.
//

#import "MMSizeChartView.h"

#define SizeNameFontSize 12
#define KeyNameFontSize SizeNameFontSize
#define DescriptionFontSize 10

#define SizeLabelHeight 24
#define BorderWidth 0.25

@interface MMSizeChartView()
{
    
}

@property (nonatomic, strong)NSMutableArray *sizeArray;
@property (nonatomic, strong)NSMutableArray *nameArray;
@property (nonatomic, strong)NSArray *keysArray;

@property (nonatomic, strong)NSMutableArray *widthArray;
@property (nonatomic, strong)UIScrollView *scrollView;

@end

@implementation MMSizeChartView


- (instancetype)initWithFrame:(CGRect)frame andArray:(NSArray *)array{
    self = [super initWithFrame:frame];
    if (self) {
        self.dataArray = array;
        NSLog(@"初始化View");
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    self.widthArray = [[NSMutableArray alloc] initWithCapacity:0];
    NSLog(@"自定义尺码表。。。");
    [self prepareData];
    if (self.keysArray.count == 0) {
        NSLog(@"未录入尺码表");
        return;
    }
    [self createNameLabel];
    [self createSizeTable];
    [self addSubview:self.scrollView];
    self.scrollView.alwaysBounceHorizontal = YES;
    NSLog(@"scrollView = %@", self.scrollView);
    
}



- (void)createSizeTable{
    for (int i = 0; i < self.keysArray.count; i++) {
        NSString *key = [self.keysArray objectAtIndex:i];
        NSLog(@"key = %@", key);
        CGFloat originX = 0;
        for (NSNumber *number in self.widthArray) {
            CGFloat width = [number floatValue];
            NSLog(@"width = %.02f", width);
            originX += width;
        }
        NSLog(@"originX = %f", originX);
        [self createSizeLabelWithKey:key andOriginX:originX];
        
    }
    
    NSLog(@"self.widthArray = %@", self.widthArray);
    
    CGFloat sumWidth = 0;
    for (NSNumber *number in self.widthArray) {
        sumWidth += [number floatValue];
    }
    NSLog(@"sumwidth = %f", sumWidth);
    
    
    
    self.scrollView.contentSize = CGSizeMake(sumWidth, (self.nameArray.count +1) * SizeLabelHeight);
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.scrollView.contentSize.width, self.scrollView.contentSize.height)];
    [self addSubview:view];
    view.layer.borderWidth = 0.5;
    view.layer.borderColor = [UIColor darkGrayColor].CGColor;
    
    [self sendSubviewToBack:view];
    
    
    self.scrollView.bounces = NO;
}
- (void)createSizeLabelWithKey:(NSString *)key andOriginX:(CGFloat)x{
    //确定width
    CGFloat width = 0;
    
    NSDictionary *attributes = @{
                                 NSForegroundColorAttributeName:[UIColor grayColor],
                                 NSFontAttributeName:[UIFont systemFontOfSize:DescriptionFontSize]
                                 };
    
    NSDictionary *keyAttributes = @{
                                    NSForegroundColorAttributeName:[UIColor grayColor],
                                    NSFontAttributeName:[UIFont systemFontOfSize:KeyNameFontSize]
                                    };
    
    NSAttributedString *attrs = [[NSAttributedString alloc] initWithString:key attributes:keyAttributes];
    
    width = attrs.size.width;
    NSLog(@"key = %@", key);
    NSLog(@"width = %.02f", width);
    for (NSDictionary *dic in self.sizeArray) {
        NSString *desc = [dic objectForKey:key];
        NSLog(@"desc = %@", desc);
        NSAttributedString *descAttrs = [[NSAttributedString alloc] initWithString:desc attributes:attributes];
        if (descAttrs.size.width > width) {
            width = descAttrs.size.width;
            NSLog(@"width = %.02f", width);
        }
    }
    width = ceilf(width);
    NSLog(@"width = %.02f", width);
    width = width * 1.2;
    NSLog(@"width = %.02f", width);
    [self.widthArray addObject:[NSNumber numberWithFloat:width]];
    NSLog(@"self.widthArray = %@", self.widthArray);
    
    
    //创建keyLabel。。
    
    NSAttributedString *keyAttrs = [[NSAttributedString alloc] initWithString:key attributes:keyAttributes];
    
    UILabel *keyLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, 0, width, SizeLabelHeight)];
    keyLabel.textAlignment = NSTextAlignmentCenter;
    keyLabel.attributedText = keyAttrs;
    [self.scrollView addSubview:keyLabel];
    
    keyLabel.layer.borderWidth = BorderWidth;
    keyLabel.layer.borderColor = [UIColor darkGrayColor].CGColor;
    
    
    //创建sizelabel
    
    
    NSLog(@"OriginX = %f", x);
    for (int i = 0; i < self.sizeArray.count; i++) {
        NSDictionary *dic = [self.sizeArray objectAtIndex:i];
        NSString *desc = [dic objectForKey:key];
        NSLog(@"desc = %@", desc);
        NSAttributedString *descAttrs = [[NSAttributedString alloc] initWithString:desc attributes:attributes];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(x, (i+1)*SizeLabelHeight, width, SizeLabelHeight)];
        label.attributedText = descAttrs;
        label.textAlignment = NSTextAlignmentCenter;
        [self.scrollView addSubview:label];
        label.layer.borderWidth = BorderWidth;
        label.layer.borderColor = [UIColor darkGrayColor].CGColor;
        
        
    }
    
    
    
}

- (void)createNameLabel{
    NSDictionary *attributs = @{
                                NSForegroundColorAttributeName:[UIColor grayColor],
                                NSFontAttributeName:[UIFont systemFontOfSize:SizeNameFontSize]
                                };
    
    CGFloat width = 36;
    //确定label 的width；
    for (int i = 0; i < self.nameArray.count; i++) {
        NSString *name = [self.nameArray objectAtIndex:i];
        
        NSAttributedString *attrs =
        [[NSAttributedString alloc] initWithString:name
                                        attributes:attributs];
        CGSize size = [attrs size];
        if (size.width > width) {
            width = size.width;
            NSLog(@"width = %.02f", width);
        }
        
    }
    width = ceilf(width);
    width *= 1.2;
    
    [self.widthArray addObject:[NSNumber numberWithFloat:width]];
    NSLog(@"self.widthArray = %@", self.widthArray);
    NSLog(@"width = %f", width);
    
    //创建第一行
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, SizeLabelHeight)];
    label.text = @"尺码";
    label.textColor = [UIColor grayColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:SizeNameFontSize];
    // label.backgroundColor = [UIColor orangeColor];
    [self.scrollView addSubview:label];
    label.layer.borderWidth = BorderWidth;
    label.layer.borderColor = [UIColor darkGrayColor].CGColor;
    //创建label
    for (int i = 0; i < self.nameArray.count; i++) {
        NSString *name = [self.nameArray objectAtIndex:i];
        NSLog(@"name = %@", name);
        
        NSAttributedString *arrts = [[NSAttributedString alloc] initWithString:name attributes:attributs];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, (i+1)*SizeLabelHeight, width, SizeLabelHeight)];
        label.attributedText = arrts;
        label.font = [UIFont systemFontOfSize:SizeNameFontSize];
        label.textAlignment = NSTextAlignmentCenter;
        [self.scrollView addSubview:label];
        // label.backgroundColor = [UIColor orangeColor];
        label.layer.borderWidth = BorderWidth;
        label.layer.borderColor = [UIColor darkGrayColor].CGColor;
    }
    
    
    
}

- (void)prepareData{
    NSArray * allSizeKeys = @[@"领围",
                              @"肩宽",
                              @"胸围",
                              @"袖长",
                              @"插肩袖",
                              @"袖口",
                              @"腰围",
                              @"衣长",
                              @"裙腰",
                              @"裤腰",
                              @"臀围",
                              @"下摆围",
                              @"前档",
                              @"后档",
                              @"大腿围",
                              @"小腿围",
                              @"脚口",
                              @"裙长",
                              @"裤长",
                              @"建议身高"
                              ];
    NSLog(@"array = %@", self.dataArray);
    
    
    self.sizeArray = [[NSMutableArray alloc] init];
    self.nameArray = [[NSMutableArray alloc] init];
    for (NSDictionary *dic in self.dataArray) {
        NSDictionary *result = [[dic objectForKey:@"size_of_sku"] objectForKey:@"result"];
        [self.sizeArray addObject:result];
        [self.nameArray addObject:[dic objectForKey:@"name"]];
        if ([result isKindOfClass:[NSDictionary class]]) {
            self.keysArray = [result allKeys];
        } else {
            self.keysArray = nil;
        }
        
    }
    NSLog(@"self.sizeArray = %@", self.sizeArray);
    NSLog(@"self.nameArray = %@", self.nameArray);
    NSLog(@"self.keysArray = %@", self.keysArray);
    
    NSMutableArray *mutable = [[NSMutableArray alloc] initWithCapacity:0];
    for (NSString *key1 in allSizeKeys) {
        for (NSString *key2 in self.keysArray) {
            if ([key1 isEqualToString:key2]) {
                [mutable addObject:key2];
            }
        }
    }
    self.keysArray = mutable;
     NSLog(@"self.keysArray = %@", self.keysArray);
}





@end
