//
//  NGNewsTypeModel.h
//  Nogimono
//
//  Created by lingang on 2018/6/28.
//  Copyright © 2018年 none. All rights reserved.
//

#import "NGBaseModel.h"

@interface NGNewsTypeModel : NGBaseModel

/// API 需要的 type
@property (nonatomic, copy) NSString *type;

/// 显示的 title
@property (nonatomic, copy) NSString *title;

/// 页码
@property (nonatomic, assign) NSUInteger newsPage;

/// 页面数
@property (nonatomic, assign) NSUInteger newsPageSize;
//
///// 列表数据 ？？？
//@property (nonatomic, strong) NSMutableArray *dataArray;


@end
