//
//  NGWebWithCommentVC.h
//  Nogimono
//
//  Created by lingang on 2018/7/3.
//  Copyright © 2018年 none. All rights reserved.
//

#import "NGBaseVC.h"

@interface NGWebWithCommentVC : NGBaseVC

- (instancetype)initWithURL:(NSString *)webURL newsID:(NSString *)newsID;

- (void)loadURL:(NSString *)webURL;
@end
