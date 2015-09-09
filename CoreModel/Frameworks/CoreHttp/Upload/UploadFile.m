//
//  UploadFile.m
//  Upload
//
//  Created by muxi on 15/2/11.
//  Copyright (c) 2015年 muxi. All rights reserved.
//

#import "UploadFile.h"
#import "NSURL+File.h"
#import "NSString+File.h"
#import "NSData+MimeType.h"

@implementation UploadFile


/**
 *  文件：通过url创建
 */
+(instancetype)fileWithKey:(NSString *)key url:(NSURL *)url{
    
    UploadFile *file=[[UploadFile alloc] init];
    
    if(url==nil){
        NSLog(@"初始化文件时传入了一个空的本地URL资源地址，请检查！");
        return file;
    }
    
    //key
    file.key=key;
    
    //保存路径
    file.url=url;
    
    //获取文件名
    file.name=[url.absoluteString lastPathComponent];
    
    //获取mimeType
    file.mimeType=[url mimeType];
    
    //获取data
    file.data=[url dataForFileResource];
    
    return file;
}



/**
 *  自动获取mimeType
 *
 *  @param key  key:服务器对应的key
 *  @param data 图片二进制数据
 *  @param name 图片名称
 *
 *  @return 实例
 */
+(instancetype)fileWithKey:(NSString *)key data:(NSData *)data name:(NSString *)name{
    
    UploadFile *file=[[UploadFile alloc] init];
    
    //key
    file.key=key;
    
    //data
    file.data=data;
    
    //name
    file.name=name;
    
    //mimeType
    file.mimeType=data.mimeType;
 
    return file;
}


/**
 *  如果自动处理mimeType出错，可尝试使用此方法，一般不使用此方法
 */
+(instancetype)fileWithKey:(NSString *)key data:(NSData *)data mimeType:(NSString *)mimeType name:(NSString *)name{

    UploadFile *file=[self fileWithKey:key data:data name:name];
    
    //mimeType
    file.mimeType=mimeType;
    
    return file;
}

-(NSString *)description{
    return [NSString stringWithFormat:@"key=%@,name=%@,mimeType=%@",self.key,self.name,self.mimeType];
}

-(NSString *)key{
    
    if(_key==nil){
        
        _key=@"file[]";
    }
    
    return _key;
}

@end
