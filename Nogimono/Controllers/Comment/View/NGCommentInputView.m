//
//  NGCommentInputView.m
//  Nogimono
//
//  Created by lingang on 2018/7/4.
//  Copyright © 2018年 none. All rights reserved.
//

#import "NGCommentInputView.h"
#import "NGConstantHeader.h"

@interface NGCommentInputView()<UITextViewDelegate>

//@property (nonatomic, strong) UITextView *inputTextView;
@property (nonatomic, strong) UILabel *inputPlaceholder;
@property (nonatomic, strong) UIButton *sendButton;

@end


@implementation NGCommentInputView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        _inputTextView = [[UITextView alloc] initWithFrame:CGRectZero];   //框框不由textview显示，只是由来能够实现协议的方法
        _inputTextView.backgroundColor = [UIColor whiteColor];
        _inputTextView.delegate = self;
        _inputTextView.layer.borderColor = UIColor.grayColor.CGColor;
        _inputTextView.layer.borderWidth = 0.1;
        _inputTextView.layer.cornerRadius = 6;
        _inputTextView.layer.masksToBounds = NO;
        _inputTextView.font = [UIFont systemFontOfSize:15.0f];

        [self addSubview:_inputTextView];
        
        [_inputTextView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.top.mas_equalTo(10);
            make.bottom.mas_equalTo(-10);
            make.right.mas_equalTo(-80);
        }];
        
        
        
        _inputPlaceholder = [[UILabel alloc] initWithFrame:CGRectMake(15.0f, 54+2, 50, (54-2*10-4))];
        _inputPlaceholder.font = [UIFont systemFontOfSize:15.0f];
        _inputPlaceholder.textColor = [UIColor lightGrayColor];
        _inputPlaceholder.backgroundColor = [UIColor clearColor];
        _inputPlaceholder.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_inputPlaceholder];

        [_inputPlaceholder mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(10);
            make.left.mas_equalTo(16);
            make.bottom.mas_equalTo(-10);
            make.right.mas_equalTo(-80);
        }];
        
        
        _sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _sendButton.frame = CGRectZero;
        [_sendButton setTitle:@"发送" forState:0];
        
        [_sendButton addTarget:self action:@selector(sendButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        _sendButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        [_sendButton setTitleColor:[UIColor purpleColor] forState:UIControlStateNormal];
        

        _sendButton.layer.borderColor = UIColor.grayColor.CGColor;
        _sendButton.layer.borderWidth = 1;
        _sendButton.layer.cornerRadius = 4;
        _sendButton.layer.masksToBounds = YES;

        [self addSubview:_sendButton];
        
        [_sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-10);
            make.bottom.mas_equalTo(-10);
            make.size.mas_equalTo(CGSizeMake(60, 30));
        }];
        
        self.backgroundColor = [UIColor whiteColor];
    }
    
    return self;
}

- (void)sendButtonPressed {
    if (self.inputTextView.text.length == 0) {  //用户没有输入评价内容
        // 无内容
        return;
    }
    NSString *text = self.inputTextView.text;
    
    if (_replayBlock) {
        _replayBlock(text, _comentID, _toUserID);
    }
    
}

- (void)setPlaceholderString:(NSString *)placeholderString {
    _placeholderString = placeholderString;
    _inputPlaceholder.text = _placeholderString;
}


- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    if (textView.text.length > 0) {
        [self bringSubviewToFront:textView];
        _inputPlaceholder.hidden = YES;
    } else {
        [self bringSubviewToFront:_inputPlaceholder];
        _inputPlaceholder.hidden = NO;
    }
    return YES;
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {

    NSLog(@"text---%@, view==%d", text, textView.text.length);
    
    BOOL hiddenPlaceholder = text.length > 0;
    
    if (text.length == 0 && textView.text.length > 1) {
        hiddenPlaceholder = YES;
    }

    if (hiddenPlaceholder) {
        [self bringSubviewToFront:textView];
        _inputPlaceholder.hidden = YES;
    } else {
        [self bringSubviewToFront:_inputPlaceholder];
        _inputPlaceholder.hidden = NO;
    }
    
    CGSize contentSize = _inputTextView.contentSize;
    
    if (_contentSizeBlock) {
        _contentSizeBlock(contentSize);
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    
}

@end
