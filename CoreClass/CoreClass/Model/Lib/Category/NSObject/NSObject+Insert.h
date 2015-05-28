//
//  NSObject+Insert.h
//  BaseModel
//
//  Created by muxi on 15/3/30.
//  Copyright (c) 2015年 muxi. All rights reserved.
//  添加数据：如果数据已经存在，则自动忽略，不会更新
//  请在主线程中执行

#import <Foundation/Foundation.h>

@interface NSObject (Insert)



/**
 *  插入数据（单个）
 *
 *  @param model 模型数据
 *
 *  @return 插入数据的执行结果
 */
+(BOOL)insert:(id)model;




/**
 *  插入数据（批量）
 *
 *  @param models 模型数组
 *
 *  @return 批量插入数据的执行结果
 */
+(BOOL)inserts:(NSArray *)models;





@end
