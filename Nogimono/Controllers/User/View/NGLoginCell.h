//
//  NGLoginCell.h
//  Nogimono
//
//  Created by lingang on 2018/6/29.
//  Copyright © 2018年 none. All rights reserved.
//

#import <UIKit/UIKit.h>

extern const struct NGLoginCellStyle {
    __unsafe_unretained NSString *userName;
    __unsafe_unretained NSString *password;
    __unsafe_unretained NSString *confirmPassword;
    __unsafe_unretained NSString *loginButton;
    __unsafe_unretained NSString *registButton;
} NGLoginCellStyle;



@protocol NGLoginCellDelegate <NSObject>


@required
- (void)loginAction;
- (void)registAction;

@optional


@end

@interface NGLoginCell : UITableViewCell

@property (nonatomic, weak) id<NGLoginCellDelegate> delegate;
@property (nonatomic, strong) UITextField *stateTextFiled;
@property (nonatomic, strong) UIButton *stateButton;


@property (nonatomic, copy) NSString *state;

@end
