//
//  ToolConnection.h
//
//  Created by muxi on 14/10/22.
//  Copyright (c) 2014年 muxi. All rights reserved.
//  全新的网络请求工具类：2.0版本（更新于2015.01.28）

#import <Foundation/Foundation.h>
#import "UploadFile.h"

typedef enum{
    
    //请求正常，无错误
    CoreHttpErrorTypeNull=0,
    
    //请求时出错，可能是URL不正确
    CoreHttpErrorTypeURLConnectionError,
    
    //请求时出错，服务器未返回正常的状态码：200
    CoreHttpErrorTypeStatusCodeError,
    
    //请求回的Data在解析前就是nil，导致请求无效，无法后续JSON反序列化。
    CoreHttpErrorTypeDataNilError,
    
    //data在JSON反序列化时出错
    CoreHttpErrorTypeDataSerializationError,
    
    //无网络连接
    CoreHttpErrorTypeNoNetWork,
    
    //服务器请求成功，但抛出错误
    CoreHttpErrorTypeServiceRetrunErrorStatus,
    
    /**
     *  以下是文件上传中的错误类型
     */
    CoreHttpErrorTypeUploadDataNil,                                                                     //什么都没有上传
    
    
}CoreHttpErrorType;                                                                                     //错误类型定义





typedef void(^SuccessBlock)(id obj);

typedef void(^ErrorBlock)(CoreHttpErrorType errorType);



@interface CoreHttp : NSObject


/**
 *  GET:
 *  params中可指明参数类型
 */
+(void)getUrl:(NSString *)urlString params:(NSDictionary *)params success:(SuccessBlock)successBlock errorBlock:(ErrorBlock)errorBlock;


/**
 *  POST:
 */
+(void)postUrl:(NSString *)urlString params:(NSDictionary *)params success:(SuccessBlock)successBlock errorBlock:(ErrorBlock)errorBlock;



/**
 *  文件上传
 *  @params: 普通参数
 *  @files : 文件数据，里面装的都是UploadFile对象
 */
+(void)uploadUrl:(NSString *)uploadUrl params:(NSDictionary *)params files:(NSArray *)files success:(SuccessBlock)successBlock errorBlock:(ErrorBlock)errorBlock;



@end
