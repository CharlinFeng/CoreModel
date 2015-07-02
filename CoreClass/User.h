//
//  User.h
//  CoreClass
//
//  Created by 冯成林 on 15/7/2.
//  Copyright (c) 2015年 muxi. All rights reserved.
//

#import "BaseModel.h"
#import <UIKit/UIKit.h>

@interface User : BaseModel

/** 用户名 */
@property (nonatomic,copy) NSString *userName;

/** 级别 */
@property (nonatomic,assign) NSUInteger level;

/** 账户余额 */
@property (nonatomic,assign) CGFloat accountMoney;

/** 是否是vip：产品狗新加 */
@property (nonatomic,assign) BOOL isVip;


@end
