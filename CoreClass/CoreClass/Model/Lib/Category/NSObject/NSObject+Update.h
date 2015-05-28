//
//  NSObject+Update.h
//  BaseModel
//
//  Created by muxi on 15/3/30.
//  Copyright (c) 2015年 muxi. All rights reserved.
//  更新数据：如果数据不存在，则自动忽略，不会自动添加
//  请在线程中执行

#import <Foundation/Foundation.h>

@interface NSObject (Update)


/**
 *  更新数据（级联更新）
 *
 *  @param model 模型数据
 *
 *  @return 执行结果
 */
+(BOOL)update:(id)model;




/**
 *  更新数据（批量更新）
 *
 *  @param models 模型数组
 *
 *  @return 执行结果
 */
+(BOOL)updateModels:(NSArray *)models;







@end
