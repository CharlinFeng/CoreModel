//
//  UIBarButtonItem+Appearance.m
//  Drivers
//
//  Created by muxi on 15/2/5.
//  Copyright (c) 2015年 muxi. All rights reserved.
//

#import "UIBarButtonItem+Appearance.h"

@implementation UIBarButtonItem (Appearance)

/**
 *  创建一个item
 *
 *  @param target    点击item后调用哪个对象的方法
 *  @param action    点击item后调用target的哪个方法
 *  @param image     图片
 *  @param highImage 高亮的图片
 *
 *  @return 创建完的item
 */
+ (UIBarButtonItem *)itemWithTarget:(id)target action:(SEL)action image:(NSString *)image highImage:(NSString *)highImage
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    // 设置图片
    [btn setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:highImage] forState:UIControlStateHighlighted];
    // 设置尺寸
    btn.frame = (CGRect){CGPointZero,btn.currentBackgroundImage.size};
    return [[UIBarButtonItem alloc] initWithCustomView:btn];
}

@end
