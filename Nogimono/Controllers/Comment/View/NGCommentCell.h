//
//  NGCommentCell.h
//  Nogimono
//
//  Created by lingang on 2018/7/3.
//  Copyright © 2018年 none. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NGCommentCellModel.h"

/// 添加评论 内容与 回复对象


/// 添加评论 内容与 回复对象
typedef void (^LoadMoreBlock)();

@interface NGCommentCell : UITableViewCell


@property (nonatomic, copy) LoadMoreBlock loadMoreBlock;

@property (nonatomic, strong) NGCommentCellModel *dataModel;



+ (CGFloat)heightNGCommentCellWithModel:(NGCommentCellModel *)model;

+ (CGFloat)heightNGCommentSectionWithModel:(NGCommentCellModel *)model;

- (instancetype)initHeaderWithFrame:(CGRect)frame;




@end
