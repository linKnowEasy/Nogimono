//
//  NGBlogCell.h
//  Nogimono
//
//  Created by lingang on 2018/6/26.
//  Copyright © 2018年 none. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NGBlogCellModel.h"

@interface NGBlogCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *iconView;

@property (nonatomic, strong) NGBlogCellModel *dataModel;

@end
