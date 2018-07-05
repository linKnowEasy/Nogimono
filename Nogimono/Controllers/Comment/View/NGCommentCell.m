//
//  NGCommentCell.m
//  Nogimono
//
//  Created by lingang on 2018/7/3.
//  Copyright © 2018年 none. All rights reserved.
//

#import "NGCommentCell.h"
#import "NGConstantHeader.h"



static CGFloat const originXY = 10.0;
static CGFloat const heightTitle = 30.0;
static CGFloat const heightFloor = 20.0;


static CGFloat const cellDetailFont = 10;
static CGFloat const sectionDetailFont = 12;

static CGFloat const cellTimeFont = 12;
static CGFloat const sectionTimeFont = 14;


@interface NGCommentCell ()
@property (nonatomic, strong) UIImageView *commentPersonIcon;

@property (nonatomic, strong) YYLabel *commentPersonLabel;
@property (nonatomic, strong) YYLabel *commentFloorLabel;
@property (nonatomic, strong) YYLabel *commentDetialLabel;

@property (nonatomic, strong) YYLabel *commentTimeLabel;


@property (nonatomic, strong) UIButton *loadAllButton;

@property (nonatomic, assign) BOOL isHeader;

@end



@implementation NGCommentCell



- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupView];
        [self updateView];
    }
    return self;
}

- (instancetype)initHeaderWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        _isHeader = YES;
        [self setupView];
        [self updateView];
    }
    return self;
}

- (void)setupView {

    _commentPersonIcon = [UIImageView new];
    
    [self addSubview:_commentPersonIcon];
    
    [_commentPersonIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.mas_equalTo(10);
        make.size.mas_equalTo(CGSizeMake(30, 30));
        
    }];
    
    _commentPersonLabel = [YYLabel new];
    [self addSubview:_commentPersonLabel];
    
    [_commentPersonLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(10 + 40);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(20);
        
    }];
    
    _commentFloorLabel = [YYLabel new];
    [self addSubview:_commentFloorLabel];
    
    [_commentFloorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(10 + 40);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(20);
        
    }];
    _commentDetialLabel = [YYLabel new];
    [self addSubview:_commentDetialLabel];
    
    [_commentDetialLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(10 + 40);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(20);
    }];
    
    _commentTimeLabel = [YYLabel new];
    [self addSubview:_commentTimeLabel];
    
    [_commentTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(10 + 40);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(20);
    }];
    
    
    if (!_isHeader) {
        _loadAllButton = [UIButton new];
        [_loadAllButton setTitle:@"查看全部" forState:UIControlStateNormal];
        [_loadAllButton setTitleColor:[UIColor purpleColor] forState:UIControlStateNormal];
        [_loadAllButton addTarget:self action:@selector(loadAllComent) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_loadAllButton];
        
        [_loadAllButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0, 60, 0, 0));
        }];
    }
}

- (void)updateView {
    
    if (_isHeader) {
        _commentPersonLabel.font = [UIFont systemFontOfSize:16];
        _commentFloorLabel.font = [UIFont systemFontOfSize:12];
        _commentDetialLabel.font = [UIFont systemFontOfSize:sectionDetailFont];
        _commentTimeLabel.font = [UIFont systemFontOfSize:sectionTimeFont];
    } else {
        _commentPersonLabel.font = [UIFont systemFontOfSize:14];
        _commentFloorLabel.font = [UIFont systemFontOfSize:10];
        _commentDetialLabel.font = [UIFont systemFontOfSize:cellDetailFont];
        _commentTimeLabel.font = [UIFont systemFontOfSize:cellTimeFont];
    }
    
    _commentTimeLabel.textAlignment = NSTextAlignmentRight;
    _commentDetialLabel.numberOfLines = 0;
    
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)loadAllComent {
    if (_loadMoreBlock) {
        _loadMoreBlock();
    }
}

- (void)setDataModel:(NGCommentCellModel *)dataModel {
    
    _dataModel = dataModel;
    _loadAllButton.hidden = YES;
    if (_dataModel == nil) {
        _loadAllButton.hidden = NO;
        return;
    }
    
    NGWeakObj(self)
    if (_isHeader) {
        
        [_commentPersonIcon mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.and.top.mas_equalTo(10);
            make.size.mas_equalTo(CGSizeMake(30, 30));
        }];
        
        [_commentPersonLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(10);
            make.left.mas_equalTo(10 + 40);
            make.height.mas_equalTo(20);
            make.width.mas_equalTo(100);
        }];
        
        [_commentFloorLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(selfWeak.commentPersonLabel.mas_bottom);
            make.left.equalTo(selfWeak.commentPersonLabel.mas_left);
            make.right.mas_equalTo(-10);
//            make.right.equalTo(selfWeak.commentPersonLabel.mas_right);
            make.height.equalTo(selfWeak.commentPersonLabel.mas_height);
        }];
        
        [_commentDetialLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(selfWeak.commentFloorLabel.mas_bottom);
            make.left.equalTo(selfWeak.commentPersonLabel.mas_left);
//            make.right.equalTo(selfWeak.commentPersonLabel.mas_right);
            make.right.mas_equalTo(-10);
            make.bottom.mas_equalTo(-8);
        }];
        
        
        [_commentTimeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(10);
            make.right.mas_equalTo(-10);
            make.height.mas_equalTo(20);
            make.width.mas_equalTo(120);
        }];

    } else {
        [_commentPersonIcon mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(10);
            make.left.mas_equalTo(10 + 20);
            make.size.mas_equalTo(CGSizeMake(20, 20));
            
        }];
        
        [_commentPersonLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(10);
            make.left.mas_equalTo(10 + 50);
            make.height.mas_equalTo(20);
            make.width.mas_equalTo(100);
        }];
        
        [_commentFloorLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(selfWeak.commentPersonLabel.mas_bottom);
            make.left.equalTo(selfWeak.commentPersonLabel.mas_left);
            make.right.mas_equalTo(-10);
            make.height.equalTo(selfWeak.commentPersonLabel.mas_height);
        }];
        _commentFloorLabel.hidden = YES;
        
        [_commentDetialLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(selfWeak.commentPersonLabel.mas_bottom);
            make.left.equalTo(selfWeak.commentPersonLabel.mas_left);
            //            make.right.equalTo(selfWeak.commentPersonLabel.mas_right);
            make.right.mas_equalTo(-10);
            make.bottom.mas_equalTo(-8);
        }];
        
        [_commentTimeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(10);
            make.right.mas_equalTo(-10);
            make.height.mas_equalTo(20);
            make.width.mas_equalTo(120);
        }];
        
    }
    
    [self setNeedsDisplay];
    
    
    UIImage *placeImg = [MaterialIcon ImageWithIcon:MaterialIconCode.mood iconColor:[UIColor blueColor] iconSize:30 imageSize:CGSizeMake(30, 30)];
    [_commentPersonIcon sd_setImageWithURL:[NSURL URLWithString:_dataModel.authorIcon] placeholderImage:placeImg];
    
    
    _commentPersonLabel.text = _dataModel.authorNickname;
    
    _commentFloorLabel.text = _dataModel.commentFloorStr;
    
    
    NSString *text = _dataModel.toAuthorNickname ? [NSString stringWithFormat:@"回复 %@: %@", _dataModel.toAuthorNickname, _dataModel.commentMessage] : _dataModel.commentMessage;
    _commentDetialLabel.text = text;
    
    NSString *time = _dataModel.commentTime;
    if (!_isHeader) {
        time = [NSString stringWithFormat:@"%@  %@", time, _dataModel.commentFloorStr];
        
    }

    _commentTimeLabel.text = time;
    
    
    
    
}

+ (CGFloat)heightNGCommentCellWithModel:(NGCommentCellModel *)model {
    return [[self class] heightForModel:model header:NO];
}

+ (CGFloat)heightNGCommentSectionWithModel:(NGCommentCellModel *)model {
    return [[self class] heightForModel:model header:YES];
}




+ (CGFloat)heightForModel:(NGCommentCellModel *)model header:(BOOL)header {
    
    // 初化高度
    CGFloat height = header ?  heightTitle + 10 + 20 : heightTitle + 10;
    
    // 计算高度
    NSString *text = model.toAuthorNickname ? [NSString stringWithFormat:@"回复 %@: %@", model.toAuthorNickname, model.commentMessage] : model.commentMessage;
    
    UIFont *font = header ? [UIFont systemFontOfSize:sectionDetailFont]: [UIFont systemFontOfSize:cellDetailFont];
    CGFloat width = header ? (NG_WidthScreen - 60): (NG_WidthScreen - 70);
    
    CGFloat heightText = [[self class] heightTextWithText:text font:font width:width];
    height += heightText;
    
    NSLog(@"heightTableCell = %f, heightText = %f", height, heightText);
    
    return height;
}


+ (CGFloat)heightTextWithText:(NSString *)text font:(UIFont *)font width:(CGFloat)width{
    // 计算高度
    CGSize size = [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
    CGFloat heightText = size.height;
    
    return heightText;
}



@end
