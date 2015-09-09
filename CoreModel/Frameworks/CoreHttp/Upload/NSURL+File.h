//
//  NSURL+File.h
//  Upload
//
//  Created by muxi on 15/2/12.
//  Copyright (c) 2015年 muxi. All rights reserved.
//  本地文件资源转Data操作

#import <Foundation/Foundation.h>

@interface NSURL (File)


/**
 *  获取指定path的文件的mimeType
 */
-(NSString *)mimeType;


/**
 *  获取指定path的文件的data
 */
-(NSData *)dataForFileResource;


@end
