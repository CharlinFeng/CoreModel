//
//  NSString+CoreHttp.h
//  CoreHttp
//
//  Created by muxi on 15/3/2.
//  Copyright (c) 2015年 muxi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (CoreHttp)

/**
 *  处理json格式的字符串中的换行符、回车符
 */
-(NSString *)deleteSpecialCode;


@end
