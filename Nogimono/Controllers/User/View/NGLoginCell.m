//
//  NGLoginCell.m
//  Nogimono
//
//  Created by lingang on 2018/6/29.
//  Copyright © 2018年 none. All rights reserved.
//

#import "NGLoginCell.h"
#import "NGConstantHeader.h"


@implementation NGLoginCell


const struct NGLoginCellStyle NGLoginCellStyle = {
    .userName = @"ng_userName",
    .password = @"ng_password",
    .confirmPassword = @"ng_password_again",
    .loginButton = @"ng_login_button",
    .registButton = @"ng_regist_button"
};


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self) {
        
        //不设置 cell 选中状态
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        CGFloat cellWidth = self.bounds.size.width;
        CGFloat cellHeight = self.bounds.size.height;
        
        
        _stateTextFiled = [UITextField new];

        _stateTextFiled.layer.masksToBounds = YES;
        _stateTextFiled.layer.cornerRadius = cellHeight/2;
        _stateTextFiled.layer.borderWidth = 2;
        _stateTextFiled.layer.borderColor = [UIColor purpleColor].CGColor;
        
        
        [self addSubview:_stateTextFiled];
        
        [_stateTextFiled mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(10, 10, 10, 10));
        }];
        
        _stateButton = [UIButton new];
        _stateButton.layer.masksToBounds = YES;
        _stateButton.layer.cornerRadius = cellHeight/2;

        [self addSubview:_stateButton];
        
        [_stateButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(10, 10, 10, 10));
        }];
        
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



- (void)setState:(NSString *)state {
    _state = state;
    
    NSString *placeText = @"";
    NSString *titleText = @"";
    if ([_state isEqualToString:NGLoginCellStyle.userName]) {
        placeText = @"请输入用户名";
    } else if ([_state isEqualToString:NGLoginCellStyle.password]) {
        placeText = @"请输入用户名";
    } else if ([_state isEqualToString:NGLoginCellStyle.confirmPassword]) {
        placeText = @"请输入用户名";
    } else if ([_state isEqualToString:NGLoginCellStyle.loginButton]) {
        titleText = @"登录";
    } else if ([_state isEqualToString:NGLoginCellStyle.confirmPassword]) {
        titleText = @"注册";
    }
    _stateTextFiled.placeholder = placeText;
    [_stateButton setTitle:titleText forState:UIControlStateNormal];

}

@end
