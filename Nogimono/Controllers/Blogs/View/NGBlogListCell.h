//
//  NGBlogListCell.h
//  Nogimono
//
//  Created by lingang on 2018/6/27.
//  Copyright © 2018年 none. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NGBlogListCellModel.h"

@interface NGBlogListCell : UITableViewCell

@property (nonatomic, strong) UILabel *blogTitleLabel;
@property (nonatomic, strong) UILabel *blogAuthorLabel;

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *blogSummaryLabel;


@property (nonatomic, strong) NGBlogListCellModel *dataModel;

@end
