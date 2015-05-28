//
//  NSString+CoreHttp.m
//  CoreHttp
//
//  Created by muxi on 15/3/2.
//  Copyright (c) 2015年 muxi. All rights reserved.
//

#import "NSString+CoreHttp.h"

@implementation NSString (CoreHttp)



/**
 *  处理json格式的字符串中的换行符、回车符
 */
-(NSString *)deleteSpecialCode {
    
    NSString *string = [self stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    
    string = [string stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    string = [string stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    string = [string stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    
    return string;
}

@end
