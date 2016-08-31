//
//  JMPopMenuView.m
//  XLMM
//
//  Created by zhang on 16/8/30.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMPopMenuView.h"

#define JMKeyWindow [UIApplication sharedApplication].keyWindow

@interface JMPopMenuView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, copy) void(^indexBlock)(NSInteger index);

@property (nonatomic, strong) NSArray *imageArr;
@property (nonatomic, strong) NSArray *titleArr;
@property (nonatomic, assign) BOOL animation;
@property (nonatomic, assign) NSTimeInterval show;
@property (nonatomic, assign) NSTimeInterval hide;

@end

static JMPopMenuView *backgroundView;
static UITableView *jm_tableView;
static CGRect jm_frame;
static CGPoint jm_anchorPoint;

@implementation JMPopMenuView
/**
 *  @param frame       指定tableView的位置
 *  @param imageArr    图片数组
 *  @param titleArr    文字数组
 *  @param anchorPoint tableView动画的锚点
 *  @param indexBlock  回调菜单中被选中的index
 *  @param animation   是否显示动画
 *  @param show        菜单显示动画
 *  @param hide        菜单消失动画
 */
+ (void)configCustomPopMenuWithFrame:(CGRect)frame ImageArr:(NSArray *)imageArr TitleArr:(NSArray *)titleArr AnchorPoint:(CGPoint)anchorPoint selectedRowIndex:(void(^)(NSInteger index))indexBlock Animation:(BOOL)animation ShowTime:(NSTimeInterval)show hideTime:(NSTimeInterval)hide {
    jm_frame = frame;
    jm_anchorPoint = anchorPoint;
    if (backgroundView) {
        [JMPopMenuView hideView];
        return ;
    }
    backgroundView = [[JMPopMenuView alloc] initWithFrame:JMKeyWindow.bounds];
    backgroundView.indexBlock = indexBlock;
    backgroundView.titleArr = titleArr;
    backgroundView.animation = animation;
    backgroundView.show = show;
    backgroundView.hide = hide;
    backgroundView.backgroundColor = [UIColor blackColor];
    backgroundView.alpha = 0.1f;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:backgroundView action:@selector(dismissView)];
    [backgroundView addGestureRecognizer:tap];
    [JMKeyWindow addSubview:backgroundView];
    
    jm_tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    jm_tableView.delegate = backgroundView;
    jm_tableView.dataSource = backgroundView;
    //    jm_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    jm_tableView.layer.anchorPoint = anchorPoint;
    //根据锚点位置来确定position
    if (anchorPoint.x == 0 && anchorPoint.y == 0) jm_tableView.layer.position = CGPointMake(jm_frame.origin.x, jm_frame.origin.y);
    if (anchorPoint.x == 0 && anchorPoint.y == 0.5) jm_tableView.layer.position = CGPointMake(jm_frame.origin.x, jm_frame.origin.y + jm_frame.size.height / 2.0);
    if (anchorPoint.x == 0 && anchorPoint.y == 1) jm_tableView.layer.position = CGPointMake(jm_frame.origin.x, jm_frame.origin.y + jm_frame.size.height);
    if (anchorPoint.x == 0.5 && anchorPoint.y == 0) jm_tableView.layer.position = CGPointMake(jm_frame.origin.x + jm_frame.size.width / 2.0, jm_frame.origin.y);
    if (anchorPoint.x == 0.5 && anchorPoint.y == 1) jm_tableView.layer.position = CGPointMake(jm_frame.origin.x + jm_frame.size.width / 2.0, jm_frame.origin.y + jm_frame.size.height);
    if (anchorPoint.x == 1 && anchorPoint.y == 0) jm_tableView.layer.position = CGPointMake(jm_frame.origin.x + jm_frame.size.width, jm_frame.origin.y);
    if (anchorPoint.x == 1 && anchorPoint.y == 0.5) jm_tableView.layer.position = CGPointMake(jm_frame.origin.x + jm_frame.size.width, jm_frame.origin.y + jm_frame.size.height / 2.0);
    if (anchorPoint.x == 1 && anchorPoint.y == 1) jm_tableView.layer.position = CGPointMake(jm_frame.origin.x + jm_frame.size.width, jm_frame.origin.y + jm_frame.size.height);
    jm_tableView.layer.cornerRadius = 10;
    jm_tableView.transform = CGAffineTransformMakeScale(0.00001, 0.00001);
    
    if (animation) {
        [UIView animateWithDuration:show animations:^{
            jm_tableView.transform = CGAffineTransformMakeScale(1.0, 1.0);
        }];
    }
    [JMKeyWindow addSubview:jm_tableView];

}
+ (void)hideView {
    if (backgroundView.animation) {
        backgroundView.alpha = 0;
        [UIView animateWithDuration:backgroundView.hide animations:^{
            jm_tableView.transform = CGAffineTransformMakeScale(0.00001, 0.00001);
        } completion:^(BOOL finished) {
            [backgroundView removeFromSuperview];
            backgroundView = nil;
            [jm_tableView removeFromSuperview];
            jm_tableView = nil;
        }];
    }
}
- (void)dismissView {
    if (backgroundView) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"hideSelectedPopView" object:nil];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifile = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifile];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifile];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.imageView.image = [UIImage imageNamed:self.imageArr[indexPath.row]];
    cell.textLabel.text = self.titleArr[indexPath.row];
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titleArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return jm_tableView.frame.size.height / self.titleArr.count;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (backgroundView.indexBlock) {
        //利用block回调 确定选中的row
        self.indexBlock(indexPath.row);
        [JMPopMenuView hideView];
    }
}

- (void)drawRect:(CGRect)rect {
    [[UIColor whiteColor] set];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextBeginPath(context);
    //根据锚点位置 绘制三角
    if (jm_anchorPoint.x == 0 && jm_anchorPoint.y == 0) {
        CGContextMoveToPoint(context, jm_frame.origin.x + 12, jm_frame.origin.y);
        CGContextAddLineToPoint(context, jm_frame.origin.x + 10, jm_frame.origin.y - 15);
        CGContextAddLineToPoint(context, jm_frame.origin.x + 30, jm_frame.origin.y);
    }
    if (jm_anchorPoint.x == 0 && jm_anchorPoint.y == 0.5) {
        CGContextMoveToPoint(context, jm_frame.origin.x, jm_frame.origin.y  + jm_frame.size.height / 2.0 - 13);
        CGContextAddLineToPoint(context, jm_frame.origin.x, jm_frame.origin.y + jm_frame.size.height / 2.0 + 13);
        CGContextAddLineToPoint(context, jm_frame.origin.x - 15, jm_frame.origin.y  + jm_frame.size.height / 2.0);
    }
    if (jm_anchorPoint.x == 0 && jm_anchorPoint.y == 1) {
        CGContextMoveToPoint(context, jm_frame.origin.x + 12, jm_frame.origin.y  + jm_frame.size.height);
        CGContextAddLineToPoint(context, jm_frame.origin.x + 30, jm_frame.origin.y + jm_frame.size.height);
        CGContextAddLineToPoint(context, jm_frame.origin.x + 10, jm_frame.origin.y  + jm_frame.size.height + 15);
    }
    if (jm_anchorPoint.x == 0.5 && jm_anchorPoint.y == 0) {
        CGContextMoveToPoint(context, jm_frame.origin.x + jm_frame.size.width / 2.0 - 13, jm_frame.origin.y);
        CGContextAddLineToPoint(context, jm_frame.origin.x + jm_frame.size.width / 2.0 + 13, jm_frame.origin.y);
        CGContextAddLineToPoint(context, jm_frame.origin.x + jm_frame.size.width / 2.0, jm_frame.origin.y - 15);
    }
    if (jm_anchorPoint.x == 0.5 && jm_anchorPoint.y == 1) {
        CGContextMoveToPoint(context, jm_frame.origin.x + jm_frame.size.width / 2.0 - 13, jm_frame.origin.y + jm_frame.size.height);
        CGContextAddLineToPoint(context, jm_frame.origin.x + jm_frame.size.width / 2.0 + 13, jm_frame.origin.y + jm_frame.size.height);
        CGContextAddLineToPoint(context, jm_frame.origin.x + jm_frame.size.width / 2.0, jm_frame.origin.y + jm_frame.size.height + 15);
    }
    if (jm_anchorPoint.x == 1 && jm_anchorPoint.y == 0) {
        CGContextMoveToPoint(context, jm_frame.origin.x + jm_frame.size.width - 30, jm_frame.origin.y);
        CGContextAddLineToPoint(context, jm_frame.origin.x + jm_frame.size.width - 10, jm_frame.origin.y - 15);
        CGContextAddLineToPoint(context, jm_frame.origin.x + jm_frame.size.width - 12, jm_frame.origin.y);
    }
    if (jm_anchorPoint.x == 1 && jm_anchorPoint.y == 0.5) {
        CGContextMoveToPoint(context, jm_frame.origin.x + jm_frame.size.width, jm_frame.origin.y + jm_frame.size.height / 2.0 - 13);
        CGContextAddLineToPoint(context, jm_frame.origin.x + jm_frame.size.width, jm_frame.origin.y + jm_frame.size.height / 2.0 + 13);
        CGContextAddLineToPoint(context, jm_frame.origin.x + jm_frame.size.width + 15, jm_frame.origin.y + jm_frame.size.height / 2.0);
    }
    if (jm_anchorPoint.x == 1 && jm_anchorPoint.y == 1) {
        CGContextMoveToPoint(context, jm_frame.origin.x + jm_frame.size.width, jm_frame.origin.y + jm_frame.size.height - 12);
        CGContextAddLineToPoint(context, jm_frame.origin.x + jm_frame.size.width, jm_frame.origin.y + jm_frame.size.height - 30);
        CGContextAddLineToPoint(context, jm_frame.origin.x + jm_frame.size.width + 15, jm_frame.origin.y + jm_frame.size.height  - 10);
    }
    CGContextClosePath(context);
    [[UIColor whiteColor] setFill];
    [[UIColor whiteColor] setStroke];
    CGContextDrawPath(context, kCGPathFillStroke);
}




@end













































































