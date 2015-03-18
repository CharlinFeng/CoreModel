//
//  BaseModel.m
//  4s
//
//  Created by muxi on 15/3/11.
//  Copyright (c) 2015年 muxi. All rights reserved.
//

#import "BaseModel.h"


@implementation BaseModel

+(NSDictionary *)replacedKeyFromPropertyName{
    return @{@"hostID":@"id"};
}



@end
