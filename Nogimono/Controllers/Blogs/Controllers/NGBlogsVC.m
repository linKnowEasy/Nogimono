//
//  NGBlogsVC.m
//  Nogimono
//
//  Created by lingang on 2018/6/26.
//  Copyright © 2018年 none. All rights reserved.
//

#import "NGBlogsVC.h"
#import "NGConstantHeader.h"
#import "NGBlogCell.h"

#import "NGBlogListVC.h"



const static int ButtonTag = 1000;

@interface NGBlogsVC ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *memberCollectionView;

@property (nonatomic, strong) NSMutableArray *nogiMemberDataArray;
@property (nonatomic, strong) NSMutableArray *keyaMemberDataArray;
@property (nonatomic, strong) NSMutableArray *memberDataArray;
/// 页码
@property (nonatomic, assign) NSUInteger blogPage;
/// 页面数
@property (nonatomic, assign) NSUInteger blogPageSize;
/// 罗马音
@property (nonatomic, strong) NSString *rome;
/// 团队/组织
@property (nonatomic, strong) NSString *group;


/// group 切换 按钮
@property (nonatomic, strong) UIButton *allGroupButton;
/// group 切换 按钮
@property (nonatomic, strong) UIButton *nogiGroupButton;
/// group 切换 按钮
@property (nonatomic, strong) UIButton *keyaGroupButton;

@end

@implementation NGBlogsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupData];
    [self setupView];
}
- (void)setupData {
    _memberDataArray = [NSMutableArray array];
    _nogiMemberDataArray = [NSMutableArray array];
    _keyaMemberDataArray = [NSMutableArray array];
}

- (void)setupView {
    NGWeakObj(self)
    self.title = @"坂道成员";
    [self ng_rigthBtnWithNrlImage:nil title:@"最近更新" action:^{
        NSString *group = selfWeak.group.length > 0 ? selfWeak.group : nil;
        NGBlogListVC *vc = [[NGBlogListVC alloc] initWithGroup:group];
        vc.view.backgroundColor = [UIColor whiteColor];
        [selfWeak.navigationController pushViewController:vc animated:YES];
    }];
    
    NSArray *titles = @[@"我全都要", @"高冷紫", @"呆萌绿"];
//    NSArray *titles = @[@"高冷紫", @"呆萌绿"];
    NSArray *titleColors = @[[UIColor blackColor], [UIColor purpleColor], [UIColor greenColor]];
    

    UIStackView *containerView = [[UIStackView alloc] initWithFrame:CGRectMake(0, 0, self.view.ng_width, 200)];
    containerView.axis = UILayoutConstraintAxisHorizontal;
    containerView.distribution = UIStackViewDistributionFillEqually;
    containerView.spacing = 10;
    containerView.alignment = UIStackViewAlignmentFill;
    
    for (NSInteger i = 0; i < titles.count; i++) {
        UIButton *btn = [UIButton new];
        btn.tag = i + ButtonTag;
        [btn setTitle:titles[i] forState:UIControlStateNormal];
        [btn setTitleColor:titleColors[i] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(changeGroup:) forControlEvents:UIControlEventTouchUpInside];
        btn.layer.borderWidth = 1;
        btn.layer.borderColor = NG_HEXCOLOR(NGColors.borderColor).CGColor;
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = 2;
        
        [containerView addArrangedSubview:btn];
    }
    
    [self.view addSubview:containerView];
    
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.right.offset(-10);
        if (@available(iOS 11.0,*)) {
            make.top.equalTo(selfWeak.view.mas_safeAreaLayoutGuideTop).offset(10);
        } else {
            make.top.mas_equalTo(10);
        }
        make.height.mas_equalTo(46);
    }];
    
    
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    // 设置UICollectionView为横向滚动
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    // 每一行cell之间的间距
    flowLayout.minimumLineSpacing = 10;
    // 每一列cell之间的间距
    flowLayout.minimumInteritemSpacing = 10;
    // 设置第一个cell和最后一个cell,与父控件之间的间距
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);

    CGFloat itemWidth = (self.view.ng_width - 40)/3;
    
    flowLayout.itemSize = CGSizeMake(itemWidth, itemWidth + 20);// 该行代码就算不写,item也会有默认尺寸
    
    //    flowLayout.headerReferenceSize = CGSizeMake(self.view.width, 50.0f);
    
    _memberCollectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
    _memberCollectionView.backgroundColor = NG_HEXCOLOR(0xf9f9f9);
    _memberCollectionView.dataSource = self;
    _memberCollectionView.delegate = self;
    
    
    _memberCollectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //刷新时候，需要执行的代码。一般是请求最新数据，请求成功之后，刷新列表
        [selfWeak memberBlog];
    }];
    
    [_memberCollectionView registerClass:[NGBlogCell class] forCellWithReuseIdentifier:@"NGBlogCell"];
    
    [_memberCollectionView.mj_header beginRefreshing];
    
    [self.view addSubview:_memberCollectionView];
    
    [_memberCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.right.offset(0);
        make.top.mas_equalTo(containerView.mas_bottom).offset(10);
        if (@available(iOS 11.0,*)) {
            make.bottom.equalTo(selfWeak.view.mas_safeAreaLayoutGuideBottom);
        } else {
            make.bottom.mas_equalTo(0);
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark--change group
- (void)changeGroup:(UIButton *)btn {
    
    
    switch (btn.tag) {
        case ButtonTag :{
            [_memberDataArray removeAllObjects];
            [_memberDataArray addObjectsFromArray:_nogiMemberDataArray];
            [_memberDataArray addObjectsFromArray:_keyaMemberDataArray];
            _group = @"";
            break;
        }
        case ButtonTag + 1:
            [_memberDataArray removeAllObjects];
            [_memberDataArray addObjectsFromArray:_nogiMemberDataArray];
            _group = @"nogizaka";
            break;
        case ButtonTag + 2 :
            [_memberDataArray removeAllObjects];
            [_memberDataArray addObjectsFromArray:_keyaMemberDataArray];
            _group = @"keyakizaka";
            break;
        default:
            /// do nothing
            break;
    }
    
    [_memberCollectionView reloadData];
    
}

#pragma mark--collocview delegate


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return _memberDataArray.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NGBlogCell *cell =  [collectionView dequeueReusableCellWithReuseIdentifier:@"NGBlogCell" forIndexPath:indexPath];
    if (!cell ) {
        NSLog(@"cell为空,创建cell");
        cell = [[NGBlogCell alloc] initWithFrame:CGRectMake(0, 0, 100, 22)];
    }
    
    NGBlogCellModel *model = self.memberDataArray[indexPath.item];
    cell.dataModel = model;
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NGBlogCellModel *model = self.memberDataArray[indexPath.item];
    NSString *member = model.memberRome;
    NGBlogListVC *vc = [[NGBlogListVC alloc] initWithMember:member];
    vc.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark--API 请求
- (void)memberBlog {
    
    [_memberDataArray removeAllObjects];
    
    NGWeakObj(self)
    
    
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_enter(group);
    NSDictionary *nogiDic = @{@"group":@"nogizaka"};
    [NGHttpHelp api_member_group:nogiDic done:^(NSError *error, NSString *message, id retData) {

        
        if (error) {
            /// 错误处理
            
        } else {
            NSArray *retArray = retData;
            [selfWeak.nogiMemberDataArray removeAllObjects];
            for (NSDictionary *memberInfo in retArray) {
                NGBlogCellModel *model = [NGBlogCellModel yy_modelWithJSON:memberInfo];
                model.memberGroup = nogiDic[@"group"];
                [selfWeak.nogiMemberDataArray addObject:model];
            }
        }
        dispatch_group_leave(group);
    }];
    
    
    
    NSDictionary *keyaDic = @{@"group":@"keyakizaka"};
    dispatch_group_enter(group);
    [NGHttpHelp api_member_group:keyaDic done:^(NSError *error, NSString *message, id retData) {
        if (error) {
            /// 错误处理
            
        } else {
            NSArray *retArray = retData;
            [selfWeak.keyaMemberDataArray removeAllObjects];
            for (NSDictionary *memberInfo in retArray) {
                NGBlogCellModel *model = [NGBlogCellModel yy_modelWithJSON:memberInfo];
                model.memberGroup = keyaDic[@"group"];
                [selfWeak.keyaMemberDataArray addObject:model];
            }
        }
        dispatch_group_leave(group);
    }];
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        /// 刷新UI
        [selfWeak.memberDataArray removeAllObjects];
        [selfWeak.memberDataArray addObjectsFromArray:selfWeak.nogiMemberDataArray];
        [selfWeak.memberDataArray addObjectsFromArray:selfWeak.keyaMemberDataArray];
        [selfWeak.memberCollectionView.mj_header endRefreshing];
        [selfWeak.memberCollectionView reloadData];
    });
}




@end
