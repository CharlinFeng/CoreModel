//
//  UINavigationController+Appearance.m
//  Drivers
//
//  Created by muxi on 15/2/5.
//  Copyright (c) 2015年 muxi. All rights reserved.
//

#import "UINavigationController+Appearance.h"
#import "UIImage+Color.h"

#define ios6x [[[UIDevice currentDevice] systemVersion] floatValue] < 7.0f
#define rgba(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]

@implementation UINavigationController (Appearance)


-(void)navBarAppearanceWithBgColor:(UIColor *)bgColor textColor:(UIColor *)textColor titleFontPoint:(CGFloat)titleFontPoint itemFontPoint:(CGFloat)itemFontPoint{
    
    if(textColor==nil) textColor=[UIColor whiteColor];
    
    //取出navbar条的全局外观
    UINavigationBar *navbarAppearance=[UINavigationBar appearance];
    
    //navbar设置背景图片:
    //BarMetrics：横竖屏模式
    [navbarAppearance setBackgroundImage:[UIImage imageFromContextWithColor:bgColor] forBarMetrics:UIBarMetricsDefault];
    
    
    //navbar设置标题文字样式:
    //字体：
    UIFont *font=ios6x?[UIFont systemFontOfSize:titleFontPoint]:[UIFont boldSystemFontOfSize:titleFontPoint];
    NSShadow *shadow=[[NSShadow alloc] init];
    shadow.shadowColor=[UIColor clearColor];
    [navbarAppearance setTitleTextAttributes:@{
                                               NSFontAttributeName: font,                                           //标题文字字体
                                               NSForegroundColorAttributeName:textColor,                            //标题文字颜色
                                               NSShadowAttributeName:shadow,                                        //标题文字阴影颜色
                                               }];
    
    
    //UIBarButtonItem设置:
    //取出navbaritem的全部外观
    UIBarButtonItem *navBarItem = [UIBarButtonItem appearance];
    
    //item的字体大小
    UIFont *itemFont=[UIFont systemFontOfSize:itemFontPoint];
    
    //设置文字外观:正常
    [navBarItem setTitleTextAttributes:@{
                                         NSForegroundColorAttributeName: textColor,                                 // 文字颜色
                                         NSShadowAttributeName:shadow,                                              //阴影颜色
                                         NSFontAttributeName:itemFont                                               //字体大小
                                         } forState:UIControlStateNormal];
    //高亮
    [navBarItem setTitleTextAttributes:@{
                                         NSForegroundColorAttributeName: rgba(181, 181, 181,1.0f),                        // 文字颜色
                                         NSShadowAttributeName:shadow,                                              //阴影颜色
                                         NSFontAttributeName:itemFont                                               //字体大小
                                         } forState:UIControlStateHighlighted];
    
    //设置文字背景图片
    [navBarItem setBackgroundImage:[UIImage imageFromContextWithColor:[UIColor clearColor]] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    //设置返回文字及图标颜色
    navbarAppearance.tintColor=textColor;
}


@end
