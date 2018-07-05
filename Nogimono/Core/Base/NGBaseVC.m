//
//  NGBaseVC.m
//  Nogimono
//
//  Created by lingang on 2018/6/26.
//  Copyright © 2018年 none. All rights reserved.
//

#import "NGBaseVC.h"
#import <objc/runtime.h>
#import "MaterialIcon.h"

/// 利用关联对象 做 block 回调, key 其实是 btnClickAction 的指针地址
static char *btnClickAction;


@interface NGBaseVC ()

@property (nonatomic, strong) UIButton *navLeftBtn;
@property (nonatomic, strong) UIButton *navRightBtn;

@property (nonatomic, strong) UINavigationController *navVC;

@end

@implementation NGBaseVC

- (instancetype)init {
    if (self = [super init]) {
        // 这里可以做对各个系统的 适配处理. 类似 edges, extendedLayout 等
    }
    return self;
}

//- (instancetype)initWithNavVC:(UINavigationController *)navVC {
//    if (self = [super init]) {
//        // 这里可以做对各个系统的 适配处理. 类似 edges, extendedLayout 等
//
//        _navVC = navVC? : [[UINavigationController alloc] initWithRootViewController:self];
//
//    }
//    return self;
//}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark----自定义导航栏的按钮

- (void)ng_leftBtnWithNrlImage:(NSString *)nrlImage title:(NSString *)title action:(ViewClickBlock) btnClickBlock {
    self.navLeftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.navLeftBtn setBackgroundColor:[UIColor clearColor]];
    objc_setAssociatedObject(self.navLeftBtn, &btnClickAction, btnClickBlock, OBJC_ASSOCIATION_COPY);
    [self actionCustomNavBtn:self.navLeftBtn nrlImage:nrlImage  title:title];
    /// 如果需要 调整间距 可以使用 negativeSpacer 来调整
    /// UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    // negativeSpacer.width = - 4;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.navLeftBtn];
}
- (void)ng_rigthBtnWithNrlImage:(NSString *)nrlImage title:(NSString *)title action:(ViewClickBlock) btnClickBlock {
    self.navRightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    objc_setAssociatedObject(self.navRightBtn, &btnClickAction, btnClickBlock, OBJC_ASSOCIATION_COPY);
    [self actionCustomNavBtn:self.navRightBtn nrlImage:nrlImage title:title];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.navRightBtn];
}


- (void)actionCustomNavBtn:(UIButton *)btn nrlImage:(NSString *)nrlImage title:(NSString *)title {
    
    UIImage *nrlShowImage = [UIImage imageNamed:nrlImage];
    
    if (!nrlShowImage && nrlImage) {
        nrlShowImage = [MaterialIcon ImageWithIcon:nrlImage iconColor:[UIColor blackColor] iconSize:30 imageSize:CGSizeMake(30, 30)];
    }
    
    
    [btn setImage:nrlShowImage forState:UIControlStateNormal];

    if (title) {
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:16.];
        [btn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [btn setTitle:title forState:UIControlStateNormal];
        [btn setTitle:title forState:UIControlStateHighlighted];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    }
    [btn sizeToFit];
    [btn addTarget:self action:@selector(actionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
}

#pragma mark--actionBtnClick
- (void)actionBtnClick:(UIButton *)btn {
    void (^btnClickBlock) (void) = objc_getAssociatedObject(btn, &btnClickAction);
//    ViewClickBlock block = objc_getAssociatedObject(btn, &btnClickAction);
//
//    if (block) {
//        block();
//    }
    btnClickBlock();
}


@end
