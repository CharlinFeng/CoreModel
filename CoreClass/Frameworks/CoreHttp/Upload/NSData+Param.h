//
//  NSData+Param.h
//  Upload
//
//  Created by muxi on 15/2/12.
//  Copyright (c) 2015年 muxi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (Param)




/**
 *  文件参数
 *
 *  @param files 文件参数对象数组
 *
 *  @return data
 */
+(NSData *)uploadParameterForFiles:(NSArray *)files;




/**
 *  普通参数对象：一个键值对就是一个UploadParameter对象
 *
 *  @param normalParams 普通参数字典
 *
 *  @return data
 */
+(NSData *)uploadParameterForNormalParams:(NSDictionary *)normalParams;




/**
 *  结束参数对象
 */
+(NSData *)uploadParameterForEnd;




/**
 *  返回boundary
 */
+(NSString *)boundary;



@end
