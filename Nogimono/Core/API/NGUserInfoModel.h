//
//  NGUserInfoModel.h
//  Nogimono
//
//  Created by lingang on 2018/7/1.
//  Copyright © 2018年 none. All rights reserved.
//

#import <Foundation/Foundation.h>

//private String email;
//private String phone;
//private String nickname;
//private String introduction;
//private int status;
//private int sex ;
//private String avatar ;


@interface NGUserInfoModel : NSObject


typedef void (^NGCompleteBlock)(NSError *error, NSString *message);

+ (NGUserInfoModel *)sharedInstance;
/// 用户 ID
@property (nonatomic, copy) NSString *userID;
/// 用户 token
@property (nonatomic, copy) NSString *token;
/// 用户邮箱
@property (nonatomic, copy) NSString *email;
/// 用户手机号码
@property (nonatomic, copy) NSString *phone;
/// 用户昵称
@property (nonatomic, copy) NSString *nickname;
/// 用户简介
@property (nonatomic, copy) NSString *introduction;
/// 用户头像
@property (nonatomic, copy) NSString *userIconUrl;
/// 用户状态
@property (nonatomic, assign) int status;
/// 用户 性别
@property (nonatomic, assign) int sex;
/// 用户 性别 文字
@property (nonatomic, copy, readonly) NSString *sexString;
/// 用户登录状态
@property (nonatomic, assign) BOOL isLogin;

/// 获取用户信息
- (void)getUserInfo:(NGCompleteBlock)completeBlock;
/// 更新用户信息
- (void)updateUserInfo:(NSDictionary *)dic block:(NGCompleteBlock) completeBlock;

@end
