//
//  NSURL+File.m
//  Upload
//
//  Created by muxi on 15/2/12.
//  Copyright (c) 2015年 muxi. All rights reserved.
//

#import "NSURL+File.h"

@implementation NSURL (File)

/**
 *  获取指定文件的mimeType
 */
-(NSString *)mimeType{
    
    NSURLRequest *request=[NSURLRequest requestWithURL:self];
    
    NSURLResponse *response=nil;
    
    NSError *error=nil;
    
    //使用同步请求，访问本地文件
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    if(error!=nil){
        NSLog(@"获取指定文件的mimeType时出错，出错信息：%@出错文件：%@",error.localizedDescription,self);
        return nil;
    }
    
    NSString *mimeType=response.MIMEType;
    
    if(mimeType==nil || mimeType.length==0){
        NSLog(@"获取指定文件的mimeType时为空：%@出错文件：%@",mimeType,self);
        return nil;
    }
    
    return mimeType;
}




/**
 *  获取指定path的文件的data
 */
-(NSData *)dataForFileResource{
    
    NSURLRequest *request=[NSURLRequest requestWithURL:self];
    
    NSURLResponse *response=nil;
    
    NSError *error=nil;
    
    //使用同步请求，访问本地文件
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    if(error!=nil){
        NSLog(@"获取指定文件的data数据时出错，出错信息：%@出错文件：%@",error.localizedDescription,self);
        return nil;
    }
    
    if(data==nil || data.length==0){
        NSLog(@"获取指定文件的data数据为空，出错文件：%@",self);
        return nil;
    }
    
    return data;
}



@end
