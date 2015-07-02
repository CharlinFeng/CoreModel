//
//  NSObject+Save.m
//  BaseModel
//
//  Created by muxi on 15/3/30.
//  Copyright (c) 2015年 muxi. All rights reserved.
//

#import "NSObject+Save.h"
#import "BaseModel.h"
#import "NSObject+Select.h"
#import "NSObject+BaseModelCommon.h"
#import "NSObject+Insert.h"
#import "NSObject+Update.h"

@implementation NSObject (Save)

/**
 *  保存数据（单个）
 *
 *  @param model 模型数据
 *
 *  @return 执行结果
 */
+(BOOL)save:(id)model{
    
    //检查表是否存在，如果不存在，直接返回
    if(![self checkTableExists]){
        NSLog(@"错误：你操作的模型%@在数据库中没有对应的数据表！",[self modelName]);
        return NO;
    }
    
    if(![NSThread isMainThread]){
        NSLog(@"错误：为了数据安全，数据更新API必须在主线程中执行！");
        return NO;
    }
    
    if(![model isKindOfClass:[self class]]){
        NSLog(@"错误：插入数据请使用%@模型类对象，您使用的是%@类型",[self modelName],[model class]);
        return NO;
    }
    
    BaseModel *baseModel = (BaseModel *)model;
    
    BaseModel *dbModel=[self find:baseModel.hostID];
    
    BOOL saveRes=NO;
    
    if(dbModel==nil){//要保存的数据不存在，执行添加操作
        NSLog(@"现在是新增");
        saveRes = [self insert:baseModel];
        
    }else{//要保存的数据存在，执行更新操作
        NSLog(@"现在是更新");
        saveRes = [self update:baseModel];
        
    }
    
    return saveRes;
}



/**
 *  保存数据（数组）
 *
 *  @param models 模型数组
 *
 *  @return 执行结果
 */
+(BOOL)saveModels:(NSArray *)models{
    
    if(models==nil || models.count==0) return NO;
    
    __block BOOL saveRes = YES;
    
    [models enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        BOOL res = [self save:obj];
        
        if(res == NO){ saveRes = NO; *stop = YES; }
    }];
    
    return saveRes;
}




/**
 *  保存数据：自动判断是单个还是数组
 *
 *  @param obj 数据
 *
 *  @return 执行结果
 */
+(BOOL)saveDirect:(id)obj{
    
    return [obj isKindOfClass:[NSArray class]]?[self saveModels:obj]:[self save:obj];
}


@end
