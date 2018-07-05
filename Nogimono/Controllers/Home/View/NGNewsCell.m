//
//  NGNewsCell.m
//  Nogimono
//
//  Created by lingang on 2018/6/29.
//  Copyright © 2018年 none. All rights reserved.
//

#import "NGNewsCell.h"
#import "NGConstantHeader.h"

@implementation NGNewsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self) {
        
        //不设置 cell 选中状态
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        CGFloat cellWidth = self.bounds.size.width;
        CGFloat cellHeight = self.bounds.size.height;
        
        _newsImageView = [UIImageView new];
        //        _iconImageView.layer.borderWidth = 1;
        //        _iconImageView.layer.borderColor = NG_HEXCOLOR(NGColors.borderColor).CGColor;
        //        _iconImageView.layer.masksToBounds = YES;
        //        _iconImageView.layer.cornerRadius = 2;
        
        [self addSubview:_newsImageView];
        NGWeakObj(self)
        [_newsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(0);
            make.bottom.mas_equalTo(-10);
            make.top.mas_equalTo(10);
            make.width.mas_equalTo(selfWeak.newsImageView.mas_height).multipliedBy(4.0/3);
        }];
        
        
        _newsTitleLabel = [UILabel new];
        _newsTitleLabel.textColor = [UIColor blackColor];
        _newsTitleLabel.font = [UIFont systemFontOfSize:16];
        _newsTitleLabel.numberOfLines = 0;
        _newsTitleLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_newsTitleLabel];
        
        [_newsTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(selfWeak.newsImageView.mas_left).offset(-10);
            make.left.mas_equalTo(0);
            make.top.mas_equalTo(10);
            make.bottom.mas_equalTo(-40);
        }];
        
        _newsAuthorLabel = [UILabel new];
        _newsAuthorLabel.textColor = [UIColor blackColor];
        _newsAuthorLabel.font = [UIFont systemFontOfSize:11];
        _newsAuthorLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_newsAuthorLabel];
        
        [_newsAuthorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(selfWeak.newsTitleLabel.mas_right);
            make.left.mas_equalTo(0);
            make.height.mas_equalTo(20);
            make.bottom.mas_equalTo(-10);
        }];
    }
    return self;
}

-(void)setDataModel:(NGNewsCellModel *)dataModel {
    _dataModel = dataModel;
    
    NGWeakObj(self)
    if (dataModel.newsIcons.count > 0) {
        _newsImageView.hidden = NO;
        [_newsImageView sd_setImageWithURL:[NSURL URLWithString:dataModel.newsIcons[0]]];
        [_newsTitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(selfWeak.newsImageView.mas_left).offset(-10);
            make.left.mas_equalTo(0);
            make.top.mas_equalTo(10);
            make.bottom.mas_equalTo(-40);
        }];

        [self setNeedsDisplay];
    } else {
        _newsImageView.hidden = YES;
        [_newsTitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.and.left.mas_equalTo(0);

            make.top.mas_equalTo(10);
            make.bottom.mas_equalTo(-40);
        }];

        [self setNeedsDisplay];
    }
    
    
    

    _newsTitleLabel.text = _dataModel.newsTitle;
    _newsAuthorLabel.text = [NSString stringWithFormat:@"%@  %@", _dataModel.newsTimeFormat, _dataModel.newsProvider];
    
    
}


@end
