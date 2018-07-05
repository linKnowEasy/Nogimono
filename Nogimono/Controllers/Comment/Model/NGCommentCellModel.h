//
//  NGCommentModel.h
//  Nogimono
//
//  Created by lingang on 2018/7/3.
//  Copyright © 2018年 none. All rights reserved.
//

#import "NGBaseModel.h"
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, NGCommentCellStyle) {
    NGCommentCellStyle_Header,
    NGCommentCellStyle_Cell,
};


@interface NGCommentCellModel : NGBaseModel


//{
//    "author": {
//        "avatar": 头像链接,
//        "id": 用户ID,
//        "nickname": 用户昵称
//    },
//    "children": [
//                 {
//                     "author": {
//                         "avatar": 头像链接,
//                         "id": 用户ID,
//                         "nickname": 用户昵称
//                     },
//                     "floor": 副评论所在楼层,
//                     "id": 评论ID,
//                     "message": 评论文字,
//                     "post": 时戳
//                 },
//                 ... //每个主评论最多显示5条副评论，时间倒序
//                 ],
//    "floor": 主评论所在楼层,
//    "id": 评论ID,
//    "message": 评论文字,
//    "post": 时戳
//}



/// 是否已经展开过更多评论
@property (nonatomic, assign) BOOL expanded;

/// 评论员 头像
@property (nonatomic, copy) NSString *authorIcon;
/// 评论员 ID
@property (nonatomic, copy) NSString *authorID;
/// 评论员 昵称
@property (nonatomic, copy) NSString *authorNickname;

/// 回复对象  头像
@property (nonatomic, copy) NSString *toAuthorIcon;
/// 回复对象  ID
@property (nonatomic, copy) NSString *toAuthorID;
/// 回复对象  昵称
@property (nonatomic, copy) NSString *toAuthorNickname;


/// 评论 楼层
@property (nonatomic, copy) NSString *commentFloor;
/// 评论 ID
@property (nonatomic, copy) NSString *commentID;
/// 评论 内容
@property (nonatomic, copy) NSString *commentMessage;
/// 评论 时间
@property (nonatomic, copy) NSString *commentPost;

/// 评论 楼层
@property (nonatomic, copy, readonly) NSString *commentFloorStr;

/// 评论 时间
@property (nonatomic, copy, readonly) NSString *commentTime;


/// cell 高度计算
@property (nonatomic, assign, readonly) CGFloat sectionHeigth;
/// cell 高度计算
@property (nonatomic, assign, readonly) CGFloat rowHeigth;

@property (nonatomic, strong) NSArray *childDic;

@property (nonatomic, strong) NSMutableArray<NGCommentCellModel *> *child;


@end
