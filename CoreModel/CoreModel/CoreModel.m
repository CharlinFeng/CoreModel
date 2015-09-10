//
//  CoreModel.m
//  4s
//
//  Created by muxi on 15/3/11.
//  Copyright (c) 2015年 muxi. All rights reserved.
//

#import "CoreModel.h"
#import "NSObject+Create.h"


@implementation CoreModel


+(void)initialize{
    
    //自动创表
    [self tableCreate];
}


+(NSDictionary *)replacedKeyFromPropertyName{
    return @{@"hostID":@"id"};
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




@end
