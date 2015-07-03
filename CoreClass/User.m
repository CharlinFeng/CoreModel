//
//  User.m
//  CoreClass
//
//  Created by 冯成林 on 15/7/2.
//  Copyright (c) 2015年 muxi. All rights reserved.
//

#import "User.h"

@implementation User

/** 描述 */
-(NSString *)description{
    return [NSString stringWithFormat:@"userName=%@,level=%@,accountMoney=%@,isVip=%@",self.userName,@(self.level),@(self.accountMoney),@(self.isVip)];
}

@end
