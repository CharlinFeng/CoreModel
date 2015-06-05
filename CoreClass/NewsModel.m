//
//  NewsModel.m
//  CoreClass
//
//  Created by 冯成林 on 15/6/5.
//  Copyright (c) 2015年 muxi. All rights reserved.
//

#import "NewsModel.h"

@implementation NewsModel


/*
 *  协议方法区
 */


/** 接口地址 */
+(NSString *)baseModel_UrlString{
    return @"http://211.149.151.92/Carpenter/tp/index.php/Info/testdata";
}

/** 请求方式 */
+(BaseModelHttpType)baseModel_HttpType{
    return BaseModelHttpTypeGET;
}

/** 是否需要本地缓存 */
+(BOOL)baseModel_NeedFMDB{
    return YES;
}

/** 缓存周期：单位秒 */
+(NSTimeInterval)baseModel_Duration{
    return 100;
}

/**
 *  错误数据解析：请求成功，但服务器返回的接口状态码抛出错误
 *
 *  @param hostData 服务器数据
 *
 *  @return 如果为nil，表示无错误；如果不为空表示有错误，并且为错误信息。
 */
+(NSString *)baseModel_parseErrorData:(id)hostData{
    
    NSString *errorResult = nil;
    
    if([hostData[@"status"] integerValue] != 100) errorResult = hostData[@"msg"];
    
    return errorResult;
}

/** 服务器真正有用数据体：此时只是找到对应的key，还没有字典转模型 */
+(id)baseModel_findUsefullData:(id)hostData{
    return hostData[@"data"];
}

/** 返回数据格式 */
+(BaseModelHostDataType)baseModel_hostDataType{
    return BaseModelHostDataTypeModelArray;
}

/**
 *  是否为分页数据
 *
 *  @return 如果为分页模型请返回YES，否则返回NO
 */
+(BOOL)baseModel_isPageEnable{
    return YES;
}


/** page字段 */
+(NSString *)baseModel_PageKey{
    return @"p";
}


/** pagesize字段 */
+(NSString *)baseModel_PageSizeKey{
    return @"pagesize";
}


/** 页码起点 */
+(NSUInteger)baseModel_StartPage{
    return 1;
}


/** 每页数据量 */
+(NSUInteger)baseModel_PageSize{
    return 20;
}


@end
