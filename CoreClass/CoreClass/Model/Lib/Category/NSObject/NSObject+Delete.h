//
//  NSObject+Delete.h
//  BaseModel
//
//  Created by muxi on 15/3/30.
//  Copyright (c) 2015年 muxi. All rights reserved.
//  删除数据
//  请在主线程中执行

#import <Foundation/Foundation.h>

@interface NSObject (Delete)



/**
 *  条件删除(级联删除)
 *
 *  @param where   where
 *
 *  @return 执行结果
 */
+(BOOL)deleteWhere:(NSString *)where;



/**
 *  根据hostID快速删除一条记录
 *
 *  @param hostID hostID
 *
 *  @return 执行结果
 */
+(BOOL)delete:(NSUInteger)hostID;




@end
