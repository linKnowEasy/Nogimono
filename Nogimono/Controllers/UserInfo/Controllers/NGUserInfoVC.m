//
//  NGUserInfoVC.m
//  Nogimono
//
//  Created by lingang on 2018/6/26.
//  Copyright © 2018年 none. All rights reserved.
//

#import "NGUserInfoVC.h"
#import "NGConstantHeader.h"
#import "NGLoginVC.h"

#import "NGUserInfoModel.h"
#import "NGUpdateUserInfoVC.h"


@interface NGUserInfoVC ()<UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) UITableView *userInfoTableView;

@property (nonatomic, strong) NSMutableArray *userInfoListArray;

@property (nonatomic, strong) UIImageView     *headerBackView;        // 头像背景图片
@property (nonatomic, strong) UIImageView     *photoImageView;        // 头像图片
@property (nonatomic, strong) UILabel         *userNameLabel;         // 用户名label
@property (nonatomic, strong) UILabel         *introduceLabel;        // 简介label
@property (nonatomic, strong) UIView          *tableViewHeaderView;   // tableView头部视图
@property (nonatomic, assign) NSInteger       imageHeight;            // 背景图片的高度


@end

@implementation NGUserInfoVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NGWeakObj(self)
    [[NGUserInfoModel sharedInstance] getUserInfo:^(NSError *error, NSString *message) {
        NSLog(@"NGHomeVC-error==%@, message==%@", error, message);
        [selfWeak updateView];
    }];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupData];
    [self setupView];
}
- (void)setupData {
    _userInfoListArray = [NSMutableArray array];
    _imageHeight = 240;
    NSArray *titles = @[@"未读消息", @"设置", @"关于我们", @"文字识别"];
    NSArray *icons = @[MaterialIconCode.message, MaterialIconCode.settings, MaterialIconCode.info, MaterialIconCode.center_focus_weak];
    NSArray *iconColors = @[@(0x800080), @(0x00BFFF), @(0x228B22), @(0xFF8C00)];
    
    CGFloat iconSize = 40;
    CGSize imageSize = CGSizeMake(40, 40);
    
    for (int i = 0; i < titles.count; i++) {
        UIImage *img =
        [MaterialIcon ImageWithIcon:icons[i] hexColor:[iconColors[i] intValue] iconSize:iconSize imageSize:imageSize];
        NSDictionary *dic = @{@"title":titles[i], @"icon":img};
        [_userInfoListArray addObject:dic];
    }
}

- (void)setupView {

    _userInfoTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _userInfoTableView.delegate = self;
    _userInfoTableView.dataSource = self;
    _userInfoTableView.tableFooterView = [UIView new];
    [self createTableViewHeaderView];
    [self.view addSubview:_userInfoTableView];
}

- (void)updateView {
    
    UIImage *placeImg = [MaterialIcon ImageWithIcon:MaterialIconCode.mood iconColor:[UIColor blueColor] iconSize:100 imageSize:CGSizeMake(100, 100)];
    
    NSURL *iconUrl = [NSURL URLWithString:[NGUserInfoModel sharedInstance].userIconUrl];

    [_photoImageView sd_setImageWithURL:iconUrl placeholderImage:placeImg];
    
    _userNameLabel.text = [NGUserInfoModel sharedInstance].nickname;
    _introduceLabel.text = [NGUserInfoModel sharedInstance].introduction;
}


#pragma mark----login

- (void)jumpToLogin {
    
    if ([NGUserInfoModel sharedInstance].token.length == 0) {
        UIViewController *vc = [NGLoginVC NGLoginPresent];
        [self presentViewController:vc animated:YES completion:nil];
    } else {
        /// 调整到设置
        [self chooseImage];
    }

}

#pragma mark---创建头视图下拉 放大

- (void)createTableViewHeaderView {
    CGFloat kwidth = self.view.ng_width;
    _tableViewHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kwidth, _imageHeight)];
    
    // 背景图
    _headerBackView = [[UIImageView alloc] init];
    _headerBackView.frame = CGRectMake(0, 0, kwidth, _imageHeight);
    _headerBackView.image = [UIImage imageNamed:@"icon_userbackimg.png"];

    [_tableViewHeaderView addSubview:_headerBackView];
    
    // 头像
    _photoImageView = [[UIImageView alloc] initWithFrame:CGRectMake((kwidth - 100) / 2, 50, 100, 100)];
    _photoImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(jumpToLogin)];
    [_photoImageView addGestureRecognizer:tap];
    [self.tableViewHeaderView addSubview:self.photoImageView];
    _photoImageView.layer.cornerRadius = 50;
    _photoImageView.layer.masksToBounds = YES;
    _photoImageView.image = [UIImage imageNamed:@"young"];
    
    // 用户名
    _userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_photoImageView.frame) + 10, kwidth, 20)];
    _userNameLabel.font = [UIFont systemFontOfSize:16];
    _userNameLabel.text = @"登录";
    _userNameLabel.textAlignment = 1;
    _userNameLabel.textColor = [UIColor blackColor];
    [_tableViewHeaderView addSubview:self.userNameLabel];
    
//    // 简介
//    _introduceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_userNameLabel.frame) + 10, kwidth, 20)];
//    _introduceLabel.alpha = 0.7;
//    _introduceLabel.text = @"他强任他强,我干我的羊";
//    _introduceLabel.textAlignment = 1;
//    _introduceLabel.font = [UIFont systemFontOfSize:12];
//    _introduceLabel.textColor = [UIColor whiteColor];
//    [_tableViewHeaderView addSubview:_introduceLabel];
    
    _userInfoTableView.tableHeaderView = _tableViewHeaderView;
}




- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat width = self.view.frame.size.width;// 图片的宽度
    CGFloat yOffset = scrollView.contentOffset.y;// 偏移的y值
//    NSLog(@"%f",yOffset);
    
    CGFloat showOffset = self.navigationController.navigationBar.hidden ? 0 : -64;
    
    if (yOffset < showOffset) {
        CGFloat totalOffset = _imageHeight + ABS(yOffset);
        CGFloat f = totalOffset / _imageHeight;
        self.headerBackView.frame = CGRectMake(- (width * f - width) / 2, yOffset, width * f, totalOffset);// 拉伸后的图片的frame应该是同比例缩放
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
            [selfWeak updateUserInfoWithIconUrl:url];
            
        }
        
        
        
    }];

}

- (void)updateUserInfoWithIconUrl:(NSString *)url {
    NSString *uid = [NGUserInfoModel sharedInstance].userID;
    NSString *token = [NGUserInfoModel sharedInstance].token;
    NSString *nickName = [NGUserInfoModel sharedInstance].nickname;
    NSString *phone = [NGUserInfoModel sharedInstance].phone;
    NSString *email = [NGUserInfoModel sharedInstance].email;
    
    NSString *intro = [NGUserInfoModel sharedInstance].introduction;
    int sex = [NGUserInfoModel sharedInstance].sex;
    
    
    ///  (userid,usertoken,nickname,phone,email,intro,sex,avatar)
    NSDictionary *userDic = @{@"id":uid, @"token":token, @"nickname":nickName, @"phone":phone, @"email":email, @"introduction":intro, @"sex":@(sex), @"avatar": url};
    NGWeakObj(self)
    [NGHttpHelp api_update_user_info:userDic done:^(NSError *error, NSString *message, id retData) {
        
        if (error) {
            /// 错误处理
            
        } else {
            
            NSDictionary *retDic = retData;
            NSString *code = retDic[@"code"];
            
            if (code.intValue != 200) {
                NSLog(@"api_update_user_icon-error----%@",retDic[@"message"] );
                return ;
            }
            
            [selfWeak.photoImageView sd_setImageWithURL:[NSURL URLWithString:url]];
            
        }
    }];
    
    
}

#pragma mark---UITableView delegate and date source

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    static NSString *reuseID = @"NGUserInfoCell";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    NSDictionary *infoDic = _userInfoListArray[indexPath.row];
    
    cell.textLabel.text = infoDic[@"title"];
    cell.imageView.image = infoDic[@"icon"];
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _userInfoListArray.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//   NSArray *titles = @[@"未读消息", @"设置", @"关于我们", @"文字识别"];
    
    UIViewController *vc = nil;
    
    switch (indexPath.row) {
        case 0:{
            
            break;
        }
        case 1:{
            vc = [[NGUpdateUserInfoVC alloc] init];
            break;
        }
        case 2:{
            
            break;
        }
        case 3:{
            
            break;
        }
        default:{
            break;
        }
    }

//    UIViewController *vc  = [[self.class alloc] init];
    
    [self.navigationController pushViewController:vc animated:YES];
    
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
