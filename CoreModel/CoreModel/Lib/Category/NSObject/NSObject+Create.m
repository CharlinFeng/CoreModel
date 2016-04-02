//
//  NSObject+Create.m
//  CoreModel
//
//  Created by muxi on 15/3/30.
//  Copyright (c) 2015年 muxi. All rights reserved.
//

#import "NSObject+Create.h"
#import "NSObject+CoreModelCommon.h"
#import "CoreModelConst.h"
#import "CoreFMDB.h"


@implementation NSObject (Create)


+(void)tableCreate{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self tableCreate_thread];
    });
}



+(void)tableCreate_thread{
    
    NSString *modelName = [self modelName];
    
    if([modelName isEqualToString:@"CoreModel"]) return;
    
    NSMutableString *sql=[NSMutableString string];
    
    [sql appendFormat:@"CREATE TABLE IF NOT EXISTS %@ (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL DEFAULT 0,",modelName];
    
    NSMutableArray *ivarsM=[NSMutableArray array];
    
    [self enumNSObjectProperties:^(CoreProperty *property, BOOL *stop) {
        
        NSString *sql_field = [self fieldSql:property];
        
        if([property.typeString isEqualToString:CoreNSArray]){
            
            NSDictionary *dict = [self statementForNSArrayProperties];
            
            NSString *errorMsg = [NSString stringWithFormat:@"错误：请在%@类中为您的NSArray类型的%@属性增加说明信息，实现statementForNSArrayProperties静态方法！",[self modelName],property.name];
            
            NSAssert(dict[property.name] != nil, errorMsg);
            NSAssert(![dict[property.name] isEqualToString:@"NSInteger"], @"错误：OC数组内不可能存放NSInteger");
            NSAssert(![dict[property.name] isEqualToString:@"NSUInteger"], @"错误：OC数组内不可能存放NSUInteger");
            NSAssert(![dict[property.name] isEqualToString:@"BOOL"], @"错误：OC数组内不可能存放BOOL");
            NSAssert(![dict[property.name] isEqualToString:@"CGFloat"], @"错误：OC数组内不可能存放CGFloat");
            NSAssert(![dict[property.name] isEqualToString:@"double"], @"错误：OC数组内不可能存放double");
            
            
            if([self isBasicTypeInNSArray:[self statementForNSArrayProperties][property.name]]){
                sql_field = [NSString stringWithFormat:@"%@ %@ ,",property.name,TEXT_TYPE];
            }
        }
        
        BOOL skip=[self skipField:property];
    
        if(![sql_field isEqualToString:EmptyString] && !skip){
            
            [sql appendString:sql_field];
            
            [ivarsM addObject:property];
        }
    }];
    
    NSString *subSql = [self deleteLastChar:sql];
    
    NSString *sql_Create = [NSString stringWithFormat:@"%@);",subSql];
 
    BOOL createRes = [CoreFMDB executeUpdate:sql_Create];
    
    if(!createRes){
        if(CoreModelDeBug) NSLog(@"%@ 创表失败",modelName);
        return;
    }
    if(CoreModelDeBug) NSLog(@"表创建完毕%@",[NSThread currentThread]);
    
    [self fieldsCheck:modelName ivars:ivarsM];
    
    ThreadShow(创表)
}

+(void)fieldsCheck:(NSString *)table ivars:(NSArray *)ivars{

    ThreadShow(字段检查)
    
    NSArray *columns=[CoreFMDB executeQueryColumnsInTable:table];
    
    NSMutableArray *columnsM=[NSMutableArray arrayWithArray:columns];
    [columnsM removeObject:@"id"];
    if(CoreModelDeBug) NSLog(@"字段也检查完毕%@",[NSThread currentThread]);

    if(columnsM.count>=ivars.count) return;

    for (CoreProperty *ivar in ivars) {

        if([columnsM containsObject:ivar.name]) continue;

        NSMutableString *sql_addM=[NSMutableString stringWithFormat:@"ALTER TABLE '%@' ADD COLUMN %@",table,[self fieldSql:ivar]];

        NSString *sql_add=[self deleteLastChar:sql_addM];

        NSString *sql=[NSString stringWithFormat:@"%@;",sql_add];

        BOOL addRes = [CoreFMDB executeUpdate:sql];
        
        if(!addRes){
            if(CoreModelDeBug) NSLog(@"模型%@字段新增失败！",table);
            return;
        }
        
       if(CoreModelDeBug) NSLog(@"注意：模型 %@ 有新增加的字段 %@,已经实时添加到数据库中！",table,ivar.name);
    }
}


@end
