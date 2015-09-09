//
//  CoreModel.m
//  4s
//
//  Created by muxi on 15/3/11.
//  Copyright (c) 2015年 muxi. All rights reserved.
//

#import "CoreModel.h"
#import "NSObject+MJProperty.h"
#import "MJProperty.h"
#import "MJType.h"
#import "CoreModelConst.h"
#import "CoreFMDB.h"
#import "NSObject+Create.h"
#import "CoreHttp.h"
#import "NSObject+MJKeyValue.h"
#import "NSDictionary+Sqlite.h"
#import "NSObject+CoreModelCommon.h"
#import "NSObject+Contrast.h"

static NSString * const HTTP_REQUEST_ERROR_MSG = @"请稍等重试";

@implementation CoreModel


+(void)initialize{
    
    //自动创表
    [self tableCreate];
}


+(NSDictionary *)replacedKeyFromPropertyName{
    return @{@"hostID":@"id"};
}


/** 读取 */
/** 目前是不考虑上拉下拉刷新 */
/** 不论是本地查询还是网络请求，均是延时操作，返回block均在子线程中 */
+(void)selectWithParams:(NSDictionary *)params userInfo:(NSDictionary *)userInfo beginBlock:(void(^)(BOOL isNetWorkRequest,BOOL needHUD))beginBlock successBlock:(void(^)(NSArray *models,CoreModelDataSourceType sourceType,NSDictionary *userInfo))successBlock errorBlock:(void(^)(NSString *errorResult,NSDictionary *userInfo))errorBlock{
    
    //首页判断是否需要本地缓存
    BOOL needFMDB = [self CoreModel_NeedFMDB];
    
    if(!needFMDB){//不需要本地缓存，直接请求网络
        
        //开始
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if(beginBlock != nil) beginBlock(YES,YES);
        });
        
        //请求URL
        NSString *url = [self CoreModel_UrlString];
        
        //请求参数
        NSDictionary *requestParams = params;
        
        //请求方式
        CoreModelHttpType httpType = [self CoreModel_HttpType];
        
        //开始请求
        if(CoreModelHttpTypeGET == httpType){//GET请求
            
            [CoreHttp getUrl:url params:requestParams success:^(id obj) {
                
                //不做本地缓存的网络请求GET/POST成功统一处理
                [self hostWithouSqliteRequestHandleData:obj userInfo:userInfo successBlock:successBlock errorBlock:errorBlock];
                
            } errorBlock:^(CoreHttpErrorType errorType) {
                
                //错误处理
                if(errorBlock != nil) errorBlock(HTTP_REQUEST_ERROR_MSG,userInfo);
            }];
            
        }else{//POST请求
            
            [CoreHttp postUrl:url params:requestParams success:^(id obj) {
                
                //不做本地缓存的网络请求GET/POST成功统一处理
                [self hostWithouSqliteRequestHandleData:obj userInfo:userInfo successBlock:successBlock errorBlock:errorBlock];
                
            } errorBlock:^(CoreHttpErrorType errorType) {
                
                //错误处理
                if(errorBlock != nil) errorBlock(HTTP_REQUEST_ERROR_MSG,userInfo);
            }];
        }
        
        
    }else{//需要本地缓存
        
        //archiverTimeKey：考虑分页
        BOOL isPageEnable = [self CoreModel_isPageEnable];
        
        //where需要区分是单数还是分页
        //单页数据情况下，直接转为sqlWhere
        //分页情况下，请求参数中含有page与pagesize信息，需要从sqlWhere中剔除，并转换为limit数据
        //请求参数
        NSString *where = nil;
        NSString *limit = nil;
        NSString *orderBy = nil;
        NSUInteger page = 0;
    
        //处理where
        if(isPageEnable){//分页
            
            //获取PageKey
            NSString *pageKey = [self CoreModel_PageKey];
            //获取PageSizeKey
            NSString *pagesizeKey = [self CoreModel_PageSizeKey];
            
            //记录page
            page = [[params objectForKey:pageKey] integerValue];
 
            //获取pagesize
            NSUInteger pagesize = [self CoreModel_PageSize];
            
            NSMutableDictionary *tempDictM = [NSMutableDictionary dictionaryWithDictionary:params];
            
            //移除page这个key
            [tempDictM removeObjectForKey:pageKey];
            //移除pagesize这个key
            [tempDictM removeObjectForKey:pagesizeKey];
            
            where = tempDictM.sqlWhere;
            
            //计算order信息
            orderBy = @"hostID desc";
            
            //limit：页码修正
            NSUInteger startPage = [self CoreModel_StartPage];
            
            //计算limit信息
            limit = [NSString stringWithFormat:@"%@,%@",@((page - startPage) * pagesize),@(pagesize)];
            
        }else{
            
            where = params.sqlWhere;
        }
        
        //开始回调：从数据库读取
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if(beginBlock != nil) beginBlock(NO,NO);
        });
        
        //从数据库读取
        [self selectWhere:where groupBy:nil orderBy:orderBy limit:limit selectResultsBlock:^(NSArray *model_sqlite_Array) {
            
            //直接执行成功回调
            if(successBlock != nil) successBlock(model_sqlite_Array,CoreModelDataSourceTypeSqlite,userInfo);
            
            
            //看情况决定是否执行网络请求，以下两种情况不需要执行网络请求
            //1.不需要本地缓存：这个本身就不成立，因为此时正在处理需要缓存处理的情况
            //2.还没到缓存周期
            
            //archiverTimeKey：不考虑分页
            NSString *archiverTimeKey = [self modelName];
            
            if(isPageEnable){
                
                archiverTimeKey = [NSString stringWithFormat:@"%@%@",archiverTimeKey,@(page)];
            }
            
            //读取上次请求时间
            NSTimeInterval lastRequestTime = [[NSUserDefaults standardUserDefaults] doubleForKey:archiverTimeKey];
            
            NSTimeInterval nowTime = [NSDate date].timeIntervalSince1970;
            
            BOOL needHUD = lastRequestTime <=0 || (lastRequestTime>0 && model_sqlite_Array.count == 0);
            
            
            
            BOOL needHttpRequest = nowTime - lastRequestTime >= [self CoreModel_Duration];
            
            if(!needHttpRequest) return;
            
            //请求URL
            NSString *url = [self CoreModel_UrlString];
            
            //请求参数
            NSDictionary *requestParams = params;
            
            //请求方式
            CoreModelHttpType httpType = [self CoreModel_HttpType];
            
            //开始回调：从数据库读取
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if(beginBlock != nil) beginBlock(YES,needHUD);
            });
            
            //开始请求
            if(CoreModelHttpTypeGET == httpType){//GET请求
                
                [CoreHttp getUrl:url params:requestParams success:^(id obj) {
                    
                    //需要本地数据库缓存的情况下统一处理GET/POST返回的数据
                    [self sqliteNeedHandleHttpDataObj:obj userInfo:userInfo successBlock:successBlock errorBlock:errorBlock model_sqlite_Array:model_sqlite_Array nowTime:nowTime archiverTimeKey:archiverTimeKey];
                    
                } errorBlock:^(CoreHttpErrorType errorType) {
                    
                    //错误处理
                    if(errorBlock != nil) errorBlock(HTTP_REQUEST_ERROR_MSG,userInfo);
                }];
                
            }else{//POST请求
                
                [CoreHttp postUrl:url params:requestParams success:^(id obj) {
                    
                    //需要本地数据库缓存的情况下统一处理GET/POST返回的数据
                    [self sqliteNeedHandleHttpDataObj:obj userInfo:userInfo successBlock:successBlock errorBlock:errorBlock model_sqlite_Array:model_sqlite_Array nowTime:nowTime archiverTimeKey:archiverTimeKey];
                    
                } errorBlock:^(CoreHttpErrorType errorType) {
                    
                    //错误处理
                    if(errorBlock != nil) errorBlock(HTTP_REQUEST_ERROR_MSG,userInfo);
                }];
            }

        }];

    }
}









/** 需要本地数据库缓存的情况下统一处理GET/POST返回的数据 */
+(void)sqliteNeedHandleHttpDataObj:(id)obj userInfo:(NSDictionary *)userInfo successBlock:(void(^)(id modelData,CoreModelDataSourceType sourceType,NSDictionary *userInfo))successBlock errorBlock:(void(^)(NSString *errorResult,NSDictionary *userInfo))errorBlock model_sqlite_Array:(NSArray *)model_sqlite_Array nowTime:(NSTimeInterval)nowTime archiverTimeKey:(NSString *)archiverTimeKey{
    
    //错误数据解析
    NSString *errorResult = [self CoreModel_parseErrorData:obj];
    
    if(errorResult != nil){ if(errorBlock != nil) errorBlock(errorResult,userInfo); return;}
    
    //服务器返回数据GET/POST统一处理(已经经过所有错误处理)
    id modelData = [self hostDataHandle:obj];
    
    //服务器返回数据，我们需要和刚刚的数据库数据进行对比
    //网络数据和服务器数据对比
    BOOL isTheSame = [self contrastWithHostModelData:modelData sqliteModelData:model_sqlite_Array];

    
    //相同即返回
    if(isTheSame) return;
    if(CoreModelDeBug) NSLog(@"写入数据库");
    //不相同
    //执行回调
    
    CoreModelDataSourceType sourceType = CoreModelDataSourceHostType_Sqlite_Deprecated;
    
    if(model_sqlite_Array == nil || model_sqlite_Array.count ==0){ // 本地无数据，服务器请求有数据
        sourceType = CoreModelDataSourceHostType_Sqlite_Nil;
    }
    
    if(successBlock !=nil ) successBlock(modelData,sourceType,userInfo);
    
        //存入数据库
    [self saveDirect:modelData resBlock:nil];

    //保存时间
    [[NSUserDefaults standardUserDefaults] setDouble:nowTime forKey:archiverTimeKey];

}


/** 不做本地缓存的网络请求GET/POST成功统一处理 */
+(void)hostWithouSqliteRequestHandleData:(id)obj userInfo:(NSDictionary *)userInfo successBlock:(void(^)(id modelData,CoreModelDataSourceType sourceType,NSDictionary *userInfo))successBlock errorBlock:(void(^)(NSString *errorResult,NSDictionary *userInfo))errorBlock{
    
    //错误数据解析
    NSString *errorResult = [self CoreModel_parseErrorData:obj];
    
    if(errorResult != nil){ if(errorBlock != nil) errorBlock(errorResult,userInfo); return;}
    
    //服务器返回数据GET/POST统一处理(已经经过所有错误处理)
    id modelData = [self hostDataHandle:obj];
    
    //成功回调
    if(successBlock !=nil ) successBlock(modelData,CoreModelDataSourceHostType_Sqlite_Nil,userInfo);
}




/** 网络数据和服务器数据对比 */
+(BOOL)contrastWithHostModelData:(id)hostModelData sqliteModelData:(id)sqliteModelData{
   
    BOOL isTheSame = NO;
    
    //这个数据是从结果集出来的，是一个数组
    NSArray *sqliteModelDataArray = (NSArray *)sqliteModelData;
    
    //数据类型
    CoreModelHostDataType dataType = [self CoreModel_hostDataType];
    
    //两个都有值才进行对比，否则为不一样
    if(hostModelData != nil && (sqliteModelDataArray.count !=0)){
        
        if(CoreModelHostDataTypeModelSingle == dataType){//模型：单个
            
            //取出数据库模型对象
            CoreModel *sqliteModelSing = sqliteModelDataArray.firstObject;
            
            isTheSame = [self contrastModel1:hostModelData model2:sqliteModelSing];
            
        }else if (CoreModelHostDataTypeModelArray == dataType){//模型：数组
            
            isTheSame = [self contrastModels1:hostModelData models2:sqliteModelDataArray];
        }
    }
    
    if(isTheSame){
        if(CoreModelDeBug) NSLog(@"相同");
    }else{
        if(CoreModelDeBug) NSLog(@"不同");
    }
    
    ThreadShow(模型字段检查)
    
    return isTheSame;
}






/** 服务器返回数据GET/POST统一处理(已经经过所有错误处理) */
+(id)hostDataHandle:(id)obj{
    
    //字典转模型数据
    //使用id是因为可能是单个模型，也可能是模型数组
    id modelData = nil;
    
    //数组解析
    //userfullHostData：是真正本模型需要的数据体，还没有经历字典转模型
    id userfullHostData = [self CoreModel_findUsefullData:obj];
    
    //数据类型
    CoreModelHostDataType dataType = [self CoreModel_hostDataType];
    
    if(CoreModelHostDataTypeModelSingle == dataType){//模型：单个
        
        //字典转模型：泛型
        CoreModel *CoreModel = [self objectWithKeyValues:userfullHostData];
        
        //得到模型：单个
        modelData = @[CoreModel];
        
    }else if (CoreModelHostDataTypeModelArray == dataType){//模型：数组
        
        //字典转模型：泛型
        NSArray *CoreModelArray = [self objectArrayWithKeyValuesArray:userfullHostData];
        
        //得到模型：数组
        modelData = CoreModelArray;
    }
    
    return modelData;
}





/** 模型对比时需要忽略的字段 */
+(NSArray *)constrastIgnorFields{
    return @[@"pModel",@"pid"];
}







/*
 *  协议方法区
 */


/** 普通模型代理方法区 */

/** 接口地址 */
+(NSString *)CoreModel_UrlString{
    return nil;
}

/** 请求方式 */
+(CoreModelHttpType)CoreModel_HttpType{
    return CoreModelHttpTypeGET;
}

/** 是否需要本地缓存 */
+(BOOL)CoreModel_NeedFMDB{
    return NO;
}

/** 缓存周期：单位秒 */
+(NSTimeInterval)CoreModel_Duration{
    return 10;
}

/**
 *  错误数据解析：请求成功，但服务器返回的接口状态码抛出错误
 *
 *  @param hostData 服务器数据
 *
 *  @return 如果为nil，表示无错误；如果不为空表示有错误，并且为错误信息。
 */
+(NSString *)CoreModel_parseErrorData:(id)hostData{
    return nil;
}

/** 服务器真正有用数据体：此时只是找到对应的key，还没有字典转模型 */
+(id)CoreModel_findUsefullData:(id)hostData{
    return nil;
}

/** 返回数据格式 */
+(CoreModelHostDataType)CoreModel_hostDataType{
    return CoreModelHostDataTypeModelSingle;
}




/** 分页模型代理方法区 */


/**
 *  是否为分页数据
 *
 *  @return 如果为分页模型请返回YES，否则返回NO
 */
+(BOOL)CoreModel_isPageEnable{
    return NO;
}


/** page字段 */
+(NSString *)CoreModel_PageKey{
    return @"page";
}


/** pagesize字段 */
+(NSString *)CoreModel_PageSizeKey{
    return @"pagesize";
}


/** 页码起点 */
+(NSUInteger)CoreModel_StartPage{
    return 1;
}


/** 每页数据量 */
+(NSUInteger)CoreModel_PageSize{
    return 20;
}


@end
