//
//  NGWebWithCommentVC.m
//  Nogimono
//
//  Created by lingang on 2018/7/3.
//  Copyright © 2018年 none. All rights reserved.
//

#import "NGWebWithCommentVC.h"
#import <WebKit/WebKit.h>
#import "NGConstantHeader.h"
#import "NGCommentCellModel.h"
#import "NGCommentCell.h"

#import "ReplyInputView.h"
#import "NGCommentInputView.h"
#import "NGUserInfoModel.h"

#import "NGLoginVC.h"


@interface NGWebWithCommentVC ()<WKUIDelegate, WKScriptMessageHandler, WKNavigationDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) WKWebView *ngWebView;
@property (nonatomic, strong) UIProgressView *progressView;

@property (nonatomic, copy) NSString *webURL;
@property (nonatomic, copy) NSString *newsID;

@property (nonatomic, strong) UITableView *commentTableView;

@property (nonatomic, strong) NSMutableArray *commentList;

/// 评论 页码
@property (nonatomic, assign) NSUInteger commentPage;
/// 评论 页面 数量
@property (nonatomic, assign) NSUInteger commentPageSize;


@property (nonatomic, strong) NGCommentInputView *commentView;

/// 用于view的移动，使评论框落在cell下面，没想到别的方法
@property (nonatomic, assign) float replyViewDraw;

@end

@implementation NGWebWithCommentVC

- (instancetype)initWithURL:(NSString *)webURL newsID:(NSString *)newsID; {
    self = [super init];
    if (self) {
        _webURL = webURL;
        _newsID = newsID;
    }
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    // 添加对键盘的监控
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupData];
    [self setupView];
    
    [self loadURL:_webURL];
    [self loadMoreCommentList];
}


- (void)loadURL:(NSString *)webURL {
    //    //loadFileURL方法通常用于加载服务器的HTML页面或者JS，而loadHTMLString通常用于加载本地HTML或者JS
    //    NSString *htmlPath = [[NSBundle mainBundle] pathForResource:@"WKWebViewMessageHandler" ofType:@"html"];
    //    NSString *fileURL = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
    //    NSURL *baseURL = [NSURL fileURLWithPath:htmlPath];
    //    [_ngWebView loadHTMLString:fileURL baseURL:baseURL];
    if (webURL.length == 0) {
        return ;
    }
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:_webURL]];
    
    [_ngWebView loadRequest:request];
}

- (void)setupData {
    _commentList = [NSMutableArray array];
    _commentPage = 0;
    _commentPageSize = 10;
}

- (void)setupView {
    NGWeakObj(self)
    [self ng_leftBtnWithNrlImage:MaterialIconCode.arrow_back title:@"" action:^{
        [selfWeak.navigationController popViewControllerAnimated:YES];
    }];
    
    //创建并配置WKWebView的相关参数
    //1.WKWebViewConfiguration:是WKWebView初始化时的配置类，里面存放着初始化WK的一系列属性；
    //2.WKUserContentController:为JS提供了一个发送消息的通道并且可以向页面注入JS的类，WKUserContentController对象可以添加多个scriptMessageHandler；
    //3.addScriptMessageHandler:name:有两个参数，第一个参数是userContentController的代理对象，第二个参数是JS里发送postMessage的对象。添加一个脚本消息的处理器,同时需要在JS中添加，window.webkit.messageHandlers.<name>.postMessage(<messageBody>)才能起作用。
    
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    WKUserContentController *userContentController = [[WKUserContentController alloc] init];
    /// js 回调
    //    [userContentController addScriptMessageHandler:self name:@"paymentState"];
    
    configuration.userContentController = userContentController;
    
    
    WKPreferences *preferences = [WKPreferences new];
    preferences.javaScriptCanOpenWindowsAutomatically = YES;
    configuration.preferences = preferences;
    
    _ngWebView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:configuration];
    [_ngWebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    
    
    
    _ngWebView.UIDelegate = self;
    _ngWebView.navigationDelegate = self;
    
    [self ng_leftBtnWithNrlImage:MaterialIconCode.arrow_back title:@"" action:^{
        [selfWeak.navigationController popViewControllerAnimated:YES];
    }];
    
    
    CGRect frame = self.view.bounds;
    frame.size.height = frame.size.height - 54;
    _commentTableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStyleGrouped];
    _commentTableView.backgroundColor = [UIColor whiteColor];
    _commentTableView.delegate = self;
    _commentTableView.dataSource = self;
    
    _commentTableView.tableHeaderView = _ngWebView;
    
//    _commentTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
//        // 加载更多.
//        [selfWeak loadMoreCommentList];
//    }];
    
//    [_commentTableView.mj_footer beginRefreshing];

    
    _commentTableView.tableFooterView = [UIView new];
    
    [_commentTableView.mj_header beginRefreshing];
    
    
    [self.view addSubview:_commentTableView];
    

    _commentView = [[NGCommentInputView alloc] initWithFrame:CGRectMake(0, frame.size.height - 44, self.view.ng_width, 54)];
    _commentView.comentID = @"";
    _commentView.toUserID = @"";
    _commentView.inputTextView.text = @"";
    _commentView.placeholderString = @"评论文章";
    [self.view addSubview:_commentView];
    
    _commentView.contentSizeBlock = ^(CGSize contentSize) {
        float height = contentSize.height + 20;
        CGRect frame = selfWeak.commentView.frame;
        frame.origin.y -= height - frame.size.height;  //高度往上拉伸
        frame.size.height = height;
        selfWeak.commentView.frame = frame;
    };
    
    _commentView.replayBlock = ^(NSString *replyText, NSString *inCommentID, NSString *toUserID) {
        
        if ([NGUserInfoModel sharedInstance].token.length == 0) {
            UIViewController *vc = [NGLoginVC NGLoginPresent];
            [selfWeak presentViewController:vc animated:YES completion:nil];
            return ;
        }
        
        NSLog(@"replyText is %@, to %@, in %@", replyText, toUserID, inCommentID);
        [selfWeak sendComment:replyText ToUser:toUserID In:inCommentID];
    };


    
//    [self.view addSubview:_ngWebView];
    
    
    /// 加载进度条
    self.progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 64, self.view.ng_width, 2)];
    self.progressView.backgroundColor = [UIColor blueColor];
    //设置进度条的高度，下面这句代码表示进度条的宽度变为原来的1倍，高度变为原来的1.5倍.
    self.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
    
    [self.view addSubview:self.progressView];
    
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0,*)) {
            make.top.equalTo(selfWeak.view.mas_safeAreaLayoutGuideTop);
        } else {
            make.top.mas_equalTo(64);
        }
        //        make.top.mas_equalTo(vpnBGView.mas_bottom);
        make.left.offset(0);
        make.right.offset(0);
        make.height.mas_equalTo(2);
    }];
    
    //    [_ngWebView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        if (@available(iOS 11.0,*)) {
    //            //            make.top.equalTo(selfWeak.view.mas_safeAreaLayoutGuideTop);
    //            make.bottom.equalTo(selfWeak.view.mas_safeAreaLayoutGuideBottom);
    //        } else {
    //            //            make.top.mas_equalTo(64);
    //            make.bottom.mas_equalTo(0);
    //        }
    //        make.top.mas_equalTo(vpnBGView.mas_bottom);
    //        make.left.offset(0);
    //        make.right.offset(0);
    //    }];
    
    

    

    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma makr---API
- (void)loadMoreCommentList {
    // 这样直观.清晰点
    
    NSDictionary *dic = _newsID != nil? @{@"fid": _newsID} : @{};

    NGWeakObj(self)
    [NGHttpHelp api_news_comments:dic done:^(NSError *error, NSString *message, id retData) {
        NSLog(@"api_news_comments retData==%@", retData);
        [selfWeak.commentTableView.mj_footer endRefreshing];
        if (error) {
            /// 错误处理
        } else {
            /// 这样分页 会有 bug。 加载更多的时候 没办法保证 数据的完整性,一致性(数据数量变化, 如增加, 删除都会导致问题), 最好是 带上 id, 然后 上传 id 字段. 返回上传id 的后 page size
            NSDictionary *retDic = retData;
            NSString *code = retDic[@"code"];
            
            if (code.intValue != 200) {
                NSLog(@"error----%@",retDic[@"message"] );
                return ;
            }
            
            NSArray *retArray = retDic[@"data"];
            
            [selfWeak.commentList removeAllObjects];
            for (NSDictionary *commentIofo in retArray) {
                NGCommentCellModel *model = [NGCommentCellModel yy_modelWithJSON:commentIofo];
                [selfWeak.commentList addObject:model];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [selfWeak.commentTableView reloadData];
            });
        }
    }];
}
/// 楼层中的更多评论
- (void)loadMoreFloorCommentList:(NGCommentCellModel *)model {
    // 这样直观.清晰点
    NSDictionary *dic =  @{@"cid": model.commentID};
    
    NGWeakObj(self)
    [NGHttpHelp api_send_comment:dic done:^(NSError *error, NSString *message, id retData) {
        NSLog(@"api_news_comments retData==%@", retData);
        
        if (error) {
            /// 错误处理
        } else {
            /// 这样分页 会有 bug。 加载更多的时候 没办法保证 数据的完整性,一致性(数据数量变化, 如增加, 删除都会导致问题), 最好是 带上 id, 然后 上传 id 字段. 返回上传id 的后 page size
            NSDictionary *retDic = retData;
            NSString *code = retDic[@"code"];
            
            if (code.intValue != 200) {
                NSLog(@"error----%@",retDic[@"message"] );
                return ;
            }
            
            NSArray *retArray = retDic[@"data"];
            [model.child removeAllObjects];
            
            for (NSDictionary *commentIofo in retArray) {
                NGCommentCellModel *model = [NGCommentCellModel yy_modelWithJSON:commentIofo];
                [model.child addObject:model];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [selfWeak.commentTableView reloadData];
            });
        }
    }];
}

- (void)sendComment:(NSString *)comment ToUser:(NSString *)toUid In:(NSString *)cid{
    // 这样直观.清晰点

    NSString *uid = [NGUserInfoModel sharedInstance].userID;
    NSString *token = [NGUserInfoModel sharedInstance].token;
    NSString *toUserID = toUid.length != 0 ? toUid: @"";
    
    NSString *inCommentID = cid.length != 0 ? cid: @"";

    
    NSDictionary *dic =@{@"fid": _newsID, @"uid":uid, @"token":token, @"message":comment, @"father":inCommentID, @"touid":toUserID };
    
    NGWeakObj(self)
    [NGHttpHelp api_send_comment:dic done:^(NSError *error, NSString *message, id retData) {
        NSLog(@"api_send_comment retData==%@", retData);
        
        if (error) {
            /// 错误处理
        } else {
            /// 这样分页 会有 bug。 加载更多的时候 没办法保证 数据的完整性,一致性(数据数量变化, 如增加, 删除都会导致问题), 最好是 带上 id, 然后 上传 id 字段. 返回上传id 的后 page size
            NSDictionary *retDic = retData;
            NSString *code = retDic[@"code"];

            if (code.intValue != 200) {
                NSLog(@"error----%@",retDic[@"message"] );
                return ;
            }
            selfWeak.commentView.inputTextView.text = @"";
            selfWeak.commentView.placeholderString = @"评论文章";
            [selfWeak.view endEditing:YES];
//
//            NSArray *retArray = retDic[@"data"];
//            [selfWeak.commentList removeAllObjects];
//            for (NSDictionary *commentIofo in retArray) {
//                NGCommentCellModel *model = [NGCommentCellModel yy_modelWithJSON:commentIofo];
//                [selfWeak.commentList addObject:model];
//            }
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [selfWeak.commentTableView reloadData];
//            });
        }
    }];
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        self.progressView.progress = _ngWebView.estimatedProgress;
        if (self.progressView.progress == 1) {
            /*
             *添加一个简单的动画，将progressView的Height变为1.4倍，在开始加载网页的代理中会恢复为1.5倍
             *动画时长0.25s，延时0.3s后开始动画
             *动画结束后将progressView隐藏
             */
            NGWeakObj(self)
            [UIView animateWithDuration:0.25f delay:0.3f options:UIViewAnimationOptionCurveEaseOut animations:^{
                selfWeak.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.4f);
            } completion:^(BOOL finished) {
                selfWeak.progressView.hidden = YES;
            }];
        }
    }
}

#pragma mark - WKUIDelegate
- (void)ngWebView:(WKWebView *)ngWebView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler
{
    
    //    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提醒" message:message preferredStyle:UIAlertControllerStyleAlert];
    //    [alert addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    //        completionHandler();
    //    }]];
    //
    //    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark -- WKScriptMessageHandler
/**
 *  JS 调用 OC 时 ngWebView 会调用此方法
 *
 *  @param userContentController  webview中配置的userContentController 信息
 *  @param message                JS执行传递的消息
 */

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    //JS调用OC方法
    //message.boby就是JS里传过来的参数
    NSLog(@"body:%@",message.body);
    
}


#pragma mark----WKNavigationDelegate

//开始加载
- (void)ngWebView:(WKWebView *)ngWebView didStartProvisionalNavigation:(WKNavigation *)navigation {
    NSLog(@"开始加载网页");
    //开始加载网页时展示出progressView
    self.progressView.hidden = NO;
    //开始加载网页的时候将progressView的Height恢复为1.5倍
    self.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
    //防止progressView被网页挡住
    [self.view bringSubviewToFront:self.progressView];
}

/// 加载完成
- (void)ngWebView:(WKWebView *)ngWebView didFinishNavigation:(WKNavigation *)navigation {
    
}


//加载失败
- (void)ngWebView:(WKWebView *)ngWebView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"加载失败");
    //加载失败同样需要隐藏progressView
    //self.progressView.hidden = YES;
}

#pragma mark---UITableView delegate and date source

/// 一个 section 代表一楼评论, cell 代表楼内评论
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSLog(@"section ==%d", _commentList.count);
    return _commentList.count;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NGCommentCellModel *model = _commentList[section];
    NSLog(@"cell ==%d", model.child.count);
    /// +1 是为了有查看更多的按钮
    
//    if (model.child.count > 5 && !model.expanded) {
//        return 6 + 1;
//    }
    
    return model.child.count;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NGCommentCellModel *model = _commentList[section];
    NGCommentCell *cell = [[NGCommentCell alloc] initHeaderWithFrame:CGRectMake(0, 0, tableView.ng_width, 80)];
    cell.dataModel = model;

    cell.tag = section;
    cell.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headerIsTapEvent:)];
    [cell addGestureRecognizer:tap];

    return cell;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    static NSString *reuseID = @"NGCommentCell";
    NGCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if (cell == nil) {
        cell = [[NGCommentCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    NGCommentCellModel *sectionModel = _commentList[indexPath.section];
    /// 点击查看更多的功能先不做, 用户量应该没有那么多, 等有了再调整
    if (sectionModel.child.count == indexPath.row) {
        NGWeakObj(self)
        cell.dataModel = nil;
        
        cell.loadMoreBlock = ^{
            sectionModel.expanded = YES;
            [self.commentTableView reloadData];
//            [selfWeak loadMoreFloorCommentList:sectionModel];
        };
        return cell;
    }
    NGCommentCellModel *model = sectionModel.child[indexPath.row];
    cell.dataModel = model;
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NGCommentCellModel *sectionModel = _commentList[indexPath.section];
    
    NGCommentCellModel *model = sectionModel.child[indexPath.row];
    return model.rowHeigth;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    NGCommentCellModel *sectionModel = _commentList[section];
    return sectionModel.sectionHeigth;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NGCommentCellModel *sectionModel = _commentList[indexPath.section];
    
    NGCommentCellModel *model = sectionModel.child[indexPath.row];

    
    NGCommentCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    _replyViewDraw = [cell convertRect:cell.bounds toView:self.view.window].origin.y + cell.ng_height;

    _commentView.comentID = sectionModel.commentID;
    _commentView.toUserID = model.authorID;
    _commentView.inputTextView.text = @"";
        _commentView.placeholderString = [NSString stringWithFormat:@"回复 %@", model.authorNickname];
    [_commentView.inputTextView becomeFirstResponder];
}

- (void)headerIsTapEvent:(UITapGestureRecognizer *)sender {
    
    NSInteger section = sender.view.tag;
    NGCommentCellModel *sectionModel = _commentList[section];
    
    NGCommentCell *cell = (NGCommentCell *)[self.commentTableView headerViewForSection:section];
    
    _replyViewDraw = [cell convertRect:cell.bounds toView:self.view.window].origin.y + cell.ng_height;
    

    _commentView.comentID = sectionModel.commentID;
    _commentView.toUserID = sectionModel.authorID;
    _commentView.inputTextView.text = @"";
    _commentView.placeholderString = [NSString stringWithFormat:@"回复 %@", sectionModel.authorNickname];
    [_commentView.inputTextView becomeFirstResponder];
}



#pragma mark----keyboard show

- (void)keyChange:(NSNotification *) notify {
    NSDictionary *dic = notify.userInfo;
    CGRect keyboardRect = [dic[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    NGWeakObj(self)
    if (keyboardRect.size.height >250 ) {
        [UIView animateWithDuration:[dic[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
            
            [UIView setAnimationCurve:[dic[UIKeyboardAnimationCurveUserInfoKey] doubleValue]];
            
            CGRect frame = selfWeak.commentView.frame;
            frame.origin.y = frame.origin.y - keyboardRect.size.height + 52;
            selfWeak.commentView.frame = frame;
            
            CGPoint point = selfWeak.commentTableView.contentOffset;
            
            point.y -= (frame.origin.y - selfWeak.replyViewDraw);
            selfWeak.commentTableView.contentOffset = point;
        }];

    }
}

- (void)keyBoardWillShow:(NSNotification *) note {
    // 获取用户信息
    NSDictionary *userInfo = [NSDictionary dictionaryWithDictionary:note.userInfo];
    // 获取键盘高度
    CGRect keyBoardBounds  = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyBoardHeight = keyBoardBounds.size.height;
    // 获取键盘动画时间
    CGFloat animationTime  = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    // 定义好动作
    NGWeakObj(self)
    void (^animation)(void) = ^void(void) {
        selfWeak.commentView.transform = CGAffineTransformMakeTranslation(0, - keyBoardHeight + 44);
    };
    
    if (animationTime > 0) {
        [UIView animateWithDuration:animationTime animations:animation];
    } else {
        animation();
    }
    
}

- (void)keyBoardWillHide:(NSNotification *) note {
    // 获取用户信息
    NSDictionary *userInfo = [NSDictionary dictionaryWithDictionary:note.userInfo];
    // 获取键盘动画时间
    CGFloat animationTime  = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    // 定义好动作
    NGWeakObj(self)
    void (^animation)(void) = ^void(void) {
        selfWeak.commentView.transform = CGAffineTransformIdentity;
    };
    
    if (animationTime > 0) {
        [UIView animateWithDuration:animationTime animations:animation];
    } else {
        animation();
    }
}


@end
