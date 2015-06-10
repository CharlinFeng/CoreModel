//
//  GradientView.h
//  网络
//
//  Created by 沐汐 on 14-10-8.
//  Copyright (c) 2014年 沐汐. All rights reserved.
//
//  快速生成一个拥有渐变色的View
//  本类必需在drawRect方法中，使用Quartz 2D绘制，因此无法实现分类及工具方法，只能以功能模块的方式存在。


#import <UIKit/UIKit.h>

typedef enum{
   
    GradientViewTypeHorizontal=0,           //水平
    
    GradientViewTypeVertical                //垂直
    
    
}GradientViewType;


@interface BaseGradientView : UIView

/**
 *  设置渐变色
 */
-(void)setGradientWithType:(GradientViewType)type beginColor:(UIColor *)beginColor endColor:(UIColor *)endColor;


@end
