//
//  NGBlogListCellModel.h
//  Nogimono
//
//  Created by lingang on 2018/6/27.
//  Copyright © 2018年 none. All rights reserved.
//

#import "NGBaseModel.h"

@interface NGBlogListCellModel : NGBaseModel
/// blog title
@property (nonatomic, copy) NSString *blogTitle;
/// blog author
@property (nonatomic, copy) NSString *blogAuthor;
/// blog post time
@property (nonatomic, copy) NSString *blogPostTime;
/// blog web url
@property (nonatomic, copy) NSString *blogWebUrl;
/// blog summary
@property (nonatomic, copy) NSString *blogSummary;

/// blog post time format time
@property (nonatomic, copy, readonly) NSString *blogTimeFormat;

/// blog author icon url
@property (nonatomic, copy, readonly) NSString *blogAuthorIcon;


@end
