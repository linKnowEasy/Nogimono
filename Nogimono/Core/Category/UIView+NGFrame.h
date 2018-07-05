//
//  UIView+NGFrame.h
//  Nogimono
//
//  Created by lingang on 2018/6/26.
//  Copyright © 2018年 none. All rights reserved.
//

#import <UIKit/UIKit.h>
/// 方便 View 处理, 增加前缀, 防止后期与第三方库 冲突
@interface UIView (NGFrame)
@property (nonatomic, assign) CGFloat ng_top;
@property (nonatomic, assign) CGFloat ng_bottom;
@property (nonatomic, assign) CGFloat ng_left;
@property (nonatomic, assign) CGFloat ng_right;

@property (nonatomic, assign) CGFloat ng_x;
@property (nonatomic, assign) CGFloat ng_y;
@property (nonatomic, assign) CGPoint ng_origin;

@property (nonatomic, assign) CGFloat ng_centerX;
@property (nonatomic, assign) CGFloat ng_centerY;

@property (nonatomic, assign) CGFloat ng_width;
@property (nonatomic, assign) CGFloat ng_height;
@property (nonatomic, assign) CGSize  ng_size;
@end
