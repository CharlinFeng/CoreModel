//
//  NSObject+Runtime.h
//  test
//
//  Created by 冯成林 on 16/3/31.
//  Copyright © 2016年 冯成林. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreProperty.h"

@interface NSObject (Runtime)


/** 成员变量遍历 */
+(void)enumeratePropertiesUsingBlock:(void(^)(CoreProperty *p))propertyBlock;


@end
