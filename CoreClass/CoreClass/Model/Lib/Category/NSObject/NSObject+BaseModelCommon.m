//
//  NSObject+BaseModelCommon.m
//  BaseModel
//
//  Created by muxi on 15/3/30.
//  Copyright (c) 2015年 muxi. All rights reserved.
//

#import "NSObject+BaseModelCommon.h"
#import "MJProperty.h"
#import "MJType.h"
#import "BaseMoelConst.h"
#import "CoreFMDB.h"
#import "NSObject+BaseModelCommon.h"

@implementation NSObject (BaseModelCommon)


/**
 *  MJIvar转为对应的字段sql
 *
 *  @param ivar MJIvar
 *
 *  @return 字段sql
 */
+(NSString *)fieldSql:(MJProperty *)ivar{

    //处理成员属性名(字段名)
    NSString *fieldName = ivar.name;

    //判断其数据类型
    NSString *fieldType = ivar.type.code;

    NSString *sqliteTye=[self sqliteType:fieldType];

    if([sqliteTye isEqualToString:EmptyString]){

        //此属性是模型，且已经动态生成模型字段对应的数据表
        return EmptyString;
    }

    NSString *fieldSql=[NSString stringWithFormat:@"%@ %@,",fieldName,sqliteTye];

    return fieldSql;
}


/**
 *  是否跳过处理某个字段
 *
 *  @param ivar 字段
 *
 *  @return 结果
 */
+(BOOL)skipField:(MJProperty *)ivar{

    //检查是否有需要忽略的属性不需要转为数据库字段
    NSArray *ignoredPropertyNames = nil;
    if ([[self class] respondsToSelector:@selector(ignoredPropertyNamesForSqlTransform)]) {
        ignoredPropertyNames = [[self class] ignoredPropertyNamesForSqlTransform];
    }
    BOOL skip=ignoredPropertyNames!=nil && [ignoredPropertyNames containsObject:ivar.name];
    
    return skip;
}



/**
 *  这个数组中的属性名将会被忽略：不会被自动转换为数据库中的字段
 */
+ (NSArray *)ignoredPropertyNamesForSqlTransform{return @[@"hash",@"superclass",@"description",@"debugDescription"];}





/**
 *  根据成员属性的类型获取对应的sqlite数据类型创表语句
 *
 *  @param fieldType 成员属性的OC属性类型
 *
 *  @return sqlite数据类型创表语句
 */
+(NSString *)sqliteType:(NSString *)fieldType{

    NSDictionary *map=@{
                        INTEGER_TYPE:@[CoreNSInteger,CoreNSUInteger,CoreEnum_int,CoreBOOL],
                        TEXT_TYPE:@[CoreNSString],
                        REAL_TYPE:@[CoreCGFloat]
                        };

    __block NSString *sqliteType=EmptyString;

    //遍历
    [map enumerateKeysAndObjectsUsingBlock:^(NSString *blockSqliteType, NSArray *blockFieldTypes, BOOL *stop) {

        [blockFieldTypes enumerateObjectsUsingBlock:^(NSString *typeStringConst, NSUInteger idx, BOOL *stop) {
            
            NSRange range = [typeStringConst rangeOfString:fieldType];
            
            if(range.length>0){
                sqliteType = blockSqliteType;
            }
        }];
    }];

    return sqliteType;
}









/*
 *  判断表是否存在
 */
+(BOOL)checkTableExists{
    
    NSString *alias=@"tableCount";
    
    NSString *sql=[NSString stringWithFormat:@"SELECT COUNT(*) %@ FROM sqlite_master WHERE type='table' AND name='%@';",alias,[self modelName]];
    
    __block BOOL res=NO;
    
    [CoreFMDB executeQuery:sql queryResBlock:^(FMResultSet *set) {
        
        while ([set next]) {
            NSUInteger count = [[set stringForColumn:alias] integerValue];

            res=count==1;
        }
    }];

    return res;
}


/*
 *  删除最后的字符
 */
+(NSString *)deleteLastChar:(NSString *)str{
    return [str substringToIndex:str.length - 1];
}


/**
 *  模型名
 *  此处是专门为Swift处理
 *
 *  @return 模型  名
 */
+(NSString *)modelName{
    return [NSStringFromClass(self) componentsSeparatedByString:@"."].lastObject;
}
@end
