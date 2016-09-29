//
//  UdeskAgentMenuViewController.m
//  UdeskSDK
//
//  Created by xuchen on 16/3/16.
//  Copyright © 2016年 xuchen. All rights reserved.
//

#import "UdeskAgentMenuViewController.h"
#import "UdeskAgentMenuModel.h"
#import "UdeskViewExt.h"
#import "UdeskFoundationMacro.h"
#import "UdeskUtils.h"
#import "UdeskChatViewController.h"
#import "UIImage+UdeskSDK.h"
#import "UdeskStringSizeUtil.h"
#import "UdeskTools.h"
#import "UdeskSDKConfig.h"
#import "UdeskTransitioningAnimation.h"
#import "UdeskSDKShow.h"

@interface UdeskAgentMenuViewController () <UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>

/** 客服组菜单Tableview */
@property (nonatomic, strong) UITableView    *agentMenuTableView;
/** 客服组菜单ScrollView */
@property (nonatomic, strong) UIScrollView   *agentMenuScrollView;
/** agentMenuModel数组 */
@property (nonatomic, strong) NSMutableArray *allAgentMenuData;
/** 一级菜单数据 */
@property (nonatomic, strong) NSArray        *agentMenuData;
/** 客服组分页 */
@property (nonatomic, assign) int            menuPage;
/** 客服组路径名字 */
@property (nonatomic, strong) NSString       *pathString;
/** 菜单数据 */
@property (nonatomic, strong) NSArray        *agentMenu;
/** sdk配置 */
@property (nonatomic, strong) UdeskSDKConfig *sdkConfig;

@property (nonatomic, strong) UdeskSDKShow *show;


@end

@implementation UdeskAgentMenuViewController

- (instancetype)initWithSDKConfig:(UdeskSDKConfig *)config menuArray:(NSArray *)menu
{
    self = [super init];
    if (self) {
        
        self.sdkConfig = config;
        self.hidesBottomBarWhenPushed = YES;
        
        self.agentMenu = menu;
        
        self.allAgentMenuData = [NSMutableArray array];
        self.show = [[UdeskSDKShow alloc] initWithConfig:config];
        
        self.menuPage = 0;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UdeskSDKConfig sharedConfig].sdkStyle.tableViewBackGroundColor;
    
    if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0)) {
        self.navigationController.navigationBar.translucent = NO;
    }
    
    if ([UdeskSDKConfig sharedConfig].agentMenuTitle) {
        self.title = [UdeskSDKConfig sharedConfig].agentMenuTitle;
    }
    else {
        self.title = getUDLocalizedString(@"udesk_choose_group");
    }
    
    [self setAgentMenuScrollView];
    
    [self requestAgentMenu:self.agentMenu];
    UIScreenEdgePanGestureRecognizer *popRecognizer = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePopRecognizer:)];
    popRecognizer.edges = UIRectEdgeLeft;
    [self.view addGestureRecognizer:popRecognizer];
}

//滑动返回
- (void)handlePopRecognizer:(UIScreenEdgePanGestureRecognizer*)recognizer {
    
    CGPoint translation = [recognizer translationInView:self.view];
    CGFloat xPercent = translation.x / CGRectGetWidth(self.view.bounds) * 0.9;
    
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:
            [UdeskTransitioningAnimation setInteractive:YES];
            [self dismissViewControllerAnimated:YES completion:nil];
            break;
        case UIGestureRecognizerStateChanged:
            [UdeskTransitioningAnimation updateInteractiveTransition:xPercent];
            break;
        default:
            if (xPercent < .45) {
                [UdeskTransitioningAnimation cancelInteractiveTransition];
            } else {
                [UdeskTransitioningAnimation finishInteractiveTransition];
            }
            [UdeskTransitioningAnimation setInteractive:NO];
            break;
    }
    
}
//点击返回
- (void)dismissChatViewController {
    
    if ([UdeskSDKConfig sharedConfig].presentingAnimation == UDTransiteAnimationTypePush) {
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            [self.view.window.layer addAnimation:[UdeskTransitioningAnimation createDismissingTransiteAnimation:[UdeskSDKConfig sharedConfig].presentingAnimation] forKey:nil];
            [self dismissViewControllerAnimated:NO completion:nil];
        }
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}

#pragma mark - 设置MenuScrollView
- (void)setAgentMenuScrollView {
    
    CGRect scrollViewRect = self.navigationController.navigationBarHidden?CGRectMake(0, 64, UD_SCREEN_WIDTH, UD_SCREEN_HEIGHT-64):self.view.bounds;
    _agentMenuScrollView= [[UIScrollView alloc] initWithFrame:scrollViewRect];
    _agentMenuScrollView.delegate = self;
    _agentMenuScrollView.showsHorizontalScrollIndicator = NO;
    _agentMenuScrollView.showsVerticalScrollIndicator = NO;
    _agentMenuScrollView.userInteractionEnabled = YES;
    _agentMenuScrollView.alwaysBounceHorizontal = NO;
    _agentMenuScrollView.pagingEnabled = YES;
    _agentMenuScrollView.scrollEnabled = NO;
    
    [self.view addSubview:_agentMenuScrollView];
}

#pragma mark - 请求客服组选择菜单
- (void)requestAgentMenu:(NSArray *)result {
    
    for (NSDictionary *menuDict in result) {
        
        UdeskAgentMenuModel *agentMenuModel = [[UdeskAgentMenuModel alloc] initWithContentsOfDic:menuDict];
        
        [self.allAgentMenuData addObject:agentMenuModel];
    }
    
    NSMutableArray *rootMenuArray = [NSMutableArray array];
    
    int tableViewCount = 1;
    //寻找树状的根
    for (UdeskAgentMenuModel *agentMenuModel in self.allAgentMenuData) {
        
        if ([agentMenuModel.parentId isEqualToString:@"item_0"]) {
            
            [rootMenuArray addObject:agentMenuModel];
        }
        
        tableViewCount += [agentMenuModel.has_next intValue];
        
    }
    //根据最大的级数设置ScrollView.contentSize
    self.agentMenuScrollView.contentSize = CGSizeMake(tableViewCount*UD_SCREEN_WIDTH, UD_SCREEN_HEIGHT);
    
    //根据最大的级数循环添加tableView
    for (int i = 0; i<tableViewCount;i++) {
        
        UITableView *agentMenuTableView = [[UITableView alloc] initWithFrame:CGRectMake(i*UD_SCREEN_WIDTH, 0, UD_SCREEN_WIDTH, UD_SCREEN_HEIGHT-64) style:UITableViewStylePlain];
        agentMenuTableView.delegate = self;
        agentMenuTableView.dataSource = self;
        agentMenuTableView.tag = 100+i;
        agentMenuTableView.backgroundColor = self.view.backgroundColor;
        
        [self.agentMenuScrollView addSubview:agentMenuTableView];
        
        //删除多余的cell
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectZero];
        [agentMenuTableView setTableFooterView:footerView];
        
    }
    //装载数据 刷新第一个tableView
    self.agentMenuData = rootMenuArray;
    
    UITableView *tableview = (UITableView *)[self.agentMenuScrollView viewWithTag:100];
    
    [tableview reloadData];
    
}

- (void)pushChatViewController {
    
    UdeskChatViewController *chat = [[UdeskChatViewController alloc] initWithSDKConfig:_sdkConfig];
    [self.show presentOnViewController:self udeskViewController:chat transiteAnimation:UDTransiteAnimationTypePush];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView.tag == self.menuPage+100) {
        
        return self.agentMenuData.count;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *agentMenuCellId = @"agentMenuCellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:agentMenuCellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:agentMenuCellId];
    }
    
    if (tableView.tag == self.menuPage+100) {
        
        UdeskAgentMenuModel *agentMenuModel = self.agentMenuData[indexPath.row];
        
        cell.textLabel.text = agentMenuModel.item_name;
        
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //取消点击效果
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    self.menuPage ++;
    
    NSMutableArray *menuArray = [NSMutableArray array];
    
    //获取点击菜单选项的子集
    UdeskAgentMenuModel *didSelectModel = self.agentMenuData[indexPath.row];
    
    for (UdeskAgentMenuModel *allAgentMenuModel in self.allAgentMenuData) {
        
        if ([allAgentMenuModel.parentId isEqualToString:didSelectModel.menu_id]) {
            
            [menuArray addObject:allAgentMenuModel];
        }
        
    }
    //根据是否还有子集选择push还是执行动画
    if (menuArray.count > 0) {
        
        [UIView animateWithDuration:0.35f animations:^{
            
            self.agentMenuScrollView.contentOffset = CGPointMake(self.menuPage*UD_SCREEN_WIDTH, 0);
            
        } completion:^(BOOL finished) {
            
            if ([UdeskTools isBlankString:self.pathString]) {
                self.pathString = [NSString stringWithFormat:@"   %@",didSelectModel.item_name];
            }
            else {
                self.pathString = [NSString stringWithFormat:@"%@ > ",self.pathString];
                self.pathString = [self.pathString stringByAppendingString:didSelectModel.item_name];
            }
            
            self.agentMenuData = menuArray;
            
            UITableView *tableview = (UITableView *)[self.agentMenuScrollView viewWithTag:self.menuPage+100];
            
            [tableview reloadData];
            
        }];
        
    }
    else {
        
        //这里--是因为之前的++并没有执行给ScrollView.contentOffset
        self.menuPage -- ;
        
        UdeskChatViewController *chat = [[UdeskChatViewController alloc] initWithSDKConfig:_sdkConfig];
        [self.show presentOnViewController:self udeskViewController:chat transiteAnimation:UDTransiteAnimationTypePush];
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (self.menuPage) {
        
        UIButton *pathButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [pathButton setTitle:self.pathString forState:UIControlStateNormal];
        pathButton.frame = CGRectMake(0, 0, tableView.ud_width-0, 30);
        pathButton.titleLabel.numberOfLines = 0;
        pathButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [pathButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [pathButton addTarget:self action:@selector(pathBackButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        return pathButton;
    }
    else {
        
        return nil;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (self.menuPage) {
        
        CGSize pathSize = [UdeskStringSizeUtil textSize:self.pathString withFont:[UIFont systemFontOfSize:17] withSize:CGSizeMake(tableView.ud_width, CGFLOAT_MAX)];
        
        CGFloat otherH;
        if (pathSize.height==0) {
            otherH = 45;
        }
        else {
            otherH = 25;
        }
        
        return pathSize.height+otherH;
    }
    else {
        
        return 0;
    }
    
}

- (void)pathBackButtonAction:(UIButton *)button {
    
    self.menuPage --;
    
    //判断ScrollView.contentOffset.x是否到头
    if (self.agentMenuScrollView.contentOffset.x>0) {
        
        [UIView animateWithDuration:0.35f animations:^{
            //执行返回
            self.agentMenuScrollView.contentOffset = CGPointMake(self.agentMenuScrollView.contentOffset.x-UD_SCREEN_WIDTH, 0);
        } completion:^(BOOL finished) {
            //装载这个页面的数据
            NSMutableArray *array = [NSMutableArray array];
            
            UdeskAgentMenuModel *subMenuModel = self.agentMenuData.lastObject;
            
            NSString *parentId;
            NSString *upString;
            //查找属于上级菜单的父级
            for (UdeskAgentMenuModel *model in self.allAgentMenuData) {
                
                if ([model.menu_id isEqualToString:subMenuModel.parentId]) {
                    
                    parentId = model.parentId;
                    
                    if ([model.parentId isEqualToString:@"item_0"]) {
                        upString = model.item_name;
                    }
                    else {
                        upString = [NSString stringWithFormat:@" > %@",model.item_name];
                    }
                    
                }
                
            }
            
            //查找与上级菜单的父级同级的菜单选项
            for (UdeskAgentMenuModel *model in self.allAgentMenuData) {
                
                if ([model.parentId isEqualToString:parentId]) {
                    
                    [array addObject:model];
                }
            }
            
            if (array.count > 0) {
                
                NSMutableString *mString = [NSMutableString stringWithString:self.pathString];
                [mString deleteCharactersInRange:[mString rangeOfString:upString]];
                
                self.pathString = mString;
                
                //装载数据刷新指定tableview
                self.agentMenuData = array;
                
                UITableView *tableview = (UITableView *)[self.agentMenuScrollView viewWithTag:self.menuPage+100];
                
                [tableview reloadData];
            }
            
        }];
        
    }
    
}
- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
}

- (void)dealloc
{
    NSLog(@"%@销毁了",[self class]);
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
