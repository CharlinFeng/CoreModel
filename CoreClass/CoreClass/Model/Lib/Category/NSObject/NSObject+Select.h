//
//  NSObject+Select.h
//  BaseModel
//
//  Created by muxi on 15/3/30.
//  Copyright (c) 2015年 muxi. All rights reserved.
//  查询数据

#import <Foundation/Foundation.h>

@interface NSObject (Select)




/**
 *  查询（无需包含关键字）
 *
 *  @param where   where
 *  @param groupBy groupBy
 *  @param orderBy orderBy
 *  @param limit   limit
 *
 *  @return 结果集
 */
+(NSArray *)selectWhere:(NSString *)where groupBy:(NSString *)groupBy orderBy:(NSString *)orderBy limit:(NSString *)limit;



/**
 *  根据hostID精准的查找唯一对象
 */
+(instancetype)find:(NSUInteger)hostID;








@end
