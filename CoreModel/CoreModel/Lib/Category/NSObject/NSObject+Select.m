//
//  NSObject+Select.m
//  CoreModel
//
//  Created by muxi on 15/3/30.
//  Copyright (c) 2015年 muxi. All rights reserved.
//

#import "NSObject+Select.h"
#import "CoreFMDB.h"
#import "CoreModel.h"
#import "NSObject+CoreModelCommon.h"
#import "CoreModelConst.h"
#import "NSString+Stackoverflow.h"

@implementation NSObject (Select)


+(void)selectWhere:(NSString *)where groupBy:(NSString *)groupBy orderBy:(NSString *)orderBy limit:(NSString *)limit selectResultsBlock:(void(^)(NSArray *selectResults))selectResultsBlock{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self selectWhereAction:where groupBy:groupBy orderBy:orderBy limit:limit selectResultsBlock:selectResultsBlock];
    });
}

+(void)selectWhereAction:(NSString *)where groupBy:(NSString *)groupBy orderBy:(NSString *)orderBy limit:(NSString *)limit selectResultsBlock:(void(^)(NSArray *selectResults))selectResultsBlock{

    
    if(![self checkTableExists]){
        if(CoreModelDeBug) NSLog(@"错误：你操作的模型%@在数据库中没有对应的数据表！",[self modelName]);
        if(selectResultsBlock != nil) selectResultsBlock(nil);return;
    }
    
    if(CoreModelDeBug) NSLog(@"查询开始：%@",[NSThread currentThread]);
    
    NSMutableString *sqlM=[NSMutableString stringWithFormat:@"SELECT * FROM %@",[self modelName]];

    if(where != nil) [sqlM appendFormat:@" WHERE %@",where];

    if(groupBy != nil){[sqlM appendFormat:@" GROUP BY hostID,%@",groupBy];}else{[sqlM appendString:@" GROUP BY hostID"];};

    if(orderBy != nil) [sqlM appendFormat:@" ORDER BY %@",orderBy];

    if(limit != nil) [sqlM appendFormat:@" LIMIT %@",limit];

    NSString *sql=[NSString stringWithFormat:@"%@;",sqlM];

    NSMutableArray *resultsM=[NSMutableArray array];

    NSMutableArray *fieldsArrayM=[NSMutableArray array];
    
    [CoreFMDB executeQuery:sql queryResBlock:^(FMResultSet *set) {
        
        while ([set next]) {
            
            CoreModel *model=[[self alloc] init];
            
            [self enumNSObjectProperties:^(CoreProperty *property, BOOL *stop) {
                
                BOOL skip=[self skipField:property];
                
                if(!skip){
                    
                    NSString *code = property.code;
                    
                    NSString *sqliteTye=[self sqliteType:code];
                    
                    if([property.typeString isEqualToString:CoreNSArray]){
                        
                        if([self isBasicTypeInNSArray:[self statementForNSArrayProperties][property.name]]){
                            sqliteTye = TEXT_TYPE;
                        }
                    }
                    
                    if(![sqliteTye isEqualToString:EmptyString]){
                        
                        NSString *propertyName = property.name;
                        NSString *value=[set stringForColumn:propertyName];
                        
                        if([CoreBOOL rangeOfString:code].length>0){
                            
                            NSNumber *boolValue = @(value.integerValue);
                            
                            [model setValue:boolValue forKey:propertyName];
                            
                        }else{
                            
                            if([code isEqualToString:CoreNSData]){
                                value = [[NSData alloc] initWithBase64EncodedString:value options:NSDataBase64DecodingIgnoreUnknownCharacters];
                            }
                            
                            [model setValue:value forKey:propertyName];
                        }
                        
                        
                        if([property.typeString isEqualToString:CoreNSArray]){
                            
                            if([self isBasicTypeInNSArray:[self statementForNSArrayProperties][property.name]]){
                                
                                
                                NSArray *normalArr = [value toArray:[[self statementForNSArrayProperties][property.name] isEqualToString:CoreNSString]];
                                
                                [model setValue:normalArr forKey:propertyName];
                            }
                        }
                        
                    }else{
                        if(![fieldsArrayM containsObject:property]) [fieldsArrayM addObject:property];
                    }
                }
            }];
            
            [resultsM addObject:model];
        }
    }];
    
    __block BOOL hasChildrendArrayProperty = NO;

    if(fieldsArrayM.count!=0){
        
        [resultsM enumerateObjectsUsingBlock:^(CoreModel *model, NSUInteger idx, BOOL *stop) {
            
            [fieldsArrayM enumerateObjectsUsingBlock:^(CoreProperty *ivar, NSUInteger idx, BOOL *stop) {
                
                if(![ivar.typeString isEqualToString:CoreNSArray]){
                    
                    NSString *where_childModelField=[NSString stringWithFormat:@"pModel='%@' AND pid=%@",NSStringFromClass(model.class),@(model.hostID)];
                    
                    NSString *limit=@"1";
                    
                    [NSClassFromString(ivar.typeString) selectWhere:where_childModelField groupBy:nil orderBy:nil limit:limit selectResultsBlock:^(NSArray *selectResults) {
                        
                        if(selectResults.count>0){
                            [model setValue:selectResults.firstObject forKey:ivar.name];
                        }
                        
                    }];
                    
                }else{
                    
                    hasChildrendArrayProperty = YES;
                    
                    NSString *where_childModelField=[NSString stringWithFormat:@"pModel='%@' AND pid=%@",NSStringFromClass(model.class),@(model.hostID)];
                    
                    Class Cls = NSClassFromString([self statementForNSArrayProperties][ivar.name]);
                    
                    
                    [Cls selectWhere:where_childModelField groupBy:nil orderBy:nil limit:nil selectResultsBlock:^(NSArray *selectResults) {
                        
                        if(selectResults.count>0){
                            [model setValue:selectResults forKey:ivar.name];
                        }
                        
                        if(selectResultsBlock != nil) selectResultsBlock(resultsM);
                        
                    }];
                    
                }
                
            }];
            
        }];
    }
    
    if(!hasChildrendArrayProperty){if(selectResultsBlock != nil) selectResultsBlock(resultsM);}
    
    ThreadShow(数据查询)
}




+(void)find:(NSUInteger)hostID selectResultBlock:(void(^)(id selectResult))selectResultBlock{
    
    if(![self checkTableExists]){

        if(CoreModelDeBug) NSLog(@"错误：你操作的模型%@在数据库中没有对应的数据表！",[self modelName]);
        if (selectResultBlock != nil) selectResultBlock(nil);return;
    }
    
    NSString *where=[NSString stringWithFormat:@"hostID=%@",@(hostID)];
    
    NSString *limit=@"1";
    
    [self selectWhere:where groupBy:nil orderBy:nil limit:limit selectResultsBlock:^(NSArray *selectResults) {
        
        if (selectResultBlock != nil) selectResultBlock(selectResults.firstObject);
    }];

}


@end
