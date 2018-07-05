//
//  NGNewsCell.h
//  Nogimono
//
//  Created by lingang on 2018/6/29.
//  Copyright © 2018年 none. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NGNewsCellModel.h"

@interface NGNewsCell : UITableViewCell


@property (nonatomic, strong) UILabel *newsTitleLabel;
@property (nonatomic, strong) UILabel *newsAuthorLabel;

@property (nonatomic, strong) UIImageView *newsImageView;



@property (nonatomic, strong) NGNewsCellModel *dataModel;

@end
