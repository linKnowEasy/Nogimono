//
//  NGLoginVC.m
//  Nogimono
//
//  Created by lingang on 2018/6/29.
//  Copyright © 2018年 none. All rights reserved.
//

#import "NGLoginVC.h"
#import "NGConstantHeader.h"

#import "NGUserInfoModel.h"


typedef NS_ENUM(NSUInteger, NGActionMode) {
    NGActionMode_Login,
    NGActionMode_Regist
};

@interface NGLoginVC ()<UIGestureRecognizerDelegate, UITextFieldDelegate>

@property (nonatomic, strong) UIImageView *logoView;

@property (nonatomic, strong) UITextField *userNameTextField;

@property (nonatomic, strong) UITextField *pwdTextField;
@property (nonatomic, strong) UITextField *pwdConfirmTextField;

@property (nonatomic, strong) UIButton *loginButton;

@property (nonatomic, strong) UIButton *switchModeButton;

@property (nonatomic, assign) NGActionMode actionMode;

@end

@implementation NGLoginVC

+ (UINavigationController *)NGLoginPresent {
    NGLoginVC *vc = [[NGLoginVC alloc] init];
    vc.view.backgroundColor = [UIColor whiteColor];
    UINavigationController *loginNav = [[UINavigationController alloc] initWithRootViewController:vc];
    
    return loginNav;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupData];
    [self setupView];
    [self setupDismisKeyboard];
}

- (void)setupData {
    _actionMode = NGActionMode_Login;
}

- (void)setupView {
    NGWeakObj(self)
    self.title = @"登录";
    [self ng_leftBtnWithNrlImage:MaterialIconCode.arrow_back title:@"" action:^{
        [selfWeak dismissViewControllerAnimated:YES completion:nil];
    }];
    
    _logoView = [UIImageView new];
    _logoView.backgroundColor = [UIColor clearColor];
    _logoView.image = [UIImage imageNamed:@"app_logo"];
    _logoView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:_logoView];
    [_logoView mas_makeConstraints:^(MASConstraintMaker *make) {
        int hSpace = 20;
        if (@available(iOS 11.0,*)) {
            make.top.equalTo(selfWeak.view.mas_safeAreaLayoutGuideTop).offset(hSpace);
        } else {
            make.top.mas_equalTo(hSpace + 64);
        }
        make.centerX.mas_equalTo(selfWeak.view.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(80, 80));
    }];
    
    _userNameTextField = [UITextField new];
    _userNameTextField.delegate = self;
    _userNameTextField.font = [UIFont systemFontOfSize:16];
    _userNameTextField.returnKeyType = UIReturnKeyNext;
    _userNameTextField.layer.masksToBounds = YES;
    _userNameTextField.layer.cornerRadius = 46/2;
    _userNameTextField.layer.borderWidth = 2;
    _userNameTextField.layer.borderColor = [UIColor purpleColor].CGColor;
    
    _userNameTextField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 0)];
    
    //设置显示模式为永远显示(默认不显示 必须设置 否则没有效果)
    _userNameTextField.leftViewMode = UITextFieldViewModeAlways;
    
    [_userNameTextField addTarget:self action:@selector(checkText) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:_userNameTextField];
    
    [_userNameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(20);
        make.right.mas_equalTo(-20);
        make.top.mas_equalTo(selfWeak.logoView.mas_bottom).offset(20);
        make.height.mas_equalTo(46);
    }];
    
    _pwdTextField = [UITextField new];
    _pwdTextField.delegate = self;
    _pwdTextField.font = [UIFont systemFontOfSize:16];
    _pwdTextField.secureTextEntry = YES;
    _pwdTextField.layer.masksToBounds = YES;
    _pwdTextField.layer.cornerRadius = 46/2;
    _pwdTextField.layer.borderWidth = 2;
    _pwdTextField.layer.borderColor = [UIColor purpleColor].CGColor;
    _pwdTextField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 0)];
    //设置显示模式为永远显示(默认不显示 必须设置 否则没有效果)
    _pwdTextField.leftViewMode = UITextFieldViewModeAlways;
    [_pwdTextField addTarget:self action:@selector(checkText) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:_pwdTextField];
    
    [_pwdTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(20);
        make.right.mas_equalTo(-20);
        make.top.mas_equalTo(selfWeak.userNameTextField.mas_bottom).offset(20);
        make.height.mas_equalTo(46);
    }];
    
    
    _pwdConfirmTextField = [UITextField new];
    _pwdConfirmTextField.delegate = self;
    _pwdConfirmTextField.font = [UIFont systemFontOfSize:16];
    _pwdConfirmTextField.secureTextEntry = YES;
    _pwdConfirmTextField.layer.masksToBounds = YES;
    _pwdConfirmTextField.layer.cornerRadius = 46/2;
    _pwdConfirmTextField.layer.borderWidth = 2;
    _pwdConfirmTextField.layer.borderColor = [UIColor purpleColor].CGColor;
    _pwdConfirmTextField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 0)];
    //设置显示模式为永远显示(默认不显示 必须设置 否则没有效果)
    _pwdConfirmTextField.leftViewMode = UITextFieldViewModeAlways;
    
    
    [_pwdConfirmTextField addTarget:self action:@selector(checkText) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:_pwdConfirmTextField];
    
    [_pwdConfirmTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(20);
        make.right.mas_equalTo(-20);
        make.top.mas_equalTo(selfWeak.pwdTextField.mas_bottom).offset(20);
        make.height.mas_equalTo(46);
    }];
    
    
    //登录按钮
    _loginButton = [[UIButton alloc] initWithFrame:CGRectZero];
    [_loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [_loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_loginButton.titleLabel setFont:[UIFont systemFontOfSize:16.0]];
    [_loginButton setBackgroundColor:[UIColor purpleColor]];
    _loginButton.layer.masksToBounds = YES;
    _loginButton.layer.cornerRadius = 46/2;
    [_loginButton addTarget:self action:@selector(onLoginAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_loginButton];
    
    
    [_loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(20);
        make.right.mas_equalTo(-20);
        make.top.mas_equalTo(selfWeak.pwdTextField.mas_bottom).offset(20);
        make.height.mas_equalTo(46);
    }];
    
    
    //模式切换按钮
    _switchModeButton = [[UIButton alloc] initWithFrame:CGRectZero];
    [_switchModeButton setTitle:@"我要登录" forState:UIControlStateNormal];
    [_switchModeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_switchModeButton.titleLabel setFont:[UIFont systemFontOfSize:12.0]];
    [_switchModeButton setBackgroundColor:[UIColor purpleColor]];
    _switchModeButton.layer.masksToBounds = YES;
    _switchModeButton.layer.cornerRadius = 22/2;
    [_switchModeButton addTarget:self action:@selector(onSwitchModeAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_switchModeButton];

    [_switchModeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(selfWeak.loginButton.mas_bottom).offset(20);
        make.right.mas_equalTo(selfWeak.loginButton.mas_right);
        make.height.mas_equalTo(22);
        make.width.mas_equalTo(80);
    }];
    
    
    [self updateView];

    
}

#pragma mark---dismiss keyboard
- (void)setupDismisKeyboard {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyboard)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
    tap.delegate = self;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
       shouldReceiveTouch:(UITouch *)touch {
    /// 不拦截任何手势
    if ([touch.view isKindOfClass:[UITextField class]]) {
        NSLog(@"点击的是 输入框");
        return NO;
    }
    
    [self dismissKeyboard];
    return NO;
}

- (void)dismissKeyboard {
    [self.view endEditing:YES];
}

#pragma mark---键盘偏移

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    CGRect frame = textField.frame;
    int offSet = frame.origin.y + 70 - (self.view.frame.size.height - 236.0); //iphone键盘高度为216.iped键盘高度为352
    //将试图的Y坐标向上移动offset个单位，以使线面腾出开的地方用于软键盘的显示
    
    if (offSet > 0) {
        self.view.frame = CGRectMake(0.0f, -offSet, self.view.frame.size.width, self.view.frame.size.height);
    }
}



//输入框编辑完成以后，将视图恢复到原始状态

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.view.frame = self.view.bounds;
}


#pragma mark---updateview
- (void)updateView {
    
    BOOL isLogin = _actionMode == NGActionMode_Login;
    [self checkText];
    NSString *switchTitle = isLogin ? @"我要注册": @"我要登录";
    NSString *actionTitle = isLogin ? @"登录": @"注册";
    
    [_switchModeButton setTitle:switchTitle forState:UIControlStateNormal];
    [_loginButton setTitle:actionTitle forState:UIControlStateNormal];
    
    _pwdConfirmTextField.hidden = isLogin;
    
    NGWeakObj(self)
    
    [UIView animateWithDuration:0.5 animations:^{
        selfWeak.pwdConfirmTextField.alpha = isLogin ? 0 : 1;
        
        if (isLogin) {
            [selfWeak.loginButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.offset(20);
                make.right.mas_equalTo(-20);
                make.top.mas_equalTo(selfWeak.pwdTextField.mas_bottom).offset(20);
                make.height.mas_equalTo(46);
            }];
        } else {
            [selfWeak.loginButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.offset(20);
                make.right.mas_equalTo(-20);
                make.top.mas_equalTo(selfWeak.pwdConfirmTextField.mas_bottom).offset(20);
                make.height.mas_equalTo(46);
            }];
        }
        
        //必须调用此方法，才能出动画效果
        [selfWeak.view layoutIfNeeded];
        
    }];
}
#pragma mark---UItextfiled notify

- (void)checkText {
    BOOL inputError = [self checkInputText];
    
    UIColor *bgColor = inputError ? [UIColor lightGrayColor]: [UIColor purpleColor];
    _loginButton.backgroundColor = bgColor;
    _loginButton.userInteractionEnabled = !inputError;
}
- (BOOL)checkInputText {
    if (_userNameTextField.text.length == 0) {
        return YES;
    }
    
    if (_pwdTextField.text.length == 0) {
        return YES;
    }
    
    if (_pwdConfirmTextField.text.length == 0 && _actionMode == NGActionMode_Regist) {
        return YES;
    }
    return NO;
}

#pragma mark---ButtonAction

- (void)onLoginAction:(UIButton *)button {
    
    NSString *name = _userNameTextField.text;
    NSString *pwd = _pwdTextField.text;
    NSString *pwdConfirm = _pwdConfirmTextField.text;
    
    
    NGWeakObj(self)
    switch (_actionMode) {
        case NGActionMode_Login:{
            /// do login
            NSDictionary *dic = @{@"nickname":name, @"password":pwd};
            [NGHttpHelp api_login:dic done:^(NSError *error, NSString *message, id retData) {
                NSLog(@"api_login-- error==%@, message==%@,retData==%@", error, message, retData);
                if (error) {
                    /// 错误处理
                    NSLog(@"错误处理");
                } else {
                    NSDictionary *retDic = retData;
                    int retCode =  [retDic[@"code"] intValue];
                    if (retCode != 200) {
                        NSString *msg = retDic[@"message"];
                        NSLog(@"错误， msg==%@", msg);
                    } else {
                        
                        [NGUserInfoModel sharedInstance].userID = retDic[@"data"][@"id"];
                        [NGUserInfoModel sharedInstance].token = retDic[@"data"][@"token"];
                        NSLog(@"成功=====");
                        [selfWeak dismissViewControllerAnimated:YES completion:nil];
                    }
                }
            }];
            
            break;
        }
        case NGActionMode_Regist:{
            /// do regist
            
            if (![pwd isEqualToString:pwdConfirm]) {
                NSLog(@"error---注册 两次密码不一致");
                return;
            }
            
            NSDictionary *dic = @{@"nickname":name, @"password":pwd};
            [NGHttpHelp api_regist:dic done:^(NSError *error, NSString *message, id retData) {
                NSLog(@"api_regist-- error==%@, message==%@,retData==%@", error, message, retData);
                if (error) {
                    /// 错误处理
                    NSLog(@"错误处理");
                } else {
                    NSDictionary *retDic = retData;
                    int retCode =  [retDic[@"code"] intValue];
                    if (retCode != 200) {
                        
                        NSString *msg = retDic[@"message"];
                        NSLog(@"错误， msg==%@", msg);
                    } else {
                        NSLog(@"成功=====");
                    }
                }
                
                
            }];
            
            break;
        }
    }
}


- (void)onSwitchModeAction:(UIButton *)button {
    _actionMode = _actionMode != NGActionMode_Login ? NGActionMode_Login: NGActionMode_Regist;
    [self updateView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
