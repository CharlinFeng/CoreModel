//
//  NSObject+Delete.h
//  CoreModel
//
//  Created by muxi on 15/3/30.
//  Copyright (c) 2015年 muxi. All rights reserved.
//  删除数据
//  请在主线程中执行

#import <Foundation/Foundation.h>

@interface NSObject (Delete)


+(void)deleteWhere:(NSString *)where resBlock:(void(^)(BOOL res))resBlock;


+(void)delete:(NSUInteger)hostID resBlock:(void(^)(BOOL res))resBlock;


+(void)truncateTable:(void(^)(BOOL res))resBlock;



@end
