//
//  ToolNetWorkView.h
//  Car
//
//  Created by muxi on 15/2/2.
//  Copyright (c) 2015年 muxi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ToolNetWorkView : UIView


+(instancetype)netWorkViewWithViewController:(UIViewController *)vc;



/**
 *  显示一个网络状态提示框
 */
+(void)showNetWordNotiInViewController:(UIViewController *)vc y:(CGFloat)y;

/**
 *  隐藏
 */
+(void)dismissNetWordNotiInViewController:(UIViewController *)vc;




@end
