//
//  NSString+NGUtils.m
//  Nogimono
//
//  Created by lingang on 2018/6/27.
//  Copyright © 2018年 none. All rights reserved.
//

#import "NSString+NGUtils.h"

@implementation NSString (NGUtils)


- (NSString *)toDateString {
    if (self.length  == 0) {
        return @"";
    }
    /// 默认按照秒 取处理
    NSTimeInterval time = self.doubleValue/1000;
    if (self.length == 10) {
        time = self.doubleValue;
    } else if (self.length == 13) {
        time = self.doubleValue/1000;
    }

    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    /// 时区处理
//    [dateformatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *dateStr =[dateformatter stringFromDate:date];
    
    return dateStr;
}

@end
