//
//  NSObject+Save.h
//  CoreModel
//
//  Created by muxi on 15/3/30.
//  Copyright (c) 2015年 muxi. All rights reserved.
//  保存数据，如果数据不存在，则执行添加操作；如果数据已经存在，则执行更新操作，总之数据一定会记录到数据库中并成为最新的数据记录。


#import <Foundation/Foundation.h>

@interface NSObject (Save)




+(void)save:(id)model resBlock:(void(^)(BOOL res))resBlock;



+(void)saveModels:(NSArray *)models resBlock:(void(^)(BOOL res))resBlock;


+(void)saveDirect:(id)obj resBlock:(void(^)(BOOL res))resBlock;









@end
