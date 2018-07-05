//
//  NGBlogCell.m
//  Nogimono
//
//  Created by lingang on 2018/6/26.
//  Copyright © 2018年 none. All rights reserved.
//

#import "NGBlogCell.h"
#import "NGBlogCellModel.h"
#import "NGConstantHeader.h"


@implementation NGBlogCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // 1.初始化imageView、label。
        CGFloat cellWidth = self.bounds.size.width;
        CGFloat cellHeight = self.bounds.size.height;
        
        
        
        
        _iconView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 0, cellWidth - 10, cellWidth - 10)];
        
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, cellWidth - 10 + 7, cellWidth, 14)];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = [UIFont systemFontOfSize:12];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        
        [self.contentView addSubview:_iconView];
        [self.contentView addSubview:_titleLabel];
        
    }
    return self;
}


- (void)setDataModel:(NGBlogCellModel *)dataModel {
    _dataModel = dataModel;
    _titleLabel.text = _dataModel.memberName;
    [_iconView sd_setImageWithURL:[NSURL URLWithString:_dataModel.memberIcon]];
    
}




@end
