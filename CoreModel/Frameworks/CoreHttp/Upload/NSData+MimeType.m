//
//  NSData+MimeType.m
//  CoreHttp
//
//  Created by muxi on 15/3/2.
//  Copyright (c) 2015年 muxi. All rights reserved.
//

#import "NSData+MimeType.h"

@implementation NSData (MimeType)


-(NSString *)mimeType{
    
    uint8_t c;
    
    [self getBytes:&c length:1];
    
    NSString *mimeType=nil;
    
    switch (c) {
        case 0xFF:
            mimeType = @"image/jpeg";
            break;
        case 0x89:
            mimeType = @"image/png";
            break;
        case 0x47:
            mimeType = @"image/gif";
            break;
        case 0x49:
        case 0x4D:
            mimeType = @"image/tiff";
            break;
    }
    
    if(mimeType==nil){
        mimeType=@"image/jpeg";
        NSLog(@"Warnning:请注意，根据NSData获取图片的MimeType的时候出现错误：没有获取到值，框架默认‘image/jpeg’替换！");
    }
    
    return mimeType;
}



@end
