//
//  NGHttpHelp.h
//  Nogimono
//
//  Created by lingang on 2018/6/26.
//  Copyright © 2018年 none. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^NGHttpBlock)(NSError *error, NSString *message, id retData);

static const NSString *NGBaseURL = @"https://nogimono.tk";

static const NSString *NGBaseWebURL = @"https://nogimono.tk/";

/// 这些变量名直接从 Android 复制过来
/// 开通博客的成员
static const NSString *DATA_MEMBERLIST = @"/data/memberlist";
static const NSString *PATH_BLOGS = @"/data/blogs";
static const NSString *PATH_NEWS = @"/data/list";

static const NSString *PATH_NEWS_ALL = @"getall";
static const NSString *PATH_NEWS_BLOGS = @"getblog";
static const NSString *PATH_NEWS_NEWS = @"getnews";
static const NSString *PATH_NEWS_MAGAZINE = @"getmagazine";


static const NSString *PATH_REGISTER = @"/api/user/new";
static const NSString *PATH_LOGIN_PHONE = @"/api/user/login/phone";
static const NSString *PATH_LOGIN_EMAIL = @"/api/user/login/email";
static const NSString *PATH_LOGIN_NICKNAME = @"/api/user/login/nickname";
static const NSString *PATH_USERINFO = @"/api/user/get";
static const NSString *PATH_USERSET = @"/api/user/userset";

static const NSString *PATH_COMMENT_ALL = @"/api/comment/get";
static const NSString *PATH_COMMENT_NEW  = @"/api/comment/new";
static const NSString *PATH_OTHERUSER = @"/api/user/getother";

static const NSString *PATH_COMMENT_DEL = @"/api/comment/delete";
static const NSString *PATH_COMMENT_UNREAD = @"/api/comment/unread";
static const NSString *PATH_COMMENT_READ = @"/api/comment/read";
static const NSString *PATH_USER_AVATAR = @"/api/user/avatar";
static const NSString *PATH_COMMENT_FLOOR = @"/api/comment/floor";



@interface NGHttpHelp : NSObject





/// 成员信息
+ (void)api_member_group:(NSDictionary *)parameters done:(NGHttpBlock)block;
/// blog 信息
+ (void)api_blogs:(NSDictionary *)parameters done:(NGHttpBlock)block;
/// news 信息
+ (void)api_news:(NSDictionary *)parameters done:(NGHttpBlock)block;

/// 注册
+ (void)api_regist:(NSDictionary *)parameters done:(NGHttpBlock)block;

/// 登录
+ (void)api_login:(NSDictionary *)parameters done:(NGHttpBlock)block;

/// 用户信息
+ (void)api_user_info:(NSDictionary *)parameters done:(NGHttpBlock)block;

/// 更新用户信息 (userid,usertoken,nickname,phone,email,intro,sex,avatar)
+ (void)api_update_user_info:(NSDictionary *)parameters done:(NGHttpBlock)block;

/// 更新用户头像, form 表单上传文件, "photo" NSData;  "uid" String; "token" String
+ (void)api_update_user_icon:(NSDictionary *)parameters done:(NGHttpBlock)block;

/// news 评论的信息
+ (void)api_news_comments:(NSDictionary *)parameters done:(NGHttpBlock)block;

/// news 发送评论
+ (void)api_send_comment:(NSDictionary *)parameters done:(NGHttpBlock)block;


@end
