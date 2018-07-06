//
//  NGInputVC.h
//  Nogimono
//
//  Created by lingang on 2018/7/5.
//  Copyright © 2018年 none. All rights reserved.
//

#import "NGBaseVC.h"


//添加评论
typedef void (^InputBlock)(NSString *inputText);

/// 这个类只有一个输入框与保存 按钮
@interface NGInputVC : NGBaseVC

@property (nonatomic, copy) InputBlock inputBlock;
@property (nonatomic, copy) NSString *inputTitle;

@property (nonatomic, copy) NSString *originalValue;

@end
