//
//  NGCommentModel.m
//  Nogimono
//
//  Created by lingang on 2018/7/3.
//  Copyright © 2018年 none. All rights reserved.
//

#import "NGCommentCellModel.h"
#import "NSString+NGUtils.h"
#import "NGConstantHeader.h"
#import "NGCommentCell.h"


@implementation NGCommentCellModel


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

///// 评论员 头像
//@property (nonatomic, copy) NSString *authorIcon;
///// 评论员 ID
//@property (nonatomic, copy) NSString *authorID;
///// 评论员 昵称
//@property (nonatomic, copy) NSString *authorNickname;
//
///// 评论 楼层
//@property (nonatomic, copy) NSString *commentFloor;
///// 评论 ID
//@property (nonatomic, copy) NSString *commentID;
///// 评论 内容
//@property (nonatomic, copy) NSString *commentMessage;
///// 评论 时间
//@property (nonatomic, copy) NSString *commentPost;


+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"authorIcon" : @"user.avatar",
             @"authorID" : @"user.id",
             @"authorNickname" : @"user.nickname",
             @"toAuthorIcon" : @"touser.avatar",
             @"toAuthorID" : @"touser.id",
             @"toAuthorNickname" : @"touser.nickname",
             @"commentFloor" : @"floor",
             @"commentID" : @"cid",
             @"commentMessage" : @"msg",
             @"commentPost" : @"time",
             @"childDic":@"child"
             };
}

- (NSString *)commentTime {
    
    return self.commentPost;
}

- (NSString *)commentFloorStr {
    if (self.commentFloor.length > 0) {
        return [NSString stringWithFormat:@"# %@", self.commentFloor];
    }
    return nil;
}

-(void)setChildDic:(NSArray *)childDic {
    _childDic = childDic;
    NSMutableArray *child = [NSMutableArray array];
    for (NSDictionary *dic in _child) {
        NGCommentCellModel *model = [NGCommentCellModel yy_modelWithJSON:dic];
        [child addObject:model];
    }
    
    _child = [child mutableCopy];
}

- (CGFloat)sectionHeigth {
    
    return [NGCommentCell heightNGCommentSectionWithModel:self];
}

- (CGFloat)rowHeigth {
    return [NGCommentCell heightNGCommentCellWithModel:self];
}


@end
