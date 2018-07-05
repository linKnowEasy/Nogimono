//
//  NGBaseVC.h
//  Nogimono
//
//  Created by lingang on 2018/6/26.
//  Copyright © 2018年 none. All rights reserved.
//


typedef void (^ViewClickBlock)(void);

#import <UIKit/UIKit.h>
/// 用来处理一些 基类应该做的事情
@interface NGBaseVC : UIViewController

///// 初始化, 如果 navVC 是 nil, 就自动创建
//- (instancetype)initWithNavVC:(UINavigationController *)navVC;


/// 注意 Block 的循环引用
- (void)ng_leftBtnWithNrlImage:(NSString *)nrlImage title:(NSString *)title action:(ViewClickBlock) btnClickBlock;
/// 注意 Block 的循环引用
- (void)ng_rigthBtnWithNrlImage:(NSString *)nrlImage title:(NSString *)title action:(ViewClickBlock) btnClickBlock;

@end
