//
//  JMPopMenuView.m
//  XLMM
//
//  Created by zhang on 16/8/30.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMPopMenuView.h"

#define kMenuTag 201712
#define kCoverViewTag 201722
#define kMargin 8
#define kTriangleHeight 10 // 三角形的高
#define kRadius 5 // 圆角半径
#define KDefaultMaxValue 6  // 菜单项最大值

@interface JMPopMenuView () <UITableViewDelegate,UITableViewDataSource> {
    UIView *_backView;
    CGFloat arrowPointX; // 箭头位置
}

@property (nonatomic,strong) JMPopMenuView * selfMenu;
@property (nonatomic,strong) UITableView * contentTableView;;
@property (nonatomic,strong) NSMutableArray * menuDataArray;


@end


@implementation JMPopMenuView

- (void)setMenuDataArray:(NSMutableArray *)menuDataArray{
    if (!_menuDataArray) {
        _menuDataArray = [NSMutableArray array];
    }
    [menuDataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[NSString class]]) {
//            JMMenuModel *model = [JMMenuModel mj_objectWithKeyValues:(NSDictionary *)obj];
            [_menuDataArray addObject:obj];
        }
    }];
}
- (void)setMaxValueForItemCount:(NSInteger)maxValueForItemCount{
    if (maxValueForItemCount <= KDefaultMaxValue) {
        _maxValueForItemCount = maxValueForItemCount;
    }else{
        _maxValueForItemCount = KDefaultMaxValue;
    }
}
- (instancetype)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]) {
        [self setUpUI];
    }
    return self;
}
- (void)setUpUI{
    self.backgroundColor = [UIColor colorWithRed:61/255.0 green:61/255.0 blue:61/255.0 alpha:1];
    arrowPointX = self.mj_w * 0.5;
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kTriangleHeight, self.mj_w, self.mj_h)];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.bounces = NO;
    tableView.rowHeight = 40;
//    tableView.showsVerticalScrollIndicator = NO;
    tableView.backgroundColor = [UIColor clearColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView registerClass:[JMMenuCell class] forCellReuseIdentifier:NSStringFromClass([JMMenuCell class])];
    
    self.contentTableView = tableView;
    self.mj_h = tableView.mj_h + kTriangleHeight * 2 - 0.5;
    self.alpha = 0;
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
    backView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.3];
    [backView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)]];
    backView.alpha = 0;
    backView.tag = kCoverViewTag;
    _backView = backView;
    [JMKeyWindow addSubview:backView];
    
    CAShapeLayer *lay = [self getBorderLayer];
    self.layer.mask = lay;
    [self addSubview:tableView];
    [JMKeyWindow addSubview:self];
}
#pragma mark --- TableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.menuDataArray.count;
}

- (JMMenuCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    JMMenuModel *model = self.menuDataArray[indexPath.row];
    JMMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JMMenuCell class])];
    if (!cell) {
        cell = [[JMMenuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([JMMenuCell class])];
    }
    NSString *itemNameText = self.menuDataArray[indexPath.row];
    cell.itemString = itemNameText;
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *itemNameText = self.menuDataArray[indexPath.row];
    if (self.itemsClickBlock) {
        self.itemsClickBlock(itemNameText,indexPath.row +1);
    }
}


#pragma mark --- 类方法封装
+ (JMPopMenuView *)createMenuWithFrame:(CGRect)frame target:(UIViewController *)target dataArray:(NSArray *)dataArray itemsClickBlock:(void(^)(NSString *str, NSInteger tag))itemsClickBlock backViewTap:(void(^)())backViewTapBlock{
    CGFloat menuWidth = frame.size.width ? frame.size.width : 120;
    JMPopMenuView *menuView = [[JMPopMenuView alloc] initWithFrame:CGRectMake(0, 0, menuWidth, 40 * 8)]; // dataArray.count
    menuView.selfMenu = menuView;
    menuView.itemsClickBlock = itemsClickBlock;
    menuView.backViewTapBlock = backViewTapBlock;
    menuView.menuDataArray = [NSMutableArray arrayWithArray:dataArray];
    menuView.maxValueForItemCount = 6;
    menuView.tag = kMenuTag;
    return menuView;
}
+ (void)showMenuPoint:(CGPoint)point {
    JMPopMenuView *menuView = [JMKeyWindow viewWithTag:kMenuTag];
    [menuView displayAtPoint:point];
}

+ (void)hidden {
    JMPopMenuView *menuView = [JMKeyWindow viewWithTag:kMenuTag];
    [menuView hiddenMenu];
}

+ (void)clearMenu {
    [JMPopMenuView hidden];
    JMPopMenuView *menuView = [JMKeyWindow viewWithTag:kMenuTag];
    UIView *coverView = [JMKeyWindow viewWithTag:kCoverViewTag];
    [menuView removeFromSuperview];
    [coverView removeFromSuperview];
}




- (CAShapeLayer *)getBorderLayer{
    // 上下左右的圆角中心点
    CGPoint upperLeftCornerCenter = CGPointMake(kRadius, kTriangleHeight + kRadius);
    CGPoint upperRightCornerCenter = CGPointMake(self.mj_w - kRadius, kTriangleHeight + kRadius);
    CGPoint bottomLeftCornerCenter = CGPointMake(kRadius, self.mj_h - kTriangleHeight - kRadius);
    CGPoint bottomRightCornerCenter = CGPointMake(self.mj_w - kRadius, self.mj_h - kTriangleHeight - kRadius);
    
    CAShapeLayer *borderLayer = [CAShapeLayer layer];
    borderLayer.frame = self.bounds;
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:CGPointMake(0, kTriangleHeight + kRadius)];
    [bezierPath addArcWithCenter:upperLeftCornerCenter radius:kRadius startAngle:M_PI endAngle:M_PI * 3 * 0.5 clockwise:YES];
    [bezierPath addLineToPoint:CGPointMake(arrowPointX - kTriangleHeight * 0.7, kTriangleHeight)];
    [bezierPath addLineToPoint:CGPointMake(arrowPointX, 0)];
    [bezierPath addLineToPoint:CGPointMake(arrowPointX + kTriangleHeight * 0.7, kTriangleHeight)];
    [bezierPath addLineToPoint:CGPointMake(self.mj_w - kRadius, kTriangleHeight)];
    [bezierPath addArcWithCenter:upperRightCornerCenter radius:kRadius startAngle:M_PI * 3 * 0.5 endAngle:0 clockwise:YES];
    [bezierPath addLineToPoint:CGPointMake(self.mj_w, self.mj_h - kTriangleHeight - kRadius)];
    [bezierPath addArcWithCenter:bottomRightCornerCenter radius:kRadius startAngle:0 endAngle:M_PI_2 clockwise:YES];
    [bezierPath addLineToPoint:CGPointMake(kRadius, self.mj_h - kTriangleHeight)];
    [bezierPath addArcWithCenter:bottomLeftCornerCenter radius:kRadius startAngle:M_PI_2 endAngle:M_PI clockwise:YES];
    [bezierPath addLineToPoint:CGPointMake(0, kTriangleHeight + kRadius)];
    [bezierPath closePath];
    borderLayer.path = bezierPath.CGPath;
    return borderLayer;
}
#pragma mark --- 关于菜单展示
- (void)displayAtPoint:(CGPoint)point{
    
    point = [self.superview convertPoint:point toView:self.window];
    self.layer.affineTransform = CGAffineTransformIdentity;
    [self adjustPosition:point]; // 调整展示的位置 - frame
    
    // 调整箭头位置
    if (point.x <= kMargin + kRadius + kTriangleHeight * 0.7) {
        arrowPointX = kMargin + kRadius;
    }else if (point.x >= SCREENWIDTH - kMargin - kRadius - kTriangleHeight * 0.7){
        arrowPointX = self.mj_w - kMargin - kRadius;
    }else{
        arrowPointX = point.x - self.mj_x;
    }
    
    // 调整anchorPoint
    CGPoint aPoint = CGPointMake(0.5, 0.5);
    if (CGRectGetMaxY(self.frame) > SCREENHEIGHT) {
        aPoint = CGPointMake(arrowPointX / self.mj_w, 1);
    }else{
        aPoint = CGPointMake(arrowPointX / self.mj_w, 0);
    }
    
    // 调整layer
    CAShapeLayer *layer = [self getBorderLayer];
    if (self.mj_max_Y > SCREENHEIGHT) {
        layer.transform = CATransform3DMakeRotation(M_PI, 0, 1, 0);
        layer.transform = CATransform3DRotate(layer.transform, M_PI, 0, 0, 1);
        self.mj_y = point.y - self.mj_h;
    }
    
    // 调整frame
    CGRect rect = self.frame;
    self.layer.anchorPoint = aPoint;
    self.frame = rect;
    
    self.layer.mask = layer;
    self.layer.affineTransform = CGAffineTransformMakeScale(0.01, 0.01);
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 1;
        _backView.alpha = 0.3;
        self.layer.affineTransform = CGAffineTransformMakeScale(1.0, 1.0);
    }];
}

- (void)adjustPosition:(CGPoint)point{
    self.mj_x = point.x - self.mj_w * 0.5;
    self.mj_y = point.y + kMargin;
    if (self.mj_x < kMargin) {
        self.mj_x = kMargin;
    }else if (self.mj_x > SCREENWIDTH - kMargin - self.mj_w){
        self.mj_x = SCREENWIDTH - kMargin - self.mj_w;
    }
    self.layer.affineTransform = CGAffineTransformMakeScale(1.0, 1.0);
}
- (void)hiddenMenu{
    self.contentTableView.contentOffset = CGPointMake(0, 0);
    [UIView animateWithDuration:0.25 animations:^{
        self.layer.affineTransform = CGAffineTransformMakeScale(0.01, 0.01);
        self.alpha = 0;
        _backView.alpha = 0;
    }];
}
- (void)tap:(UITapGestureRecognizer *)sender{
    if (self.backViewTapBlock) {
        self.backViewTapBlock();
    }
    [self hiddenMenu];
    
}





@end

@implementation JMMenuCell {
    UIView *_lineView;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI{
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor lightGrayColor];
    _lineView = lineView;
    [self addSubview:lineView];
    self.backgroundColor = [UIColor clearColor];
    self.textLabel.font = [UIFont systemFontOfSize:14];
    self.textLabel.textColor = [UIColor whiteColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    _lineView.frame = CGRectMake(4, self.bounds.size.height - 1, self.bounds.size.width - 8, 0.5);
}

- (void)setItemString:(NSString *)itemString{
    _itemString = itemString;
    self.textLabel.text = itemString;
}



@end


@implementation JMMenuModel



@end








































































