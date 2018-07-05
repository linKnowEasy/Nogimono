//
//  NGBlogListCell.m
//  Nogimono
//
//  Created by lingang on 2018/6/27.
//  Copyright © 2018年 none. All rights reserved.
//

#import "NGBlogListCell.h"
#import "NGConstantHeader.h"

@implementation NGBlogListCell

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
        //cell右侧的小箭头
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        CGFloat cellWidth = self.bounds.size.width;
        CGFloat cellHeight = self.bounds.size.height;
        
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(16, 10, cellHeight - 20, cellHeight - 20)];
//        _iconImageView.layer.borderWidth = 1;
//        _iconImageView.layer.borderColor = NG_HEXCOLOR(NGColors.borderColor).CGColor;
//        _iconImageView.layer.masksToBounds = YES;
//        _iconImageView.layer.cornerRadius = 2;
        
        [self addSubview:_iconImageView];
        NGWeakObj(self)
        [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(16);
            make.bottom.mas_equalTo(-10);
            make.top.mas_equalTo(10);
            make.width.equalTo(selfWeak.iconImageView.mas_height);
        }];
        
        
        UIStackView *labelView = [UIStackView new];
        labelView.axis = UILayoutConstraintAxisVertical;
        labelView.distribution = UIStackViewDistributionFillEqually;
        labelView.spacing = 10;
        labelView.alignment = UIStackViewAlignmentFill;

        _blogTitleLabel = [UILabel new];
        _blogTitleLabel.textColor = [UIColor blackColor];
        _blogTitleLabel.font = [UIFont systemFontOfSize:16];
        _blogTitleLabel.textAlignment = NSTextAlignmentLeft;
        [labelView addArrangedSubview:_blogTitleLabel];
        
        
        _blogAuthorLabel = [UILabel new];
        _blogAuthorLabel.textColor = [UIColor blackColor];
        _blogAuthorLabel.font = [UIFont systemFontOfSize:14];
        _blogAuthorLabel.textAlignment = NSTextAlignmentLeft;
        [labelView addArrangedSubview:_blogAuthorLabel];
        
        _blogSummaryLabel = [UILabel new];
        _blogSummaryLabel.textColor = [UIColor blackColor];
        _blogSummaryLabel.font = [UIFont systemFontOfSize:12];
        _blogSummaryLabel.textAlignment = NSTextAlignmentRight;
        [labelView addArrangedSubview:_blogSummaryLabel];
        
        [self addSubview:labelView];
        [labelView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(selfWeak.iconImageView.mas_right).offset(10);
            make.right.mas_equalTo(-40);
            make.top.mas_equalTo(10);
            make.bottom.mas_equalTo(-10);
            
//            make.top.mas_equalTo(0);
//            make.bottom.mas_equalTo(0);
        }];
    }
    return self;
}




- (void)setDataModel:(NGBlogListCellModel *)dataModel {
    _dataModel = dataModel;
    
    
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:dataModel.blogAuthorIcon]] ;
    
    _blogTitleLabel.text = _dataModel.blogTitle;
    _blogAuthorLabel.text = [NSString stringWithFormat:@"%@  %@", _dataModel.blogAuthor, _dataModel.blogTimeFormat];
    _blogSummaryLabel.text = _dataModel.blogSummary;
}


@end
