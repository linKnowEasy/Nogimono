//
//  NGHomeVC.m
//  Nogimono
//
//  Created by lingang on 2018/6/26.
//  Copyright © 2018年 none. All rights reserved.
//

#import "NGHomeVC.h"
#import "NGConstantHeader.h"
#import "YFViewPager.h"

#import "NGNewsTypeModel.h"
#import "NGNewsCell.h"
#import "NGWebWithCommentVC.h"
#import "NGUserInfoModel.h"


static char *tableViewType;

@interface NGHomeVC ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) YFViewPager *newsViewPager;

@property (nonatomic, strong) NSMutableDictionary *tableViewDataListDic;
@property (nonatomic, strong) NSMutableDictionary *tableViewDic;

@property (nonatomic, strong) NSMutableDictionary *newsModelDic;

@end

@implementation NGHomeVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ([NGUserInfoModel sharedInstance].nickname.length == 0) {
        [[NGUserInfoModel sharedInstance] getUserInfo:^(NSError *error, NSString *message) {
            NSLog(@"NGHomeVC-error==%@, message==%@", error, message);
        }];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupData];
    [self setupView];
}
- (void)setupData {
    _tableViewDataListDic = [NSMutableDictionary dictionary];
    _tableViewDic = [NSMutableDictionary dictionary];
    _newsModelDic = [NSMutableDictionary dictionary];
    
    NSArray *titles = @[@"全部", @"新闻", @"推特", @"事件", @"通稿", @"发售", @"其他"];
    NSArray *types = @[@"0", @"4", @"12", @"13", @"14", @"15", @"16"];
    
    
    for (int i = 0; i < titles.count; i++) {
        NGNewsTypeModel *model = [[NGNewsTypeModel alloc] init];
        model.type = types[i];
        model.title = titles[i];
        model.newsPage = 1;
        model.newsPageSize = 20;
        [_newsModelDic setObject:model forKey:types[i]];
    }
}

//public static final String TYPE_ALL  ="TYPE_ALL";
//public static final String  TYPE_MAGAZINE ="magazine";
//public static final String TYPE_BLOG ="4";
//public static final String TYPE_NEWS ="12";
//public static final String TYPE_ACT="13";
//public static final String TYPE_MEDIA ="14";
//public static final String TYPE_RELEASE ="15";
//public static final String TYPE_OTHER ="16";

- (void)setupView {
    NGWeakObj(self)
//    NSArray *icons = @[[UIImage imageNamed:@"issueTree"],
//                       [UIImage imageNamed:@"hollow_out_star_blue"],
//                       [UIImage imageNamed:@"later_in-tne_chat"]];
    NSArray *titles = @[@"全部", @"新闻", @"推特", @"事件", @"通稿", @"发售", @"其他"];
    NSArray *types = @[@"0", @"4", @"12", @"13", @"14", @"15", @"16"];
    
    NSArray *tabelViews = [self getTableViewsFromTypes:types];
    
    
    _newsViewPager = [[YFViewPager alloc] initWithFrame:self.view.bounds
                                             titles:titles
                                              icons:nil
                                      selectedIcons:nil
                                              views:tabelViews];
    [self.view addSubview:_newsViewPager];

    [_newsViewPager mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.right.offset(-10);
        if (@available(iOS 11.0,*)) {
            make.top.equalTo(selfWeak.view.mas_safeAreaLayoutGuideTop);
            make.bottom.equalTo(selfWeak.view.mas_safeAreaLayoutGuideBottom);
        } else {
            make.top.mas_equalTo(10);
            make.bottom.mas_equalTo(0);
        }
        
    }];
    
    
#pragma mark - YFViewPager 相关属性 方法
    //    _newsViewPager.enabledScroll = NO;
    //    _newsViewPager.showAnimation = NO;
    //    _newsViewPager.showBottomLine = NO;
    //    _newsViewPager.showVLine = NO;
    //    _newsViewPager.bottomLineSelectedBgColor = [UIColor redColor];
    //    _newsViewPager.bottomLineBgColor = [UIColor orangeColor];
    //    _newsViewPager.tabBgColor = [UIColor orangeColor];
    //    _newsViewPager.bottomLineSelectedBgColor = [UIColor brownColor];
    //    _newsViewPager.tabSelectedBgColor = [UIColor redColor];
    //    _newsViewPager.tabSelectedTitleColor = [UIColor blueColor];
    //    _newsViewPager.tabTitleColor = [UIColor grayColor];
    //    [_newsViewPager setTitleIconsArray:icons selectedIconsArray:nil];
    
    // 此方法用于给菜单标题右上角小红点赋值，可动态调用
//    [_newsViewPager setTipsCountArray:@[@100,@8,@0]];
//    [_newsViewPager setTipsCountShowType:YFViewPagerTipsCountShowTypeNumber];
    
    [_newsViewPager setBottomLineType:YFViewPagerBottomLineTypeFitItemContentWidth];
    
    [_newsViewPager setSelectIndex:0];
    
    

    // 点击菜单时触发
    [_newsViewPager didSelectedBlock:^(id viewPager, NSInteger index) {
        NSString *type = types[index];
        
        NSArray *newsList = selfWeak.tableViewDataListDic[type];
        
        if (newsList.count == 0) {
            UITableView *tableView = selfWeak.tableViewDic[type];
            [tableView.mj_header beginRefreshing];
        }
        
        switch (index) {
            case 0:     // 点击第一个菜单
            {
                
            }
                break;
            case 1:     // 点击第二个菜单
            {
                
            }
                break;
            case 2:     // 点击第三个菜单
            {
                
            }
                break;
                
            default:
                break;
        }
    }];
    
    
    
}

#pragma mark - 生成多个 TableView
- (NSArray *)getTableViewsFromTypes:(NSArray *)types{
    
    NSMutableArray *tablewViewArray = [NSMutableArray array];
    
    
    NGWeakObj(self)
    
    for (NSString *type in types) {
        UITableView *tableView = [[UITableView alloc] init];
        tableView.delegate = self;
        tableView.dataSource = self;
        
        objc_setAssociatedObject(tableView, &tableViewType, type, OBJC_ASSOCIATION_COPY);
        
        tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            // 刷新
            NSLog(@"refreshNewsList--");
            [selfWeak refreshNewsList:type];
        }];
        
        tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            // 加载更多.
            [selfWeak loadMoreNewsList:type];
        }];
        
        tableView.tableFooterView = [UIView new];
        
        [tablewViewArray addObject:tableView];
        
        
        [_tableViewDic setObject:tableView forKey:type];
    }
    
    return [tablewViewArray copy];
}


#pragma mark---refresh and load more
- (void)refreshNewsList:(NSString *)type {
    

    
    NSArray *newsList = _tableViewDataListDic[type];
    if (newsList.count == 0) {
        newsList = @[];
    }
    NSMutableArray *newList = [newsList mutableCopy];
    
    NGNewsTypeModel *model = _newsModelDic[type];
    
    model.newsPage = 1;
    
    // 这样直观.清晰点
    NSDictionary *dic = @{@"page":@(model.newsPage), @"size":@(model.newsPageSize), @"type":type};
    
    NGWeakObj(self)
    [NGHttpHelp api_news:dic done:^(NSError *error, NSString *message, id retData) {
        UITableView *tableView = selfWeak.tableViewDic[type];
        [tableView.mj_header endRefreshing];
        NSLog(@"refresh -----%@", tableView);
        if (error) {
            /// 错误处理
            NSLog(@"123");
        } else {
            /// 这样分页 会有 bug。 加载更多的时候 没办法保证 数据的完整性,一致性(数据数量变化, 如增加, 删除都会导致问题), 最好是 带上 id, 然后 上传 id 字段. 返回上传id 的后 page size
            NSArray *retArray = retData;
            [newList removeAllObjects];
            for (NSDictionary *newsInfo in retArray) {
                NGNewsCellModel *model = [NGNewsCellModel yy_modelWithJSON:newsInfo];
                [newList addObject:model];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [tableView reloadData];
            });
            [selfWeak.tableViewDataListDic setObject:newList forKey:type];
        }
    }];
}

- (void)loadMoreNewsList:(NSString *)type {
    
    NSArray *newsList = _tableViewDataListDic[type];
    if (newsList.count == 0) {
        newsList = @[];
    }
    NSMutableArray *newList = [newsList mutableCopy];
    
    NGNewsTypeModel *model = _newsModelDic[type];
    
    model.newsPage ++;
    
    // 这样直观.清晰点
    NSDictionary *dic = @{@"page":@(model.newsPage), @"size":@(model.newsPageSize), @"type":type};
    
    NGWeakObj(self)
    [NGHttpHelp api_news:dic done:^(NSError *error, NSString *message, id retData) {
        UITableView *tableView = selfWeak.tableViewDic[type];
        [tableView.mj_footer endRefreshing];
        if (error) {
            /// 错误处理
        } else {
            /// 这样分页 会有 bug。 加载更多的时候 没办法保证 数据的完整性,一致性(数据数量变化, 如增加, 删除都会导致问题), 最好是 带上 id, 然后 上传 id 字段. 返回上传id 的后 page size
            NSArray *retArray = retData;
            for (NSDictionary *newsInfo in retArray) {
                NGNewsCellModel *model = [NGNewsCellModel yy_modelWithJSON:newsInfo];
                [newList addObject:model];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [tableView reloadData];
            });
            [selfWeak.tableViewDataListDic setObject:newList forKey:type];
        }
    }];
}



#pragma mark---UITableView delegate and date source

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    static NSString *reuseID = @"NGNewsCell";
    
    NSString *type = objc_getAssociatedObject(tableView, &tableViewType);
    NSArray *newsList = _tableViewDataListDic[type];
    
    NGNewsCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if (cell == nil) {
        cell = [[NGNewsCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseID];
    }
    
    NGNewsCellModel *model = newsList[indexPath.row];
    
    cell.dataModel = model;
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString *type = objc_getAssociatedObject(tableView, &tableViewType);
    NSArray *newsList = _tableViewDataListDic[type];
    
    return newsList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *type = objc_getAssociatedObject(tableView, &tableViewType);
    NSArray *newsList = _tableViewDataListDic[type];
    NGNewsCellModel *model = newsList[indexPath.row];
    NGWebWithCommentVC *webVC = [[NGWebWithCommentVC alloc] initWithURL:model.newsWebUrl newsID:model.newsID];
    webVC.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController pushViewController:webVC animated:YES];
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
