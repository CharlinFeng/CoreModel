//
//  UploadFile.h
//  Upload
//
//  Created by muxi on 15/2/11.
//  Copyright (c) 2015年 muxi. All rights reserved.
//  上传的文件

#import <Foundation/Foundation.h>

@interface UploadFile : NSObject

@property (nonatomic,strong) NSString *key;                                                 //文件上传对应的key，如果不传默认放入file[]

@property (nonatomic,copy) NSURL *url;                                                      //文件本地路径

@property (nonatomic,copy) NSString *name;                                                  //文件名

@property (nonatomic,copy) NSString *mimeType;                                              //文件类型

@property (nonatomic,assign) NSInteger size;                                                //文件大小（服务器自动获取）

@property (nonatomic,strong) NSData *data;                                                  //文件的二进制数据

@property (nonatomic,copy) NSString *tmp_name;                                              //临时文件名（服务器自动获取）

@property (nonatomic,copy) NSString *error;                                                 //文件错误信息（服务器自动获取）


/**
 *  文件：基于本地URL创建
 */
+(instancetype)fileWithKey:(NSString *)key url:(NSURL *)url;



/**
 *  自动获取mimeType
 *
 *  @param key  key:服务器对应的key
 *  @param data 图片二进制数据
 *  @param name 图片名称
 *
 *  @return 实例
 */
+(instancetype)fileWithKey:(NSString *)key data:(NSData *)data name:(NSString *)name;




/**
 *  如果自动处理mimeType出错，建议使用此方法，一般不使用此方法
 */
+(instancetype)fileWithKey:(NSString *)key data:(NSData *)data mimeType:(NSString *)mimeType name:(NSString *)name NS_DEPRECATED_IOS(2_0, 6_0, "Charlin提示您：请使用fileWithKey:data:name:");



@end
