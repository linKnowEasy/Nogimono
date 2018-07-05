//
//  UIView+NGFrame.m
//  Nogimono
//
//  Created by lingang on 2018/6/26.
//  Copyright © 2018年 none. All rights reserved.
//

#import "UIView+NGFrame.h"

@implementation UIView (NGFrame)
// 使用 @dynamic 防止 自动生成 get set 方法, category 是不允许有成员变量的
@dynamic ng_top;
@dynamic ng_bottom;
@dynamic ng_left;
@dynamic ng_right;

@dynamic ng_x;
@dynamic ng_y;
@dynamic ng_origin;

@dynamic ng_centerX;
@dynamic ng_centerY;

@dynamic ng_width;
@dynamic ng_height;
@dynamic ng_size;




- (CGFloat)ng_top {
    return self.frame.origin.y;
}

- (void)setTop:(CGFloat)top {
    CGRect frame = self.frame;
    frame.origin.y = top;
    self.frame = frame;
}


- (CGFloat)ng_left {
    return self.frame.origin.x;
}

- (void)setNg_Left:(CGFloat)left {
    CGRect frame = self.frame;
    frame.origin.x = left;
    self.frame = frame;
}

- (CGFloat)ng_bottom {
    return self.frame.size.height + self.frame.origin.y;
}

- (void)setNg_Bottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

- (CGFloat)ng_right {
    return self.frame.size.width + self.frame.origin.x;
}

- (void)setNg_Right:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)ng_x {
    return self.frame.origin.x;
}

- (void)setNg_X:(CGFloat)value {
    CGRect frame = self.frame;
    frame.origin.x = value;
    self.frame = frame;
}

- (CGFloat)ng_y {
    return self.frame.origin.y;
}

- (void)setNg_Y:(CGFloat)value {
    CGRect frame = self.frame;
    frame.origin.y = value;
    self.frame = frame;
}

- (CGPoint)ng_origin {
    return self.frame.origin;
}

- (void)setNg_Origin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGFloat)ng_centerX {
    return self.center.x;
}

- (void)setNg_CenterX:(CGFloat)centerX {
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

- (CGFloat)ng_centerY {
    return self.center.y;
}

- (void)setNg_CenterY:(CGFloat)centerY {
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

- (CGFloat)ng_width {
    return self.frame.size.width;
}

- (void)setNg_Width:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)ng_height {
    return self.frame.size.height;
}

- (void)setNg_Height:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGSize)ng_size {
    return self.frame.size;
}

- (void)setNg_Size:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}




@end
