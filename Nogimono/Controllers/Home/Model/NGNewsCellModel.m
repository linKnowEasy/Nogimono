//
//  NGNewsCellModel.m
//  Nogimono
//
//  Created by lingang on 2018/6/29.
//  Copyright © 2018年 none. All rights reserved.
//

#import "NGNewsCellModel.h"
#import "NSString+NGUtils.h"
#import "NGHttpHelp.h"

@implementation NGNewsCellModel


//{
//    "data": "/data/00001234",
//    "delivery": 1530201600,
//    "id": "00001234",
//    "provider": "推特爬虫@光影",
//    "subtitle": "乃木坂46プレス",
//    "summary": "",
//    "title": "乃木坂46松村沙友理“接近能去的小时候2小时SP”[ 6 / 29 20 : 00～]",
//    "type": 14,
//    "view": "/view/00001234",
//    "withpic": [
//                {
//                    "image": "https://nogimono.tk/photo/00001234/ba176e10ee2330b63c736bb55f0d8460.png"
//                }
//                ]
//}

///// news id
//@property (nonatomic, copy) NSString *newsID;
///// news title
//@property (nonatomic, copy) NSString *newsTitle;
///// news provider
//@property (nonatomic, copy) NSString *newsProvider;
///// news post time
//@property (nonatomic, copy) NSString *newsPostTime;
///// news web url
//@property (nonatomic, copy) NSString *newsWebUrl;
///// news summary
//@property (nonatomic, copy) NSString *newsSummary;

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"newsID" : @"id",
             @"newsData" : @"data",
             @"newsTitle" : @"title",
             @"newsProvider" : @"provider",
             @"newsPostTime" : @"delivery",
             @"newsView" : @"view",
             @"newsDicIcons" : @"withpic"
             };
}

- (NSString *)newsTimeFormat {
    return [_newsPostTime toDateString];
}

- (NSString *)newsWebUrl {
    return [NSString stringWithFormat:@"%@%@", NGBaseURL, _newsView];
}

- (NSString *)newsDataUrl {
    return [NSString stringWithFormat:@"%@%@", NGBaseURL, _newsData];
}

- (NSArray *)newsIcons {
    NSMutableArray *iconArray = [NSMutableArray array];
    for (NSDictionary *iconDic in _newsDicIcons) {
        [iconArray addObject:iconDic[@"image"]];
    }
    
    return [iconArray copy];
}

@end
