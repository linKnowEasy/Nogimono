//
//  NGBlogList.m
//  Nogimono
//
//  Created by lingang on 2018/6/27.
//  Copyright © 2018年 none. All rights reserved.
//

#import "NGBlogListVC.h"
#import "NGConstantHeader.h"
#import "NGBlogListCell.h"


#import "NGWebViewVC.h"



@interface NGBlogListVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *blogListTableView;
@property (nonatomic, strong) NSMutableArray *blogListArray;
/// 按照团队查看 blog
@property (nonatomic, copy) NSString *group;
/// 按照成员查看 成员罗马音
@property (nonatomic, copy) NSString *memberRome;

/// 页码
@property (nonatomic, assign) NSUInteger blogPage;
/// 页面数
@property (nonatomic, assign) NSUInteger blogPageSize;

@end

@implementation NGBlogListVC

/// 根据 group 处理.
- (instancetype)initWithGroup:(NSString *)group {
    return [self initWithGroup:group Member:nil];
}
/// 根据 member 处理.
- (instancetype)initWithMember:(NSString *)member {
    return [self initWithGroup:nil Member:member];
}

/// 根据 member 处理.
- (instancetype)initWithGroup:(NSString *)group Member:(NSString *)member {
    self = [super init];
    if (self) {
        _group = group;
        _memberRome = member;
        _blogPage = 1;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupData];
    [self setupView];
}
- (void)setupData {
    _blogListArray = [NSMutableArray array];
    _blogPageSize = 20;
    
}

- (void)setupView {
    NGWeakObj(self)
    
    self.title = @"博客列表";
    
    [self ng_leftBtnWithNrlImage:MaterialIconCode.arrow_back title:@"" action:^{
        [selfWeak.navigationController popViewControllerAnimated:YES];
    }];
    
    
    _blogListTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _blogListTableView.delegate = self;
    _blogListTableView.dataSource = self;
    
    _blogListTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 刷新
        [selfWeak refreshBlogList];
    }];

    _blogListTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        // 加载更多.
        [selfWeak loadMoreBlogList];
    }];
    
    _blogListTableView.tableFooterView = [UIView new];
    
    [_blogListTableView.mj_header beginRefreshing];

    
    [self.view addSubview:_blogListTableView];
    
    
    
}

#pragma mark---refresh and load more

- (void)refreshBlogList {
    
    
    
    
//    NSDictionary *dic = _group ? @{@"group":_group, @"page":@(_blogPage), @"size":@(_blogPageSize)} : @{@"member":@"keyakizaka", @"page":@(_blogPage), @"size":@(_blogPageSize)};
    
    _blogPage = 1;
    
    // 这样直观.清晰点
    NSMutableDictionary *dic = [@{@"page":@(_blogPage), @"size":@(_blogPageSize)} mutableCopy];
    if (_group.length > 0) {
        [dic setObject:_group forKey:@"group"];
    } else if (_memberRome) {
        [dic setObject:_memberRome forKey:@"member"];
    }
    NGWeakObj(self)
    [NGHttpHelp api_blogs:dic done:^(NSError *error, NSString *message, id retData) {
        [selfWeak.blogListTableView.mj_header endRefreshing];
        
        if (error) {
            /// 错误处理
            
        } else {
            NSArray *retArray = retData;
            [selfWeak.blogListArray removeAllObjects];
            for (NSDictionary *blogIofo in retArray) {
                NGBlogListCellModel *model = [NGBlogListCellModel yy_modelWithJSON:blogIofo];
                [selfWeak.blogListArray addObject:model];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [selfWeak.blogListTableView reloadData];
            });
        }
    }];
}

- (void)loadMoreBlogList {
    _blogPage++;
    // 这样直观.清晰点
    NSMutableDictionary *dic = [@{@"page":@(_blogPage), @"size":@(_blogPageSize)} mutableCopy];
    if (_group.length > 0) {
        [dic setObject:_group forKey:@"group"];
    } else if (_memberRome) {
        [dic setObject:_memberRome forKey:@"member"];
    }
    NGWeakObj(self)
    [NGHttpHelp api_blogs:dic done:^(NSError *error, NSString *message, id retData) {
        [selfWeak.blogListTableView.mj_footer endRefreshing];
        if (error) {
            /// 错误处理
        } else {
            /// 这样分页 会有 bug。 加载更多的时候 没办法保证 数据的完整性,一致性(数据数量变化, 如增加, 删除都会导致问题), 最好是 带上 id, 然后 上传 id 字段. 返回上传id 的后 page size
            NSArray *retArray = retData;
            for (NSDictionary *blogIofo in retArray) {
                NGBlogListCellModel *model = [NGBlogListCellModel yy_modelWithJSON:blogIofo];
                [selfWeak.blogListArray addObject:model];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [selfWeak.blogListTableView reloadData];
            });
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark---UITableView delegate and date source

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    static NSString *reuseID = @"NGBlogListCell";
    
    NGBlogListCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if (cell == nil) {
        cell = [[NGBlogListCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseID];
    }

    NGBlogListCellModel *model = _blogListArray[indexPath.row];

    cell.dataModel = model;

    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _blogListArray.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NGBlogListCellModel *model = _blogListArray[indexPath.row];
    NGWebViewVC *webVC = [[NGWebViewVC alloc] initWithURL:model.blogWebUrl];
    webVC.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController pushViewController:webVC animated:YES];
}

@end
