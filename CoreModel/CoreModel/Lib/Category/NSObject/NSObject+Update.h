//
//  NSObject+Update.h
//  CoreModel
//
//  Created by muxi on 15/3/30.
//  Copyright (c) 2015年 muxi. All rights reserved.
//  更新数据：如果数据不存在，则自动忽略，不会自动添加
//  请在线程中执行

#import <Foundation/Foundation.h>

@interface NSObject (Update)



+(void)update:(id)model resBlock:(void(^)(BOOL res))resBlock;

+(void)updateModels:(NSArray *)models resBlock:(void(^)(BOOL res))resBlock;


@end
