//
//  NGWebViewVC.h
//  Nogimono
//
//  Created by lingang on 2018/6/28.
//  Copyright © 2018年 none. All rights reserved.
//

#import "NGBaseVC.h"

@interface NGWebViewVC : NGBaseVC

- (instancetype)initWithURL:(NSString *)webURL;

- (void)loadURL:(NSString *)webURL;

@end
