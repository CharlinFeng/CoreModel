//
//  NSObject+Insert.m
//  CoreModel
//
//  Created by muxi on 15/3/30.
//  Copyright (c) 2015年 muxi. All rights reserved.
//

#import "NSObject+Insert.h"
#import "CoreModel.h"
#import "MJProperty.h"
#import "MJPropertyType.h"
#import "NSObject+CoreModelCommon.h"
#import "CoreModelConst.h"
#import "CoreFMDB.h"
#import "NSObject+Select.h"
#import "NSArray+CoreModel.h"

@implementation NSObject (Insert)


+(void)insertAction:(id)model resBlock:(void(^)(BOOL res))resBlock {
    
    [self checkUsage:model];
    
    if(![self checkTableExists]){
        
        if(CoreModelDeBug) NSLog(@"注意：单条数据插入时，你操作的模型%@在数据库中没有对应的数据表！%@",[self modelName],AutoMsg);
      
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(AutoTry * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self insertAction:model resBlock:resBlock];
        });
        
        return;
    }
    
    CoreModel *coreModel=(CoreModel *)model;

    NSAssert(coreModel.hostID > 0, @"错误：数据插入失败,无hostID的数据插入都是耍流氓，你必须设置模型的模型hostID!");

    if(CoreModelDeBug)  NSLog(@"数据插入开始%@",[NSThread currentThread]);

    [self find:coreModel.hostID selectResultBlock:^(id dbModel) {
        
        if(dbModel!=nil){
            
            if(CoreModelDeBug) NSLog(@"错误：%@表中hostID=%@的数据记录已经存在！",[self modelName],@(coreModel.hostID));
            if(resBlock != nil) resBlock(NO);return;
        }
        
        NSMutableString *fields=[NSMutableString string];
        NSMutableString *values=[NSMutableString string];
        
        [self enumNSObjectProperties:^(MJProperty *property, BOOL *stop) {
            
            BOOL skip=[self skipField:property];
            
            if(!skip){
                
                NSString *sqliteTye=[self sqliteType:property.type.code];
   
                id value =[model valueForKeyPath:property.name];
                
                if([property.type.code isEqualToString:CoreNSArray]){
                    
                    if([self isBasicTypeInNSArray:[self statementForNSArrayProperties][property.name]]){
                        sqliteTye = TEXT_TYPE;
                    }
                }
                
                if(![sqliteTye isEqualToString:EmptyString]){
                    
                    [fields appendFormat:@"%@,",property.name];
                    
                    if([property.type.code isEqualToString:CoreNSString]){
                        
                        if(value == nil) value=@"";
                        
                        value=[NSString stringWithFormat:@"'%@'",value];
                        
                    }else if ([property.type.code isEqualToString:CoreNSData]){
                        
                        if(value != nil) {
                            
                            value =[NSString stringWithFormat:@"'%@'",[(NSData *)value base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength]];
                        }else{
                            value = @"''";
                        }
                    }
                    
                    if([property.type.code isEqualToString:CoreNSArray]){
                        
                        
                        if([self isBasicTypeInNSArray:[self statementForNSArrayProperties][property.name]]){
                            
                            NSString *valueStr = nil;
                            
                            if(value == nil){
                                valueStr = @"";
                            }else{
                                valueStr = ((NSArray *)value).toString;
                            }
                            
                            value = [NSString stringWithFormat:@"'%@'",valueStr];
                        }
                    }
                    
                    if(value != nil) {
                        [values appendFormat:@"%@,",value];
                    }
                    
                }else{
                    
                    if(property.name!=nil && value!=nil){
                        
                        
                        if(![property.type.code isEqualToString:CoreNSArray]){
                            
                            CoreModel *childModel=(CoreModel *)value;
                            
                            [childModel setValue:[self modelName] forKey:@"pModel"];
                            
                            [childModel setValue:@(coreModel.hostID) forKey:@"pid"];
                            
                            [NSClassFromString(property.type.code) insert:value resBlock:resBlock];

                        }else{
                            
                            if(![self isBasicTypeInNSArray:[self statementForNSArrayProperties][property.name]]){
                                
                                NSArray *modelsArray = (NSArray *)value;
                                [modelsArray enumerateObjectsUsingBlock:^(CoreModel *i, NSUInteger idx, BOOL *stop) {
                                    [i setValue:NSStringFromClass([self class]) forKeyPath:@"pModel"];
                                    [i setValue:@(coreModel.hostID) forKeyPath:@"pid"];
                                }];
                                
                                Class Cls = NSClassFromString([self statementForNSArrayProperties][property.name]);
                                
                                [Cls inserts:modelsArray resBlock:resBlock];
                                
                            }
                        }
                        
                    }
                }
            }
        }];
        
        NSString *fields_sub=[self deleteLastChar:fields];
        NSString *values_sub=[self deleteLastChar:values];
        
        NSString *sql=[NSString stringWithFormat:@"INSERT INTO %@ (%@) VALUES (%@);",[self modelName],fields_sub,values_sub];
        
        BOOL insertRes = [CoreFMDB executeUpdate:sql];
        
        if(CoreModelDeBug) {if(!insertRes) NSLog(@"错误：添加对象失败%@",coreModel);};
        if(CoreModelDeBug) NSLog(@"数据插入结束%@",[NSThread currentThread]);
        TriggerBlock(resBlock, insertRes)
    }];
}


+(void)insert:(id)model resBlock:(void(^)(BOOL res))resBlock newThread:(BOOL)newThread{
    
    if (newThread){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self insertAction:model resBlock:resBlock];
        });
    }else{
        [self insertAction:model resBlock:resBlock];
    }
}

+(void)insert:(id)model resBlock:(void(^)(BOOL res))resBlock{
    [self insert:model resBlock:resBlock newThread:YES];
}


+(void)inserts:(NSArray *)models resBlock:(void(^)(BOOL res))resBlock{
    
    if(![self checkTableExists]){
        
        if(CoreModelDeBug)NSLog(@"注意：批量数据插入时，你操作的模型%@在数据库中没有对应的数据表！%@",[self modelName],AutoMsg);
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(AutoTry * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self inserts:models resBlock:resBlock];
        });
        
        return;
    }
    
    if(CoreModelDeBug)NSLog(@"表创建成功，开始批量数据插入！");
    
    [self insertsActon:models resBlock:resBlock];

}

+(void)insertsActon:(NSArray *)models resBlock:(void(^)(BOOL res))resBlock{
    
    if(models == nil || models.count == 0){resBlock(NO);return;}
    
    if(![self checkTableExists]){
        
        if(CoreModelDeBug) NSLog(@"注意：单条数据插入时，你操作的模型%@在数据库中没有对应的数据表！%@",[self modelName],AutoMsg);
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(AutoTry * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self insertsActon:models resBlock:resBlock];
        });
        
        return;
    }
    
    NSOperationQueue *queue = [NSOperationQueue queue];
    
    if(CoreModelDeBug)NSLog(@"批量插入开始%@",[NSThread currentThread]);
    
    for (CoreModel *CoreModel in models) {
        
        NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
            [self insert:CoreModel resBlock:resBlock newThread:NO];ThreadShow(批量插入操作)
        }];
        
        [queue addOperation:operation];
    }
}

@end
