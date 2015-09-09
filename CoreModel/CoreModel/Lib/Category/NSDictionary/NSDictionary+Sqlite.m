//
//  NSDictionary+Sqlite.m
//  CoreClass
//
//  Created by 冯成林 on 15/5/28.
//  Copyright (c) 2015年 muxi. All rights reserved.
//

#import "NSDictionary+Sqlite.h"

@implementation NSDictionary (Sqlite)


/**
 *  字典转为sql条件中的where条件字符串
 */
-(NSString *)sqlWhere{
    
    if(![self isKindOfClass:[NSDictionary class]] || self.count == 0) return nil;
    
    NSMutableString *strM=[NSMutableString string];
    
    [self enumerateKeysAndObjectsUsingBlock:^(NSString *key,NSString *obj, BOOL *stop) {
        
        if([key isEqualToString:@"id"]) key=@"mid";
        
        if([obj isKindOfClass:[NSString class]]){
            [strM appendFormat:@"%@='%@' and ",key,obj];
        }else{
            [strM appendFormat:@"%@=%@ and ",key,obj];
        }
    }];
    
    //删除最后的 and
    NSString *where= [strM substringToIndex:strM.length-5];
    
    return where;
}


@end
