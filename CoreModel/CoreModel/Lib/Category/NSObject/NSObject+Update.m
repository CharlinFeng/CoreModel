//
//  NSObject+Update.m
//  CoreModel
//
//  Created by muxi on 15/3/30.
//  Copyright (c) 2015年 muxi. All rights reserved.
//

#import "NSObject+Update.h"
#import "NSObject+CoreModelCommon.h"
#import "CoreModel.h"
#import "CoreModelConst.h"
#import "CoreFMDB.h"
#import "NSArray+CoreModel.h"


@implementation NSObject (Update)


+(void)update:(id)model resBlock:(void(^)(BOOL res))resBlock{
    [self update:model resBlock:resBlock needThead:YES];
}

+(void)update:(id)model resBlock:(void(^)(BOOL res))resBlock needThead:(BOOL)needThead{
    
    if (needThead) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self updateAction:model resBlock:resBlock];
        });
    }else{
        [self updateAction:model resBlock:resBlock];
    }
}


+(void)updateAction:(id)model resBlock:(void(^)(BOOL res))resBlock{
    
    [self checkUsage:model];
    
    if(![self checkTableExists]){
        
        if(CoreModelDeBug) NSLog(@"错误：你操作的模型%@在数据库中没有对应的数据表！",[self modelName]);

        if(resBlock != nil) resBlock(NO);
        
        return;
    }
    
    if(![model isKindOfClass:[self class]]){
        if(CoreModelDeBug) NSLog(@"错误：插入数据请使用%@模型类对象，您使用的是%@类型",[self modelName],[model class]);
        if (resBlock != nil) resBlock(NO);
    }
    
    CoreModel *coreModel=(CoreModel *)model;
    
    [self find:coreModel.hostID selectResultBlock:^(id selectResult) {

        if(selectResult==nil) {if (resBlock != nil) resBlock(NO);return;};
        
        NSMutableString *keyValueString=[NSMutableString string];
        
        [self enumNSObjectProperties:^(CoreProperty *property, BOOL *stop) {
            
            BOOL skip=[self skipField:property];
            
            if(!skip){
                
                NSString *sqliteTye=[self sqliteType:property.code];
                
                id value =[model valueForKeyPath:property.name];
                
                if([property.typeString isEqualToString:CoreNSArray]){
                    
                    if([self isBasicTypeInNSArray:[self statementForNSArrayProperties][property.name]]){
                        sqliteTye = TEXT_TYPE;
                    }
                }
                
                if(![sqliteTye isEqualToString:EmptyString]){
                    
                    if([property.typeString isEqualToString:CoreNSString]){
                        
                        if(value == nil) value=@"";
                        
                        value=[NSString stringWithFormat:@"'%@'",value];
                    }else if ([property.typeString isEqualToString:CoreNSData]){
                        
                        if(value != nil) {
                            
                            value =[NSString stringWithFormat:@"'%@'",[(NSData *)value base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength]];
                        }else{
                            value = @"''";
                        }
                    }
                    
                    if([property.typeString isEqualToString:CoreNSArray]){
                        
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
                    
                    
                    [keyValueString appendFormat:@"%@=%@,",property.name,value];
                    
                }else{
                    
                    if(property.name!=nil && value!=nil){
                        
                        if(![property.typeString isEqualToString:CoreNSArray]){
                            
                            CoreModel *childModel=(CoreModel *)value;
                            
                            [childModel setValue:[self modelName] forKey:@"pModel"];
                            
                            [childModel setValue:@(coreModel.hostID) forKey:@"pid"];
                            
                            [NSClassFromString(property.code) update:childModel resBlock:^(BOOL res) {
                                if(CoreModelDeBug) {if(!res) NSLog(@"错误：级联保存数据失败！级联父类：%@，子属性为：%@",NSStringFromClass(CoreModel.class),value);};
                            }];
                            
                        }else{
                        
                            
                            NSArray *modelsArray = (NSArray *)value;
                            
                            [modelsArray enumerateObjectsUsingBlock:^(CoreModel *i, NSUInteger idx, BOOL *stop) {
                                [i setValue:NSStringFromClass([self class]) forKeyPath:@"pModel"];
                                [i setValue:@(coreModel.hostID) forKeyPath:@"pid"];
                            }];
                            
                            Class Cls = NSClassFromString([self statementForNSArrayProperties][property.name]);
                            
                            [Cls saveModels:modelsArray resBlock:resBlock];
                        }
                    
                    }
                }
            }
            
        }];
        
        NSString *keyValues_sub=[self deleteLastChar:keyValueString];
        
        NSString *sql=[NSString stringWithFormat:@"UPDATE %@ SET %@ WHERE hostID=%@;",[self modelName],keyValues_sub,@(coreModel.hostID)];
        
        BOOL updateRes = [CoreFMDB executeUpdate:sql];
        
        if(CoreModelDeBug) {if(!updateRes) NSLog(@"错误：数据更新出错，出错模型数据为：%@",model);};

        TriggerBlock(resBlock, updateRes)
        
    }];
}



+(void)updateModels:(NSArray *)models resBlock:(void(^)(BOOL res))resBlock{
    
    if(![self checkTableExists]){
        
        if(CoreModelDeBug) NSLog(@"注意：单条数据更新时，你操作的模型%@在数据库中没有对应的数据表！%@",[self modelName],AutoMsg);
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(AutoTry * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self updateModels:models resBlock:resBlock];
        });
        
        return;
    }

    if(models==nil || models.count==0) {if (resBlock != nil) resBlock(NO);};
    
    NSOperationQueue *queue = [NSOperationQueue queue];
    
    for (id obj in models) {
        NSBlockOperation *op = [NSBlockOperation blockOperationWithBlock:^{
            [self update:obj resBlock:resBlock needThead:NO];ThreadShow(更新数据)
        }];
        [queue addOperation:op];
    }
}



@end
