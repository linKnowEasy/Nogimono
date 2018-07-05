//
//  NGConstantHeader.h
//  Nogimono
//
//  Created by lingang on 2018/6/26.
//  Copyright © 2018年 none. All rights reserved.
//


#import <MJRefresh/MJRefresh.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "AFNetworking.h"
#import "Masonry.h"
#import "YYModel.h"
#import "YYText.h"


#import "UIView+NGFrame.h"
#import "MaterialIcon.h"
#import "NGStyle.h"
#import "NGHttpHelp.h"

#define NGWeakObj(o) __weak typeof(o) o##Weak = o;
#define NGStrongObj(o) __strong typeof(o) o = o##Weak;

#define NG_HEXCOLOR(rgbvalue) [UIColor colorWithRed:(CGFloat)((rgbvalue&0xFF0000)>>16)/255.0 green:(CGFloat)((rgbvalue&0xFF00)>>8)/255.0 blue:(CGFloat)(rgbvalue&0xFF)/255.0 alpha:1]
#define NG_HEXCOLORA(rgbvalue, a) [UIColor colorWithRed:(CGFloat)((rgbvalue&0xFF0000)>>16)/255.0 green:(CGFloat)((rgbvalue&0xFF00)>>8)/255.0 blue:(CGFloat)(rgbvalue&0xFF)/255.0 alpha:a]
#define NG_RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define NG_RGB(r,g,b) RGBA(r,g,b,1.0f)


#define NG_WidthScreen UIScreen.mainScreen.bounds.size.width
#define NG_HeightScreen UIScreen.mainScreen.bounds.size.height


