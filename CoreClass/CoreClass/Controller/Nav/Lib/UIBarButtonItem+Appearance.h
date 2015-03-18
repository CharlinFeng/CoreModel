//
//  UIBarButtonItem+Appearance.h
//  Drivers
//
//  Created by muxi on 15/2/5.
//  Copyright (c) 2015年 muxi. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface UIBarButtonItem (Appearance)

+ (UIBarButtonItem *)itemWithTarget:(id)target action:(SEL)action image:(NSString *)image highImage:(NSString *)highImage;

@end
