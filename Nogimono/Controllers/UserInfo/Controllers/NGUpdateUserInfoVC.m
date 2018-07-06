//
//  NGUpdateUserInfo.m
//  Nogimono
//
//  Created by lingang on 2018/7/3.
//  Copyright © 2018年 none. All rights reserved.
//

#import "NGUpdateUserInfoVC.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "NGInputVC.h"
#import "NGUserInfoModel.h"
#import "NGConstantHeader.h"


@interface NGUpdateUserInfoVC ()<UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) UITableView *userInfoTableView;

@property (nonatomic, strong) NSMutableArray *userInfoListArray;

@property (nonatomic, strong) NSMutableDictionary *userInfoDic;

@property (nonatomic, strong) NSDictionary *titlesDic;

@end

@implementation NGUpdateUserInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupData];
    [self setupView];
}
- (void)setupData {
    _userInfoListArray = [NSMutableArray array];
    
    NSString *uid = [NGUserInfoModel sharedInstance].userID;
    NSString *token = [NGUserInfoModel sharedInstance].token;
    NSString *nickName = [NGUserInfoModel sharedInstance].nickname;
    NSString *phone = [NGUserInfoModel sharedInstance].phone;
    NSString *email = [NGUserInfoModel sharedInstance].email;
    
    NSString *intro = [NGUserInfoModel sharedInstance].introduction;
    int sex = [NGUserInfoModel sharedInstance].sex;
    NSString *url = [NGUserInfoModel sharedInstance].userIconUrl;
    
    NSDictionary *userDic = @{@"id":uid, @"token":token, @"nickname":nickName, @"phone":phone, @"email":email, @"introduction":intro, @"sex":@(sex), @"avatar": url};
    _userInfoDic = [userDic mutableCopy];
    
    _titlesDic = @{@"头像":@"avatar", @"昵称":@"nickname", @"性别":@"sex", @"自我介绍":@"introduction", @"手机号码":@"phone", @"电子邮箱":@"email"};
//    _titlesDic.allKeys;
     NSArray *titles = @[@"头像", @"昵称", @"性别", @"自我介绍", @"手机号码", @"电子邮箱"];
    _userInfoListArray = [titles mutableCopy];
    
}

- (void)setupView {
    NGWeakObj(self);
    [self ng_leftBtnWithNrlImage:MaterialIconCode.arrow_back title:@"" action:^{
        [selfWeak.navigationController popViewControllerAnimated:YES];
    }];
    [self ng_rigthBtnWithNrlImage:nil title:@"保存" action:^{
        [selfWeak updateUserInfo];
//
//        NSString *text = selfWeak.inputView.text;
//        if (selfWeak.inputBlock ) {
//            selfWeak.inputBlock(text);
//        }
//        [selfWeak.navigationController popViewControllerAnimated:YES];
    }];
    
    
    
    _userInfoTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _userInfoTableView.delegate = self;
    _userInfoTableView.dataSource = self;
    _userInfoTableView.tableFooterView = [UIView new];
    [self.view addSubview:_userInfoTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark---UITableView delegate and date source

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    static NSString *reuseID = @"NGUserInfoModifyCell";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    NSString *key = _userInfoListArray[indexPath.row];
    NSString *infoKey = _titlesDic[key];
    NSString *value = _userInfoDic[infoKey];
    
    if (indexPath.row == 0) {
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:value]];
        cell.textLabel.text = key;
    } else {
        cell.textLabel.text = key;
        if ([value isKindOfClass:NSNumber.class]) {
            value = value.intValue == 0 ? @"女" : @"男";
        }
        cell.detailTextLabel.text = value;
    }
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _userInfoListArray.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//       NSArray *titles = @[@"未读消息", @"设置", @"关于我们", @"文字识别"];
    
    NSString *key = _userInfoListArray[indexPath.row];
    NSString *infoKey = _titlesDic[key];
    NSString *value = _userInfoDic[infoKey];
    NGWeakObj(self)
    switch (indexPath.row) {
        case 0:{
            
            break;
        }
        case 1:
        case 3:
        case 4:
        case 5: {
            NGInputVC *vc = [[NGInputVC alloc] init];
            vc.view.backgroundColor = [UIColor whiteColor];
            vc.title = [NSString stringWithFormat:@"修改%@", key];
            vc.originalValue = _userInfoDic[infoKey];
            vc.inputBlock = ^(NSString *inputText) {
                [selfWeak.userInfoDic setObject:inputText forKey:infoKey];
                [selfWeak.userInfoTableView reloadData];
            };
            
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 2:{
            
            break;
        }
        default:
            break;
    }
    
    
    

    
}


#pragma mark---照片选择

- (void)chooseImage {
    
    //创建UIImagePickerController对象，并设置代理和可编辑
    UIImagePickerController * imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.editing = YES;
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    
    //创建sheet提示框，提示选择相机还是相册
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"请选择打开方式" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    //相机选项
    UIAlertAction * camera = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        //选择相机时，设置UIImagePickerController对象相关属性
        imagePicker.sourceType =  UIImagePickerControllerSourceTypeCamera;
        imagePicker.modalPresentationStyle = UIModalPresentationFullScreen;
        imagePicker.mediaTypes = @[(NSString *)kUTTypeImage];
        imagePicker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
        //跳转到UIImagePickerController控制器弹出相机
        [self presentViewController:imagePicker animated:YES completion:nil];
    }];
    
    //相册选项
    UIAlertAction * photo = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        //选择相册时，设置UIImagePickerController对象相关属性
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        //跳转到UIImagePickerController控制器弹出相册
        [self presentViewController:imagePicker animated:YES completion:nil];
    }];
    
    //取消按钮
    UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
    //添加各个按钮事件
    [alert addAction:camera];
    [alert addAction:photo];
    [alert addAction:cancel];
    
    //弹出sheet提示框
    [self presentViewController:alert animated:YES completion:nil];
    
}

#pragma mark - imagePickerController delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    //获取到的图片
    UIImage * image = [info valueForKey:UIImagePickerControllerEditedImage];
    
    
    NSData *imgData = UIImageJPEGRepresentation(image, 0.5);
    
    NSString *uid = [NGUserInfoModel sharedInstance].userID;
    NSString *token = [NGUserInfoModel sharedInstance].token;
    
    //    "photo" NSData; "uid" String; "token" String
    NSDictionary *dic = @{@"photo":imgData, @"uid":uid, @"token":token};
    
    NGWeakObj(self)
    
    [NGHttpHelp api_update_user_icon:dic done:^(NSError *error, NSString *message, id retData) {
        
        if (error) {
            /// 错误处理
            
        } else {
            NSDictionary *retDic = retData;
            NSString *code = retDic[@"code"];
            
            if (code.intValue != 200) {
                NSLog(@"api_update_user_icon-error----%@",retDic[@"message"] );
                return ;
            }
            
            NSString *url = retDic[@"data"][@"avatar"];
            [selfWeak.userInfoDic setObject:url forKey:@"avatar"];
        }
    }];
    
}

- (void)updateUserInfo {
    
    NGWeakObj(self)
    [NGHttpHelp api_update_user_info:_userInfoDic done:^(NSError *error, NSString *message, id retData) {
        
        if (error) {
            /// 错误处理
            
        } else {
            
            NSDictionary *retDic = retData;
            NSString *code = retDic[@"code"];
            
            if (code.intValue != 200) {
                NSLog(@"api_update_user_icon-error----%@",retDic[@"message"] );
                return ;
            }
            
            [selfWeak.navigationController popViewControllerAnimated:YES];
        }
    }];
}


@end
