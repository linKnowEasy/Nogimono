//
//  NGBlogListCellModel.m
//  Nogimono
//
//  Created by lingang on 2018/6/27.
//  Copyright © 2018年 none. All rights reserved.
//

#import "NGBlogListCellModel.h"

#import "NSString+NGUtils.h"

@implementation NGBlogListCellModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"blogTitle" : @"title",
             @"blogAuthor" : @"author",
             @"blogPostTime" : @"post",
             @"blogWebUrl" : @"url",
             @"blogSummary" : @"summary"
             };
}


- (NSString *)blogTimeFormat {
    return [self.blogPostTime toDateString];
}

- (NSString *)blogAuthorIcon {
    NSString *iconUrl = [[NSUserDefaults standardUserDefaults] objectForKey:_blogAuthor];
    return iconUrl;
}
@end
