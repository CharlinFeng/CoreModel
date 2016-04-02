//
//  NSObject+Runtime.m
//  test
//
//  Created by 冯成林 on 16/3/31.
//  Copyright © 2016年 冯成林. All rights reserved.
//

#import "NSObject+Runtime.h"
#import <objc/runtime.h>

@implementation NSObject (Runtime)

/** 成员变量遍历 */
+(void)enumeratePropertiesUsingBlock:(void(^)(CoreProperty *p))propertyBlock{
    
    Class cls = self;
    
    do {
        
        [self enumerateCls:cls propertyBlock:propertyBlock];
        
        cls = class_getSuperclass(cls);
        
    }while (cls != [NSObject class]);
    
}


+(void)enumerateCls:(Class)cls propertyBlock:(void(^)(CoreProperty *p))propertyBlock{
    
    unsigned int numIvars; //成员变量个数
    
    Ivar *vars = class_copyIvarList(cls, &numIvars);
    
    //Ivar *vars = class_copyIvarList([UIView class], &numIvars);
    
    NSString *key=nil;
    NSString *type = nil;
    
    for(int i = 0; i < numIvars; i++) {
        
        //创建CoreProperty
        CoreProperty *p =[CoreProperty new];
        
        Ivar thisIvar = vars[i];
        key = [NSString stringWithUTF8String:ivar_getName(thisIvar)];  //获取成员变量的名字
        
        //记录变量名
        p.name = [key stringByReplacingOccurrencesOfString:@"_" withString:@""];
        
        type = [NSString stringWithUTF8String:ivar_getTypeEncoding(thisIvar)]; //获取成员变量的数据类型
        
        //处理并记录变量类型
        p.code = type;
        
        propertyBlock(p);
    }
    
    free(vars);
}



@end
