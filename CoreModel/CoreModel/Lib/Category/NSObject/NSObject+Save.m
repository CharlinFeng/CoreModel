//
//  NSObject+Save.m
//  CoreModel
//
//  Created by muxi on 15/3/30.
//  Copyright (c) 2015年 muxi. All rights reserved.
//

#import "NSObject+Save.h"
#import "CoreModel.h"
#import "NSObject+Select.h"
#import "NSObject+CoreModelCommon.h"
#import "NSObject+Insert.h"
#import "NSObject+Update.h"
#import "CoreModelConst.h"

@implementation NSObject (Save)

+(void)save:(id)model resBlock:(void(^)(BOOL res))resBlock{
    [self save:model resBlock:resBlock needThread:YES];
}

+(void)save:(id)model resBlock:(void(^)(BOOL res))resBlock needThread:(BOOL)needThread{
    if (needThread) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self saveAction:model resBlock:resBlock];
        });
    }else{
        [self saveAction:model resBlock:resBlock];
    }
}

+(void)saveAction:(id)model resBlock:(void(^)(BOOL res))resBlock{
    
    [self checkUsage:model];
    
    if(![self checkTableExists]){
        if(CoreModelDeBug) NSLog(@"注意：你操作的模型%@在数据库中没有对应的数据表，%@",[self modelName],AutoMsg);
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(AutoTry * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self saveAction:model resBlock:resBlock];
        });
        
        return;
    }
    
    if(![model isKindOfClass:[self class]]){
        if(CoreModelDeBug) NSLog(@"错误：插入数据请使用%@模型类对象，您使用的是%@类型",[self modelName],[model class]);
        resBlock(NO);return;
    }
    
    CoreModel *coreModel = (CoreModel *)model;
    
    [self find:coreModel.hostID selectResultBlock:^(id selectResult) {
        
        if(selectResult==nil){
            if(CoreModelDeBug)NSLog(@"现在是新增");
            [self insert:coreModel resBlock:resBlock];
            
        }else{
            if(CoreModelDeBug)NSLog(@"现在是更新");
            [self update:coreModel resBlock:resBlock];
        }
    }];
}



+(void)saveModels:(NSArray *)models resBlock:(void(^)(BOOL res))resBlock{

    if(![self checkTableExists]){
        
        if(CoreModelDeBug) NSLog(@"注意：单条数据保存时，你操作的模型%@在数据库中没有对应的数据表！%@",[self modelName],AutoMsg);
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(AutoTry * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self saveModels:models resBlock:resBlock];
        });
        
        return;
    }
    
    
    if(models==nil || models.count==0) {if (resBlock !=nil) resBlock(NO);return;};
    
    NSOperationQueue *queue = [NSOperationQueue queue];

    [models enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        NSBlockOperation *op = [NSBlockOperation blockOperationWithBlock:^{
            [self save:obj resBlock:resBlock needThread:NO];
            ThreadShow("批量保存")
        }];
        [queue addOperation:op];
    }];
}



+(void)saveDirect:(id)obj resBlock:(void(^)(BOOL res))resBlock{
    
    return [obj isKindOfClass:[NSArray class]]?[self saveModels:obj resBlock:resBlock]:[self save:obj resBlock:resBlock];
}


@end
