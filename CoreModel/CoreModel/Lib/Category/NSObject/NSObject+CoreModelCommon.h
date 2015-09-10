//
//  NSObject+CoreModelCommon.h
//  CoreModel
//
//  Created by muxi on 15/3/30.
//  Copyright (c) 2015年 muxi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+MJProperty.h"
#import "NSString+Stackoverflow.h"
#import "NSOperationQueue+Queue.h"
#import "MJProperty.h"


@interface NSObject (CoreModelCommon)


+(NSString *)fieldSql:(MJProperty *)ivar;

+(BOOL)skipField:(MJProperty *)ivar;

+ (NSArray *)ignoredPropertyNamesForSqlTransform;

+(NSString *)deleteLastChar:(NSString *)str;

+(BOOL)checkTableExists;

+(void)checkUsage:(id)model;

+(NSString *)sqliteType:(NSString *)fieldType;

+(NSString *)modelName;

+(BOOL)isBasicTypeInNSArray:(MJProperty *)property;

/** 模型对比时需要忽略的字段 */
+(NSArray *)constrastIgnorFields;

/** 当模型中含有NSArray数组成员属性时，需要明确指明NSArray内部数据类型key:属性名，value: 数据类型NSString版 */
+(NSDictionary *)statementForNSArrayProperties;

/** 封装 */
+(void)enumNSObjectProperties:(void(^)(MJProperty *property, BOOL *stop))properties;




@end
