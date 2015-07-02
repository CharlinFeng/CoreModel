//
//  NSObject+Create.m
//  BaseModel
//
//  Created by muxi on 15/3/30.
//  Copyright (c) 2015年 muxi. All rights reserved.
//

#import "NSObject+Create.h"
#import "NSObject+BaseModelCommon.h"
#import "BaseMoelConst.h"
#import "CoreFMDB.h"
#import "MJProperty.h"
#import "MJType.h"
#import "NSObject+MJProperty.h"

@implementation NSObject (Create)


/**
 *  自动创表
 */
+(void)tableCreate{

    NSString *modelName = [self modelName];

    //本类不需要创建
    if([modelName isEqualToString:@"BaseModel"]) return;

    //自动创表
    NSMutableString *sql=[NSMutableString string];

    //拼接表名
    [sql appendFormat:@"CREATE TABLE IF NOT EXISTS %@ (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL DEFAULT 0,",modelName];

    //在遍历成员变量时记录入数组
    NSMutableArray *ivarsM=[NSMutableArray array];

    [self enumerateProperties:^(MJProperty *property, BOOL *stop) {
        
        NSString *sql_field = [self fieldSql:property];
        
        BOOL skip=[self skipField:property];
        
        //如果遇到了模型字段，则需要跳过
        if(![sql_field isEqualToString:EmptyString] && !skip){
            
            [sql appendString:sql_field];
            
            //记录
            [ivarsM addObject:property];
        }
    }];


    //删除最后一个分号
    NSString *subSql = [self deleteLastChar:sql];

    //语句结束
    NSString *sql_Create = [NSString stringWithFormat:@"%@);",subSql];

    //打印sql
//    NSLog(@"%@",sql_Create);

    //执行创表语句
    BOOL createRes = [CoreFMDB executeUpdate:sql_Create];
    
    if(!createRes){
        NSLog(@"%@ 创表失败",modelName);
        return;
    }
    NSLog(@"表创建完毕%@",[NSThread currentThread]);
    //字段检查
    [self fieldsCheck:modelName ivars:ivarsM];
}

/**
 *  字段检查
 */
+(void)fieldsCheck:(NSString *)table ivars:(NSArray *)ivars{

    //获取数据库字段信息
    NSArray *columns=[CoreFMDB executeQueryColumnsInTable:table];
    
    //移除id字段
    NSMutableArray *columnsM=[NSMutableArray arrayWithArray:columns];
    [columnsM removeObject:@"id"];
    NSLog(@"字段也检查完毕%@",[NSThread currentThread]);
    //数据库字段<->模型字段
    //如果数据库的字段不比模型字段少，皆不处理
    if(columnsM.count>=ivars.count) return;

    //如果运行到这里，表明模型有新增字段
    //遍历模型字段数据
    for (MJProperty *ivar in ivars) {

        //如果数据库中包含模型字段，则不处理
        if([columnsM containsObject:ivar.name]) continue;

        NSMutableString *sql_addM=[NSMutableString stringWithFormat:@"ALTER TABLE '%@' ADD COLUMN %@",table,[self fieldSql:ivar]];

        //删除最后的，号
        NSString *sql_add=[self deleteLastChar:sql_addM];

        //得到最终的sql
        NSString *sql=[NSString stringWithFormat:@"%@;",sql_add];

        //执行sql
        BOOL addRes = [CoreFMDB executeUpdate:sql];
        
        if(!addRes){
            NSLog(@"模型%@字段新增失败！",table);
            return;
        }
        
        NSLog(@"注意：模型 %@ 有新增加的字段 %@,已经实时添加到数据库中！",table,ivar.name);
    }
    
    
}




@end
