//
//  NGBlogList.h
//  Nogimono
//
//  Created by lingang on 2018/6/27.
//  Copyright © 2018年 none. All rights reserved.
//

#import "NGBaseVC.h"




@interface NGBlogListVC : NGBaseVC

/// 根据 group 处理.
- (instancetype)initWithGroup:(NSString *)group;
/// 根据 member 处理.
- (instancetype)initWithMember:(NSString *)member;

@end
