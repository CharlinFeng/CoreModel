//
//  NSObject+Select.m
//  BaseModel
//
//  Created by muxi on 15/3/30.
//  Copyright (c) 2015年 muxi. All rights reserved.
//

#import "NSObject+Select.h"
#import "CoreFMDB.h"
#import "MJProperty.h"
#import "MJType.h"
#import "BaseModel.h"
#import "NSObject+BaseModelCommon.h"
#import "BaseMoelConst.h"

@implementation NSObject (Select)


/**
 *  查询（无需包含关键字）
 *
 *  @param where   where
 *  @param groupBy groupBy
 *  @param orderBy orderBy
 *  @param limit   limit
 *
 *  @return 结果集
 */
+(NSArray *)selectWhere:(NSString *)where groupBy:(NSString *)groupBy orderBy:(NSString *)orderBy limit:(NSString *)limit{
    
    //检查表是否存在，如果不存在，直接返回
    if(![self checkTableExists]){
        NSLog(@"错误：你操作的模型%@在数据库中没有对应的数据表！",[self modelName]);
        return nil;
    }
    
    NSLog(@"查询开始：%@",[NSThread currentThread]);
    
    NSMutableString *sqlM=[NSMutableString stringWithFormat:@"SELECT * FROM %@",[self modelName]];

    //where
    if(where != nil) [sqlM appendFormat:@" WHERE %@",where];

    //groupBy
    if(groupBy != nil) [sqlM appendFormat:@" GROUP BY %@",groupBy];

    //orderBy
    if(orderBy != nil) [sqlM appendFormat:@" ORDER BY %@",orderBy];

    //limit
    if(limit != nil) [sqlM appendFormat:@" LIMIT %@",limit];

    //结束添加分号
    NSString *sql=[NSString stringWithFormat:@"%@;",sqlM];

    NSMutableArray *resultsM=[NSMutableArray array];

    NSMutableArray *fieldsArrayM=[NSMutableArray array];
    
    [CoreFMDB executeQuery:sql queryResBlock:^(FMResultSet *set) {
        
        while ([set next]) {
            
            BaseModel *model=[[self alloc] init];
            
            [self enumerateProperties:^(MJProperty *property, BOOL *stop) {
                
                BOOL skip=[self skipField:property];
                
                if(!skip){
                    
                    NSString *code = property.type.code;
                    
                    NSString *sqliteTye=[self sqliteType:code];
                    
                    if(![sqliteTye isEqualToString:EmptyString]){
                        
                        NSString *propertyName = property.name;
                        NSString *value=[set stringForColumn:propertyName];
                        
                        
                        if([CoreBOOL rangeOfString:code].length>0){//bool
                            
                            NSNumber *boolValue = @(value.integerValue);
                            
                            //设置值
                            [model setValue:boolValue forKey:propertyName];
                            
                        }else{
                            
                            //设置值
                            [model setValue:value forKey:propertyName];
                        }
                        

                        
                    }else{
                        if(![fieldsArrayM containsObject:property]) [fieldsArrayM addObject:property];
                    }
                }
            }];

            
            [resultsM addObject:model];
        }
    }];

    if(fieldsArrayM.count!=0){
        
        //联级查询
        [resultsM enumerateObjectsUsingBlock:^(BaseModel *model, NSUInteger idx, BOOL *stop) {
            
            [fieldsArrayM enumerateObjectsUsingBlock:^(MJProperty *ivar, NSUInteger idx, BOOL *stop) {
                
                NSString *where_childModelField=[NSString stringWithFormat:@"pModel='%@' AND pid=%@",NSStringFromClass(model.class),@(model.hostID)];
                
                NSString *limit=@"1";
                
                BaseModel *childModel=[NSClassFromString(ivar.type.code) selectWhere:where_childModelField groupBy:nil orderBy:nil limit:limit].firstObject;
                
                [model setValue:childModel forKey:ivar.name];
            }];
            
        }];
    }
    NSLog(@"查询完成：%@",[NSThread currentThread]);
    return resultsM;
}




/**
 *  根据hostID精准的查找唯一对象
 */
+(instancetype)find:(NSUInteger)hostID{
    
    //检查表是否存在，如果不存在，直接返回
    if(![self checkTableExists]){
        NSLog(@"错误：你操作的模型%@在数据库中没有对应的数据表！",[self modelName]);
        return nil;
    }
    
    NSString *where=[NSString stringWithFormat:@"hostID=%@",@(hostID)];
    
    NSString *limit=@"1";
    
    NSArray *models=[self selectWhere:where groupBy:nil orderBy:nil limit:limit];
    
    if(models==nil || models.count==0) return nil;
    
    return models.firstObject;
}




@end
