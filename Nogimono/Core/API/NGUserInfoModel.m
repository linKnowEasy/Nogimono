//
//  NGUserInfoModel.m
//  Nogimono
//
//  Created by lingang on 2018/7/1.
//  Copyright © 2018年 none. All rights reserved.
//

#import "NGUserInfoModel.h"
#import "NGHttpHelp.h"
#import "NGConstantHeader.h"

static NSString *NG_USER_ID = @"ng_user_id";
static NSString *NG_USER_TOKEN = @"ng_user_token";


@implementation NGUserInfoModel

+ (NGUserInfoModel *)sharedInstance {
    
    static dispatch_once_t once;
    static NGUserInfoModel *sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[NGUserInfoModel alloc] init];
        sharedInstance.userID = [[NSUserDefaults standardUserDefaults] objectForKey:NG_USER_ID];
        sharedInstance.token = [[NSUserDefaults standardUserDefaults] objectForKey:NG_USER_TOKEN];
        
    });
    return sharedInstance;
}

- (void)setUserID:(NSString *)userID {
    _userID = userID;
    [[NSUserDefaults standardUserDefaults] setObject:_userID forKey:NG_USER_ID];
}

- (void)setToken:(NSString *)token {
    _token = token;
    [[NSUserDefaults standardUserDefaults] setObject:_token forKey:NG_USER_TOKEN];
    
}

- (NSString *)sexString {
    
//    if (_sex == 1) {
//        return @"男";
//    } else if (_sex == 0) {
//        return @"女";
//    }
    
    return _sex == 1 ? @"男": @"女";
}

- (void)getUserInfo:(NGCompleteBlock)completeBlock {
    
    
    
    if (_userID.length == 0 || _token.length == 0) {
        if (completeBlock) {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"用户未登录"                                                                      forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:@"" code:-99 userInfo:userInfo];
            completeBlock(error, nil);
        }
        return;
    }
    
    
    NGWeakObj(self)
    NSDictionary *dic = @{@"id":_userID, @"token": _token};
    [NGHttpHelp api_user_info:dic done:^(NSError *error, NSString *message, id retData) {
        NSLog(@"getUserInfo---error==%@, message==%@, data==%@", error, message, retData);
        if (!completeBlock) {
            return ;
        }
        
        if (error) {
            
            
        } else {
            NSDictionary *retDic = retData;
            NSString *code = retDic[@"code"];
            
            if (code.intValue != 200) {
                NSString *message = retDic[@"message"];
                NSDictionary *userInfo = [NSDictionary dictionaryWithObject:message                                                                      forKey:NSLocalizedDescriptionKey];
                error = [NSError errorWithDomain:@"" code:code.intValue userInfo:userInfo];
                completeBlock(error, retData);
                return;
            } else {
                NSDictionary *dataDic = retDic[@"data"];
                
                selfWeak.nickname = [NGUserInfoModel NSNullCheckOfDic:dataDic key:@"nickname"];
                selfWeak.email = [NGUserInfoModel NSNullCheckOfDic:dataDic key:@"email"];
                selfWeak.userIconUrl = [NGUserInfoModel NSNullCheckOfDic:dataDic key:@"avatar"];
                selfWeak.introduction = [NGUserInfoModel NSNullCheckOfDic:dataDic key:@"introduction"];
                selfWeak.phone = [NGUserInfoModel NSNullCheckOfDic:dataDic key:@"phone"];
                
                NSString *sex = [NGUserInfoModel NSNullCheckOfDic:dataDic key:@"sex"];
                selfWeak.sex = sex.intValue;
                
                NSString *status = [NGUserInfoModel NSNullCheckOfDic:dataDic key:@"status"];
                selfWeak.status = status.intValue;
                
                
            }

        }
        
        completeBlock(error, retData);
        
        
    }];
    
    
}

+ (id)NSNullCheckOfDic:(NSDictionary *)dic key:(NSString *)key {
    
    if ([[dic objectForKey:key] isEqual:[NSNull null]]) {
        return nil;
    }
    
    return [dic objectForKey:key];
}

/// 更新用户信息
- (void)updateUserInfo:(NSDictionary *)dic block:(NGCompleteBlock)completeBlock {
    
    
}

@end
