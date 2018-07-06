//
//  NGInputVC.m
//  Nogimono
//
//  Created by lingang on 2018/7/5.
//  Copyright © 2018年 none. All rights reserved.
//

#import "NGInputVC.h"
#import "NGConstantHeader.h"

@interface NGInputVC ()

@property (nonatomic, strong) UITextView *inputView;

@end

@implementation NGInputVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupView];
}

- (void)setupView {
    NGWeakObj(self);
    [self ng_leftBtnWithNrlImage:MaterialIconCode.arrow_back title:@"" action:^{
        [selfWeak.navigationController popViewControllerAnimated:YES];
    }];
    [self ng_rigthBtnWithNrlImage:nil title:@"保存" action:^{
        NSString *text = selfWeak.inputView.text;
        if (selfWeak.inputBlock ) {
            selfWeak.inputBlock(text);
        }
        [selfWeak.navigationController popViewControllerAnimated:YES];
    }];
    
    _inputView = [UITextView new];
    
    [self.view addSubview:_inputView];
    
    [_inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(10, 10, 10, 10));
    }];
    
}

- (void)setInputTitle:(NSString *)inputTitle {
    _inputTitle = inputTitle;
    self.title = _inputTitle;
}

- (void)setOriginalValue:(NSString *)originalValue {
    _originalValue = originalValue;
    _inputView.text = originalValue;
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
