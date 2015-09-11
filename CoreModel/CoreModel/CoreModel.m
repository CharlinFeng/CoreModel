//
//  CoreModel.m
//  4s
//
//  Created by muxi on 15/3/11.
//  Copyright (c) 2015年 muxi. All rights reserved.
//

#import "CoreModel.h"
#import "NSObject+Create.h"


@implementation CoreModel


+(void)initialize{
    
    //自动创表
    [self tableCreate];
}


+(NSDictionary *)replacedKeyFromPropertyName{
    return @{@"hostID":@"id"};
}





@end
