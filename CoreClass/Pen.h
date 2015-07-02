//
//  Pen.h
//  CoreClass
//
//  Created by 冯成林 on 15/7/2.
//  Copyright (c) 2015年 muxi. All rights reserved.
//

#import "BaseModel.h"
#import <UIKit/UIKit.h>





@interface Pen : BaseModel

@property (nonatomic,copy) NSString *brandName;

@property (nonatomic,assign) NSUInteger usageYear;

@property (nonatomic,assign) CGFloat price;



@end
