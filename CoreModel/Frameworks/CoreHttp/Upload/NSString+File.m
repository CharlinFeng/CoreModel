//
//  NSString+File.m
//  Upload
//
//  Created by muxi on 15/2/12.
//  Copyright (c) 2015年 muxi. All rights reserved.
//

#import "NSString+File.h"

@implementation NSString (File)

-(NSData *)strData{
    
    NSRange range = [self rangeOfString:@"file://"];
    
    if(range.length!=0){
        
        NSLog(@"请注意：您可能是想要获取本地文件(%@)数据,而不是将此URL地址直接转为对应的NSData。",self);
    }
    
    return [self dataUsingEncoding:NSUTF8StringEncoding];
}



@end
