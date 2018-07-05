//
//  NGCommentInputView.h
//  Nogimono
//
//  Created by lingang on 2018/7/4.
//  Copyright © 2018年 none. All rights reserved.
//

#import <UIKit/UIKit.h>

/// textview 高度变动
typedef void (^ContentSizeBlock)(CGSize contentSize);
/// 添加评论 内容与 回复对象
typedef void (^ReplyBlock)(NSString *replyText, NSString *inCommentID, NSString *toUserID);

@interface NGCommentInputView : UIView

@property (nonatomic, strong) UITextView *inputTextView;

/// 回复的评论 ID
@property (nonatomic, copy) NSString *comentID;
/// 回复对象的 id
@property (nonatomic, copy) NSString *toUserID;
/// 占位文字
@property (nonatomic, copy) NSString *placeholderString;
/// 回复按钮 点击事件
@property (nonatomic, copy) ReplyBlock replayBlock;
/// 高度变动回调
@property (nonatomic, copy) ContentSizeBlock contentSizeBlock;

@end
