//
//  NGHttpHelp.m
//  Nogimono
//
//  Created by lingang on 2018/6/26.
//  Copyright © 2018年 none. All rights reserved.
//



#import "NGHttpHelp.h"
#import "NGConstantHeader.h"



@implementation NGHttpHelp

+ (AFHTTPSessionManager *)sharedManager {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //最大请求并发任务数
    manager.operationQueue.maxConcurrentOperationCount = 5;
    
    // 请求格式
    // AFHTTPRequestSerializer            二进制格式
    // AFJSONRequestSerializer            JSON
    // AFPropertyListRequestSerializer    PList(是一种特殊的XML,解析起来相对容易)
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer]; // 上传普通格式
    
    // 超时时间
    manager.requestSerializer.timeoutInterval = 30.0f;
    // 设置请求头
    [manager.requestSerializer setValue:@"gzip" forHTTPHeaderField:@"Content-Encoding"];
    // 设置接收的Content-Type
    manager.responseSerializer.acceptableContentTypes = [[NSSet alloc] initWithObjects:@"application/xml", @"text/xml",@"text/html", @"application/json",@"text/plain",nil];
    
    // 返回格式
    // AFHTTPResponseSerializer           二进制格式
    // AFJSONResponseSerializer           JSON
    // AFXMLParserResponseSerializer      XML,只能返回XMLParser,还需要自己通过代理方法解析
    // AFXMLDocumentResponseSerializer (Mac OS X)
    // AFPropertyListResponseSerializer   PList
    // AFImageResponseSerializer          Image
    // AFCompoundResponseSerializer       组合
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];//返回格式 JSON
    //设置返回C的ontent-type
    manager.responseSerializer.acceptableContentTypes=[[NSSet alloc] initWithObjects:@"application/xml", @"text/xml",@"text/html", @"application/json",@"text/plain",nil];
    
    return manager;
}
/// 为了处理 请求成功. 业务失败的情况
+ (void)dealSuccessBlock:(NSURLSessionDataTask *)task repObject:(id)responseObject block:(NGHttpBlock)block {
    
    if (!block) {
        return;
    }
    
    NSString *errorMessage = @"";
    NSError *error = nil;
    NSHTTPURLResponse *res = (NSHTTPURLResponse *)task.response;
    
    if (res.statusCode >= 400) {
        error  = [[NSError alloc] initWithDomain:@"" code:res.statusCode userInfo:NULL];
        block(error, @"服务器暂时出问题了", nil);
        return;
    }
    
    if (!responseObject) {
        errorMessage = @"无返回数据";
        block(error, errorMessage, nil);
        return;
    }
    
    block(nil, @"成功", responseObject);
}

+ (void)dealFailureBlock:(NSURLSessionDataTask *)task error:(NSError *)error block:(NGHttpBlock)block {
    
    if (block) {
        block(error, @"失败", nil);
    }
}



+ (void)api_member_group:(NSDictionary *)parameters done:(NGHttpBlock)block {
    
    //创建请求地址
    NSString *url = [NSString stringWithFormat:@"%@%@", NGBaseURL, DATA_MEMBERLIST];

    [[NGHttpHelp sharedManager] GET:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        /// 为了代码对齐, 不置 nil
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [NGHttpHelp dealSuccessBlock:task repObject:responseObject block:block];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [NGHttpHelp dealFailureBlock:task error:error block:block];
    }];
    
}

+ (void)api_blogs:(NSDictionary *)parameters done:(NGHttpBlock)block {
    
    NSString *url = [NSString stringWithFormat:@"%@%@", NGBaseURL, PATH_BLOGS];
    
    [[NGHttpHelp sharedManager] GET:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        /// 为了代码对齐, 不置 nil
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [NGHttpHelp dealSuccessBlock:task repObject:responseObject block:block];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [NGHttpHelp dealFailureBlock:task error:error block:block];
    }];
    
}

+ (void)api_news:(NSDictionary *)parameters done:(NGHttpBlock)block {
    
    NSString *url = [NSString stringWithFormat:@"%@%@", NGBaseURL, PATH_NEWS];
    
    [[NGHttpHelp sharedManager] GET:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        /// 为了代码对齐, 不置 nil
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [NGHttpHelp dealSuccessBlock:task repObject:responseObject block:block];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [NGHttpHelp dealFailureBlock:task error:error block:block];
    }];
    
}

/// 注册
+ (void)api_regist:(NSDictionary *)parameters done:(NGHttpBlock)block {
    NSString *url = [NSString stringWithFormat:@"%@%@", NGBaseURL, PATH_REGISTER];
    
    [[NGHttpHelp sharedManager] POST:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        /// 为了代码对齐, 不置 nil
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [NGHttpHelp dealSuccessBlock:task repObject:responseObject block:block];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [NGHttpHelp dealFailureBlock:task error:error block:block];
    }];
}

/// 登录
+ (void)api_login:(NSDictionary *)parameters done:(NGHttpBlock)block {
    NSString *url = [NSString stringWithFormat:@"%@%@", NGBaseURL, PATH_LOGIN_NICKNAME];
    
    [[NGHttpHelp sharedManager] POST:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        /// 为了代码对齐, 不置 nil
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [NGHttpHelp dealSuccessBlock:task repObject:responseObject block:block];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [NGHttpHelp dealFailureBlock:task error:error block:block];
    }];
}

/// 用户信息
+ (void)api_user_info:(NSDictionary *)parameters done:(NGHttpBlock)block {
    NSString *url = [NSString stringWithFormat:@"%@%@", NGBaseURL, PATH_USERINFO];
    
    [[NGHttpHelp sharedManager] POST:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        /// 为了代码对齐, 不置 nil
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [NGHttpHelp dealSuccessBlock:task repObject:responseObject block:block];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [NGHttpHelp dealFailureBlock:task error:error block:block];
    }];
    
}

/// 更新用户信息
+ (void)api_update_user_info:(NSDictionary *)parameters done:(NGHttpBlock)block {
    NSString *url = [NSString stringWithFormat:@"%@%@", NGBaseURL, PATH_USERSET];
    
    [[NGHttpHelp sharedManager] POST:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        /// 为了代码对齐, 不置 nil
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [NGHttpHelp dealSuccessBlock:task repObject:responseObject block:block];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [NGHttpHelp dealFailureBlock:task error:error block:block];
    }];
    
}

/// 更新用户头像, form 表单上传文件, "photo" NSData;  "uid" String; "token" String
+ (void)api_update_user_icon:(NSDictionary *)parameters done:(NGHttpBlock)block {
    NSString *url = [NSString stringWithFormat:@"%@%@", NGBaseURL, PATH_USER_AVATAR];
    
    ////
//    .addFormDataPart("uid", uid)
//    .addFormDataPart("token", token)
//    .addFormDataPart("photo", file.getName(),
//    RequestBody.create(MediaType.parse("image/*"), file))
    // parameters[@"photo"];  parameters[@"uid"]; token
    
    [[NGHttpHelp sharedManager] POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        NSData *uidData = [parameters[@"uid"] dataUsingEncoding:NSUTF8StringEncoding];
        [formData appendPartWithFormData:uidData name:@"uid"];
        
        NSData *tokenData = [parameters[@"token"] dataUsingEncoding:NSUTF8StringEncoding];
        [formData appendPartWithFormData:tokenData name:@"token"];
        
        [formData appendPartWithFileData:parameters[@"photo"] name:@"photo" fileName:@"photo" mimeType:@"image/*"];

//        [formData appendPartWithFileURL:[NSURL fileURLWithPath:theImagePath] name:@"file" error:nil];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [NGHttpHelp dealSuccessBlock:task repObject:responseObject block:block];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [NGHttpHelp dealFailureBlock:task error:error block:block];
    }];
}

/// news 评论信息
+ (void)api_news_comments:(NSDictionary *)parameters done:(NGHttpBlock)block {
    //创建请求地址
    NSString *url = [NSString stringWithFormat:@"%@%@", NGBaseURL, PATH_COMMENT_ALL];
    
    [[NGHttpHelp sharedManager] POST:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        /// 为了代码对齐, 不置 nil
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [NGHttpHelp dealSuccessBlock:task repObject:responseObject block:block];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [NGHttpHelp dealFailureBlock:task error:error block:block];
    }];
}

/// news 发送评论的信息
+ (void)api_send_comment:(NSDictionary *)parameters done:(NGHttpBlock)block {
    NSString *url = [NSString stringWithFormat:@"%@%@", NGBaseURL, PATH_COMMENT_NEW];
    
    [[NGHttpHelp sharedManager] POST:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        /// 为了代码对齐, 不置 nil
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [NGHttpHelp dealSuccessBlock:task repObject:responseObject block:block];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [NGHttpHelp dealFailureBlock:task error:error block:block];
    }];
    
}

@end
