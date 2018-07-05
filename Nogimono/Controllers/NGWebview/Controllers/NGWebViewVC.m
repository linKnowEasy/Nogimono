//
//  NGWebViewVC.m
//  Nogimono
//
//  Created by lingang on 2018/6/28.
//  Copyright © 2018年 none. All rights reserved.
//

#import "NGWebViewVC.h"
#import <WebKit/WebKit.h>
#import "NGConstantHeader.h"

@interface NGWebViewVC ()<WKUIDelegate, WKScriptMessageHandler, WKNavigationDelegate>

@property (nonatomic, strong) WKWebView *ngWebView;
@property (nonatomic, strong) UIProgressView *progressView;

@property (nonatomic, copy) NSString *webURL;

@end

@implementation NGWebViewVC



- (instancetype)initWithURL:(NSString *)webURL {
    self = [super init];
    if (self) {
        _webURL = webURL;
    }
    
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupView];
    
    [self loadURL:_webURL];
}

- (void)loadURL:(NSString *)webURL {
    //    //loadFileURL方法通常用于加载服务器的HTML页面或者JS，而loadHTMLString通常用于加载本地HTML或者JS
    //    NSString *htmlPath = [[NSBundle mainBundle] pathForResource:@"WKWebViewMessageHandler" ofType:@"html"];
    //    NSString *fileURL = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
    //    NSURL *baseURL = [NSURL fileURLWithPath:htmlPath];
    //    [self.ngWebView loadHTMLString:fileURL baseURL:baseURL];
    if (webURL.length == 0) {
        return ;
    }
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:_webURL]];
    
    [self.ngWebView loadRequest:request];
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
    
    self.ngWebView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:configuration];
    [self.ngWebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    
    

    self.ngWebView.UIDelegate = self;
    self.ngWebView.navigationDelegate = self;
    [self.view addSubview:self.ngWebView];
    
    
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
    
//    [self.ngWebView mas_makeConstraints:^(MASConstraintMaker *make) {
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

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        self.progressView.progress = self.ngWebView.estimatedProgress;
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

@end
