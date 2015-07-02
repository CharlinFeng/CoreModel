//
//  NSObject+BaseModelCommon.h
//  BaseModel
//
//  Created by muxi on 15/3/30.
//  Copyright (c) 2015年 muxi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+MJProperty.h"


@interface NSObject (BaseModelCommon)

/**
 *  MJIvar转为对应的字段sql
 *
 *  @param ivar MJIvar
 *
 *  @return 字段sql
 */
+(NSString *)fieldSql:(MJProperty *)ivar;



/**
 *  是否跳过处理某个字段
 *
 *  @param ivar 字段
 *
 *  @return 结果
 */
+(BOOL)skipField:(MJProperty *)ivar;



/**
 *  这个数组中的属性名将会被忽略：不会被自动转换为数据库中的字段
 */
+ (NSArray *)ignoredPropertyNamesForSqlTransform;


/*
 *  删除最后的字符
 */
+(NSString *)deleteLastChar:(NSString *)str;



/*
 *  判断表是否存在
 */
+(BOOL)checkTableExists;



/**
 *  根据成员属性的类型获取对应的sqlite数据类型创表语句
 *
 *  @param fieldType 成员属性的OC属性类型
 *
 *  @return sqlite数据类型创表语句
 */
+(NSString *)sqliteType:(NSString *)fieldType;



/**
 *  模型名
 *  此处是专门为Swift处理
 *
 *  @return 模型  名
 */
+(NSString *)modelName;






@end
