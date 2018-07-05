//
//  NGMainTabVC.m
//  Nogimono
//
//  Created by lingang on 2018/6/26.
//  Copyright © 2018年 none. All rights reserved.
//

#import "NGMainTabVC.h"

#import "NGHomeVC.h"
#import "NGBlogsVC.h"
#import "NGUserInfoVC.h"

#import "NGConstantHeader.h"



@interface NGMainTabVC ()

@end

@implementation NGMainTabVC

+ (NGMainTabVC *)ng_NGMainTabVC {
    NGBlogsVC *blogsVC = [[NGBlogsVC alloc] init];
    
    CGFloat iconSize = 30;
    CGSize imageSize = CGSizeMake(30, 30);
    
    
    blogsVC.tabBarItem.image = [MaterialIcon ImageWithIcon:MaterialIconCode.list hexColor:NGColors.tabUnSelectColor iconSize:iconSize imageSize:imageSize];
    blogsVC.tabBarItem.selectedImage = [MaterialIcon ImageWithIcon:MaterialIconCode.list hexColor:NGColors.tabSelectColor iconSize:iconSize imageSize:imageSize];
    blogsVC.title = @"成员信息";
    UINavigationController *blogNav = [[UINavigationController alloc] initWithRootViewController:blogsVC];
    
    
    NGHomeVC *homeVC = [[NGHomeVC alloc] init];
    homeVC.tabBarItem.image = [MaterialIcon ImageWithIcon:MaterialIconCode.list hexColor:NGColors.tabUnSelectColor iconSize:iconSize imageSize:imageSize];
    homeVC.tabBarItem.selectedImage = [MaterialIcon ImageWithIcon:MaterialIconCode.list hexColor:NGColors.tabSelectColor iconSize:iconSize imageSize:imageSize];
    homeVC.title = @"坂道信息";
    UINavigationController *homeNav = [[UINavigationController alloc] initWithRootViewController:homeVC];
    
    
    NGUserInfoVC *userInfoVC = [[NGUserInfoVC alloc] init];
    
    userInfoVC.tabBarItem.image = [MaterialIcon ImageWithIcon:MaterialIconCode.person_outline hexColor:NGColors.tabUnSelectColor iconSize:iconSize imageSize:imageSize];
    userInfoVC.tabBarItem.selectedImage = [MaterialIcon ImageWithIcon:MaterialIconCode.person_outline hexColor:NGColors.tabSelectColor iconSize:iconSize imageSize:imageSize];
    userInfoVC.title = @"用户信息";
    UINavigationController *userInfoVCNav = [[UINavigationController alloc] initWithRootViewController:userInfoVC];
    
    NGMainTabVC *tabBarVC = [[NGMainTabVC alloc] init];
    tabBarVC.view.backgroundColor = [UIColor whiteColor];
    tabBarVC.viewControllers = @[blogNav, homeNav, userInfoVCNav];
    tabBarVC.selectedIndex = 1;
    return tabBarVC;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

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
