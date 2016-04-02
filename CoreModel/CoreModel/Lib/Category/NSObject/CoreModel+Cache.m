//
//  NSObject+Cache.m
//  CoreModel
//
//  Created by 冯成林 on 15/9/10.
//  Copyright (c) 2015年 冯成林. All rights reserved.
//

#import "CoreModel+Cache.h"

@implementation CoreModel (Cache)

/** 模型对比时需要忽略的字段 */
+(NSArray *)constrastIgnorFields{
    return @[@"pModel",@"pid"];
}

/** 是否需要本地缓存：此处为CoreModel本身 */
+(BOOL)CoreModel_NeedFMDB{return YES;}

@end
