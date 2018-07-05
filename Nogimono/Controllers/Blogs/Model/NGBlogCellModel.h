//
//  NGBlogCellModel.h
//  Nogimono
//
//  Created by lingang on 2018/6/26.
//  Copyright © 2018年 none. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NGBaseModel.h"

@interface NGBlogCellModel : NGBaseModel
/// member name
@property (nonatomic, copy) NSString *memberName;
/// member icon url
@property (nonatomic, copy) NSString *memberIcon;
/// member Rome name
@property (nonatomic, copy) NSString *memberRome;
/// member group
@property (nonatomic, copy) NSString *memberGroup;



@end
