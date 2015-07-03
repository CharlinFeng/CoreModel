//
//  Pen.m
//  CoreClass
//
//  Created by 冯成林 on 15/7/2.
//  Copyright (c) 2015年 muxi. All rights reserved.
//

#import "Pen.h"

@implementation Pen

/** 描述 */
-(NSString *)description{
    return [NSString stringWithFormat:@"brandName=%@,usageYear=%@,price=%@",self.brandName,@(self.usageYear),@(self.price)];
}

@end
