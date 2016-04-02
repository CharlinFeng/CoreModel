//
//  NSObject+Delete.m
//  CoreModel
//
//  Created by muxi on 15/3/30.
//  Copyright (c) 2015年 muxi. All rights reserved.
//

#import "NSObject+Delete.h"
#import "NSObject+CoreModelCommon.h"
#import "CoreFMDB.h"
#import "NSObject+Select.h"
#import "CoreModel.h"
#import "CoreModelConst.h"

@implementation NSObject (Delete)


+(void)deleteWhere:(NSString *)where resBlock:(void(^)(BOOL res))resBlock{
    [self deleteWhere:where resBlock:resBlock needThread:YES];
}


+(void)deleteWhere:(NSString *)where resBlock:(void(^)(BOOL res))resBlock needThread:(BOOL)needThread{
    
    if(needThread){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self deleteWhereAction:where resBlock:resBlock];
        });
    }else{
        [self deleteWhereAction:where resBlock:resBlock];
    }
}

+(void)deleteWhereAction:(NSString *)where resBlock:(void(^)(BOOL res))resBlock{

    if(![self checkTableExists]){
        
        if(CoreModelDeBug) NSLog(@"错误：你操作的模型%@在数据库中没有对应的数据表！%@",[self modelName],AutoMsg);
        if(resBlock != nil) resBlock(NO);
        return;
    }
    
    NSString *sql=[NSString stringWithFormat:@"DELETE FROM %@",[self modelName]];
    
    if(where != nil) sql = [NSString stringWithFormat:@"%@ WHERE %@",sql,where];
    
    sql = [NSString stringWithFormat:@"%@;",sql];
    
    [self selectWhere:where groupBy:nil orderBy:nil limit:nil selectResultsBlock:^(NSArray *deleteModels) {
        if(deleteModels==nil || deleteModels.count==0){
            if (resBlock != nil) resBlock(YES);return;
        }
        
        for (CoreModel *baseModle in deleteModels) {
            
            [baseModle.class enumNSObjectProperties:^(CoreProperty *property, BOOL *stop) {

                BOOL skip=[self skipField:property];
                
                if(!skip){
                    
                    NSString *sqliteTye=[self sqliteType:property.code];
                    
                    if([property.typeString isEqualToString:CoreNSArray]){
                        
                        if([self isBasicTypeInNSArray:[self statementForNSArrayProperties][property.name]]){
                            sqliteTye = TEXT_TYPE;
                        }
                    }
                    
 
                    if([sqliteTye isEqualToString:EmptyString]){
                        
                        if([property.typeString isEqualToString:CoreNSArray]){
                            
                            NSArray *CoreModels = (NSArray *)[baseModle valueForKeyPath:property.name];
                            
                            [CoreModels enumerateObjectsUsingBlock:^(CoreModel *sub, NSUInteger idx, BOOL *stop) {
                                
                                NSString *where=[NSString stringWithFormat:@"pModel='%@' AND pid=%@",NSStringFromClass(sub.class),@(sub.hostID)];
                                
                                [[sub class] deleteWhere:where resBlock:resBlock];
                            }];

                        }else{
                            
                            Class ModelClass=NSClassFromString(property.code);
                            
                            NSString *where=[NSString stringWithFormat:@"pModel='%@' AND pid=%@",NSStringFromClass(baseModle.class),@(baseModle.hostID)];
                            
                            [ModelClass deleteWhere:where resBlock:resBlock];
                        }
                        
                    }
                }
            }];
        }
        
        BOOL res =  [CoreFMDB executeUpdate:sql];
        
        if(CoreModelDeBug) {if(!res) NSLog(@"错误：执行删除失败，sql语句为：%@",sql);};
        
        ThreadShow(删除数据)

        TriggerBlock(resBlock, res)
    }];
}



+(void)delete:(NSUInteger)hostID resBlock:(void(^)(BOOL res))resBlock{
    
    NSString *where=[NSString stringWithFormat:@"hostID=%@",@(hostID)];
    
    [self deleteWhere:where resBlock:resBlock needThread:YES];
}

+(void)truncateTable:(void(^)(BOOL res))resBlock{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if(![self checkTableExists]){
            
            if(CoreModelDeBug) NSLog(@"错误：你操作的模型%@在数据库中没有对应的数据表！%@",[self modelName],AutoMsg);
            if(resBlock != nil) resBlock(NO);
            return;
        }
        
        BOOL res = [CoreFMDB truncateTable:[self modelName]];
        
        TriggerBlock(resBlock, res)
    });
    
}

@end
