//
//  NGBlogCellModel.m
//  Nogimono
//
//  Created by lingang on 2018/6/26.
//  Copyright © 2018年 none. All rights reserved.
//

#import "NGBlogCellModel.h"

@implementation NGBlogCellModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"memberName" : @"name",
             @"memberIcon" : @"portrait",
             @"memberRome" : @"rome"
             };
}

- (void)setMemberIcon:(NSString *)memberIcon {
    /// 临时处理
    _memberIcon = memberIcon;
    [[NSUserDefaults standardUserDefaults] setObject:_memberIcon forKey:_memberName];
}


@end
