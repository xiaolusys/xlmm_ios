//
//  JMSearchViewController.m
//  XLMM
//
//  Created by zhang on 17/1/9.
//  Copyright © 2017年 上海己美. All rights reserved.
//

#import "JMSearchViewController.h"
#import "JMSearchHistoryModel.h"
#import "JMTagView.h"


@interface JMSearchViewController () <UISearchBarDelegate,UIAlertViewDelegate,UIScrollViewDelegate> {
    NSString *_defaultSearText;
}

@property (nonatomic, assign) BOOL keyboardshowing;
@property (nonatomic, assign) CGFloat keyboardHeight;

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, strong) UIScrollView *baseScrollView;
@property (nonatomic, strong) UIView *sectionView;
@property (nonatomic, strong) JMTagView *tagView;


@end

@implementation JMSearchViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadHistoryData];
    
    [MobClick beginLogPageView:@"JMSearchController"];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.searchBar resignFirstResponder];
    [MobClick endLogPageView:@"JMSearchController"];
}
// 视图完全显示
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // 弹出键盘
    [self.searchBar becomeFirstResponder];
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (instancetype)init {
    if (self = [super init]) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //    [self setup];
    
}
+ (JMSearchViewController *)searchViewControllerWithHistorySearchs:(NSArray<NSString *> *)historySearchs searchBarPlaceHolder:(NSString *)placeHolder didSearchBlock:(JMDidSearchBlock)block {
    JMSearchViewController *searchVC = [self searchViewControllerWithHistorySearchs:historySearchs searchBarPlaceholder:placeHolder];
    searchVC.didSearchBlock = block;
    return searchVC;
    
}
+ (JMSearchViewController *)searchViewControllerWithHistorySearchs:(NSArray<NSString *> *)historySearchs searchBarPlaceholder:(NSString *)placeHolder {
    JMSearchViewController *searchVC = [[JMSearchViewController alloc] init];
    searchVC.historySearchs = historySearchs;
    //    searchVC.searchBar.placeholder = placeHolder;
    return searchVC;
}
- (void)loadHistoryData {
    NSString *urlString = [NSString stringWithFormat:@"%@/rest/v2/searchhistory/product_search_history",Root_URL];
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:urlString WithParaments:nil WithSuccess:^(id responseObject) {
        if (!responseObject) {
            return ;
        }else {
            [self.dataSource removeAllObjects];
            [self fetchData:responseObject];
        }
    } WithFail:^(NSError *error) {
        _defaultSearText = @"";
        self.searchBar.placeholder = @"请输入搜索关键字";
//        [MBProgressHUD showError:@"搜索历史加载失败 \n 请检查是否登录"];
        [self.sectionView removeFromSuperview];
    } Progress:^(float progress) {
    }];
    
    
}
- (void)fetchData:(NSDictionary *)dict {
    NSArray *results = dict[@"results"];
    if (results.count == 0) {
        _defaultSearText = @"";
        self.searchBar.placeholder = @"请输入搜索关键字";
        [self.sectionView removeFromSuperview];
    }else {
        [self.baseScrollView addSubview:self.sectionView];
        //        NSDictionary *firstDic = results[0];
        //        self.searchBar.placeholder = firstDic[@"content"];
        for (NSDictionary *dic in results) {
            JMSearchHistoryModel *model = [JMSearchHistoryModel mj_objectWithKeyValues:dic];
            [self.dataSource addObject:model.content];
        }
        NSInteger randomCode = arc4random() % self.dataSource.count;
        self.searchBar.placeholder = self.dataSource[randomCode];
        _defaultSearText = self.dataSource[randomCode];
    
        [self.tagView removeAllTags];
        [self.dataSource enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            JMTagModel *tagModel = [[JMTagModel alloc] initWithText:self.dataSource[idx]];
            tagModel.padding = UIEdgeInsetsMake(10, 15, 10, 15);
            tagModel.cornerRadius = 3.0f;
            tagModel.font = [UIFont boldSystemFontOfSize:13];
            tagModel.borderWidth = 0;
            tagModel.bgColor = [UIColor countLabelColor];
            tagModel.borderColor = [UIColor titleDarkGrayColor];
            tagModel.textColor = [UIColor textDarkGrayColor];
            tagModel.enable = YES;
            [self.tagView addTag:tagModel];
        }];
        kWeakSelf
        self.tagView.didTapTagAtIndex = ^(NSUInteger index) {
            kStrongSelf
            NSLog(@"点击了第 %ld 个标签",index);
            _defaultSearText = strongSelf.dataSource[index];
            [weakSelf searchBarSearchButtonClicked:strongSelf.searchBar];
        };
        CGFloat tagHeight = self.tagView.intrinsicContentSize.height;
        self.tagView.frame = CGRectMake(0, 50, SCREENWIDTH, tagHeight);
        [self.tagView layoutSubviews];
        if (SCREENHEIGHT > tagHeight + 50) {
            self.baseScrollView.contentSize = CGSizeMake(SCREENWIDTH, SCREENHEIGHT);
        }else {
            self.baseScrollView.contentSize = CGSizeMake(SCREENWIDTH, tagHeight + 50);
        }
//        self.baseScrollView.contentSize = CGSizeMake(SCREENWIDTH, tagHeight + 50);
        
        
        
        
    }
    self.searchBar.text = nil;
    
    
}

/** 初始化 */
- (void)setup {
    [JMNotificationCenter addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    
    UIButton *navRightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [navRightButton addTarget:self action:@selector(cancelDidClick) forControlEvents:UIControlEventTouchUpInside];
    [navRightButton setTitle:@"取消" forState:UIControlStateNormal];
    [navRightButton setTitleColor:[UIColor dingfanxiangqingColor] forState:UIControlStateNormal];
    navRightButton.titleLabel.font = [UIFont systemFontOfSize:16.];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:navRightButton];
    
    // 创建搜索框
    UIView *titleView = [[UIView alloc] init];
    titleView.mj_x = 10 * 0.5;
    titleView.mj_y = 7;
    titleView.mj_w = self.view.mj_w - 64 - titleView.mj_x * 2;
    titleView.mj_h = 30;
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:titleView.bounds];
    [titleView addSubview:searchBar];
    self.navigationItem.titleView = titleView;
    // 关闭自动调整
    searchBar.translatesAutoresizingMaskIntoConstraints = NO;
    // 为titleView添加约束来调整搜索框
    NSLayoutConstraint *widthCons = [NSLayoutConstraint constraintWithItem:searchBar attribute:NSLayoutAttributeWidth  relatedBy:NSLayoutRelationEqual toItem:titleView attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0];
    NSLayoutConstraint *heightCons = [NSLayoutConstraint constraintWithItem:searchBar attribute:NSLayoutAttributeHeight  relatedBy:NSLayoutRelationEqual toItem:titleView attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0];
    NSLayoutConstraint *xCons = [NSLayoutConstraint constraintWithItem:searchBar attribute:NSLayoutAttributeTop  relatedBy:NSLayoutRelationEqual toItem:titleView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
    NSLayoutConstraint *yCons = [NSLayoutConstraint constraintWithItem:searchBar attribute:NSLayoutAttributeLeft  relatedBy:NSLayoutRelationEqual toItem:titleView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
    [titleView addConstraint:widthCons];
    [titleView addConstraint:heightCons];
    [titleView addConstraint:xCons];
    [titleView addConstraint:yCons];
    searchBar.backgroundImage = [UIImage imageNamed:@"clearImage"];
    self.searchBar = searchBar;
    searchBar.enablesReturnKeyAutomatically = NO;
    searchBar.delegate = self;
    
    
    
    self.baseScrollView = [[UIScrollView alloc] init];
    self.baseScrollView.frame = self.view.bounds;
    self.baseScrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.baseScrollView];
    self.baseScrollView.delegate = self;
    self.baseScrollView.showsHorizontalScrollIndicator = NO;
    self.baseScrollView.showsVerticalScrollIndicator = NO;
    
    UIView *sectionView = [UIView new];
    [self.baseScrollView addSubview:sectionView];
    sectionView.frame = CGRectMake(0, 0, SCREENWIDTH, 50);
    sectionView.backgroundColor = [UIColor sectionViewColor];
    self.sectionView = sectionView;
    
    
    UILabel *titleL = [UILabel new];
    [sectionView addSubview:titleL];
    titleL.textColor = [UIColor textDarkGrayColor];
    titleL.font = [UIFont systemFontOfSize:14.];
    titleL.text = @"历史搜索";
    
    UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [deleteButton addTarget:self action:@selector(deleteButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [sectionView addSubview:deleteButton];
    
    UIImageView *imageV = [UIImageView new];
    [deleteButton addSubview:imageV];
    imageV.image = [UIImage imageNamed:@"deleteSearchHistory"];
    
    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(sectionView).offset(15);
        make.centerY.equalTo(sectionView.mas_centerY);
    }];
    
    [deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(sectionView).offset(-5);
        make.centerY.equalTo(sectionView.mas_centerY);
        make.width.height.mas_equalTo(@(40));
    }];
    
    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(deleteButton);
    }];
    
    
    // 先清空tabView
    [self.tagView removeAllTags];
    self.tagView = [[JMTagView alloc] init];
    self.tagView.padding = UIEdgeInsetsMake(10, 10, 10, 10);
    self.tagView.lineSpacing = 10;
    self.tagView.interitemSpacing = 10;
    self.tagView.preferredMaxLayoutWidth = SCREENWIDTH;
    [self.baseScrollView addSubview:self.tagView];
    
  
    
}


- (void)loadClearHistoryData {
    NSString *urlString = [NSString stringWithFormat:@"%@/rest/v2/searchhistory/clear_search_history",Root_URL];
    NSDictionary *params = @{@"target":@"ModelProduct"};
    [JMHTTPManager requestWithType:RequestTypePOST WithURLString:urlString WithParaments:params WithSuccess:^(id responseObject) {
        if (!responseObject) {
            return ;
        }else {
            NSInteger code = [responseObject[@"code"] integerValue];
            if (code == 0) {
                [MBProgressHUD showSuccess:responseObject[@"info"]];
                [self.dataSource removeAllObjects];
                [self.tagView removeAllTags];
                [self.sectionView removeFromSuperview];
                _defaultSearText = @"";
                self.searchBar.placeholder = @"请输入搜索关键字";
            }else {
                [MBProgressHUD showWarning:responseObject[@"info"]];
            }
        }
        [self.searchBar becomeFirstResponder];
    } WithFail:^(NSError *error) {
        [MBProgressHUD showError:@"网络出错,请稍后重试..."];
        [self.searchBar becomeFirstResponder];
    } Progress:^(float progress) {
    }];
    
}





- (void)deleteButtonClick:(UIButton *)button {
    [self.searchBar resignFirstResponder];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"确认删除全部历史记录?" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    alert.delegate = self;
    [alert show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [self loadClearHistoryData];
    }else {
        [self.searchBar becomeFirstResponder];
    }
}


/** 点击取消 */
- (void)cancelDidClick {
    [self.searchBar resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
}



#pragma mark - UISearchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
//    searchBar.returnKeyType = UIReturnKeySearch;
    return YES;
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    _defaultSearText = searchText;
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    searchBar.text = _defaultSearText;
    if (self.didSearchBlock) {
        self.didSearchBlock(self, searchBar, searchBar.text);
    }
}

//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    [self.searchBar resignFirstResponder];
//}


// 键盘显示完成（弹出）
- (void)keyboardDidShow:(NSNotification *)noti {
    // 取出键盘高度
    NSDictionary *info = noti.userInfo;
    self.keyboardHeight = [info[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    self.keyboardshowing = YES;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // 滚动时，回收键盘
    if (self.keyboardshowing)  {
        [self.searchBar resignFirstResponder];
    }
}
// 控制器销毁
- (void)dealloc {
    [JMNotificationCenter removeObserver:self];
}








@end

















































































































































