//
//  Person.m
//  CoreModel
//
//  Created by 冯成林 on 15/9/9.
//  Copyright (c) 2015年 冯成林. All rights reserved.
//

#import "Person.h"


@implementation Person

+(NSDictionary *)statementForNSArrayProperties{
    return @{@"tags":NSStringFromClass([NSString class]),@"dreams":NSStringFromClass([NSData class]),@"pens":NSStringFromClass([Pen class])};
}

+(NSDictionary *)objectClassInArray{
    return @{@"tags":NSStringFromClass([NSString class]),@"pens":NSStringFromClass([Pen class])};
}

@end
