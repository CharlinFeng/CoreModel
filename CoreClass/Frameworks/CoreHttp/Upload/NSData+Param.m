//
//  NSData+Param.m
//  Upload
//
//  Created by muxi on 15/2/12.
//  Copyright (c) 2015年 muxi. All rights reserved.
//

#import "NSData+Param.h"
#import "UploadFile.h"
#import "NSString+File.h"

NSString *const symbol=@"--";                                               //symbol

NSString *const boundary=@"boundary";                                       //boundary

NSString *const lineBreak=@"\r\n";                                          //lineBreak

@implementation NSData (Param)


/**
 *  开始参数
 */
+(NSData *)uploadParameterForBegin{
    
    NSData *symbolData=symbol.strData;
    
    NSData *boundaryData=boundary.strData;
    
    NSData *lineBreakData=lineBreak.strData;
    
    NSMutableData *beginDataM=[NSMutableData data];
    
    //symbol
    [beginDataM appendData:symbolData];
    
    //boundary
    [beginDataM appendData:boundaryData];
    
    //lineBreak
    [beginDataM appendData:lineBreakData];

    return beginDataM;
}





/**
 *  文件参数
 *
 *  @param files 文件参数对象数组
 *
 *  @return data
 */
+(NSData *)uploadParameterForFiles:(NSArray *)files{
    
    if(files==nil || files.count==0){
        
        NSLog(@"上传文件的文件列表为空，请检查！");
        return nil;
    }
    
    NSData *lineBreakData=lineBreak.strData;
    
    //创建对象
    NSMutableData *uploadFileDataM=[NSMutableData data];
    
    //拼接文件参数数据
    for (NSInteger i=0; i<files.count; i++) {
        
        UploadFile *file =files[i];
        NSLog(@"file:%@",file);
        if(![file isKindOfClass:[UploadFile class]]){
            NSLog(@"Warnning:上传文件列表数组里面装的不是UploadFile类实例，您放的是%@类实例",NSStringFromClass(file.class));
            break;
        }
        
        if(file.key==nil || file.name==nil || file.mimeType==nil || file.data==nil){
            NSLog(@"Warnning:上传文件列表数据第%@个文件信息不完整,文件信息为:%@!",@(i),file);
        }
        
        //添加开头符号
        [uploadFileDataM appendData:[self uploadParameterForBegin]];
        
        //内容区
        [uploadFileDataM appendData:[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"",file.key,file.name].strData];
        //换行
        [uploadFileDataM appendData:lineBreakData];
        
        //mimeType
        [uploadFileDataM appendData:[NSString stringWithFormat:@"Content-Type: %@", file.mimeType].strData];
        //换行
        [uploadFileDataM appendData:lineBreakData];
        
        //换行
        [uploadFileDataM appendData:lineBreakData];
        //值：二进制数据
        [uploadFileDataM appendData:file.data];
        //换行
        [uploadFileDataM appendData:lineBreakData];
    }
    
    return uploadFileDataM;
}



/**
 *  普通参数对象：一个键值对就是一个UploadParameter对象
 *
 *  @param normalParams 普通参数字典
 *
 *  @return data
 */
+(NSData *)uploadParameterForNormalParams:(NSDictionary *)normalParams{
    
    if(normalParams==nil || normalParams.count==0){
        
        NSLog(@"上传文件普通参数为空，请检查！");
        return nil;
    }
    
    NSData *lineBreakData=lineBreak.strData;
    
    //创建对象
    NSMutableData *normalParamDataM=[NSMutableData data];
    
    //拼接普通参数数据
    [normalParams enumerateKeysAndObjectsUsingBlock:^(NSString *key, id obj, BOOL *stop) {
        
        //添加开头符号
        [normalParamDataM appendData:[self uploadParameterForBegin]];
        
        //内容区
        [normalParamDataM appendData:[NSString stringWithFormat:@"Content-Disposition: application/octet-stream; name=\"%@\"",key].strData];
        //换行
        [normalParamDataM appendData:lineBreakData];
        
        //换行
        [normalParamDataM appendData:lineBreakData];
        //值：参数值
        [normalParamDataM appendData:[NSString stringWithFormat:@"%@",obj].strData];
        //换行
        [normalParamDataM appendData:lineBreakData];
    }];
    
    
    return normalParamDataM;
}



/**
 *  结束参数对象
 */
+(NSData *)uploadParameterForEnd{
    
    NSData *symbolData=symbol.strData;
    
    NSData *boundaryData=boundary.strData;
    
    NSData *lineBreakData=lineBreak.strData;
    
    //创建对象
    NSMutableData *uploadEndDataM=[NSMutableData data];
    
    //添加起始符号
    [uploadEndDataM appendData:symbolData];
    //添加唯一标识
    [uploadEndDataM appendData:boundaryData];
    //添加起始符号
    [uploadEndDataM appendData:symbolData];
    //换行
    [uploadEndDataM appendData:lineBreakData];
    
    return uploadEndDataM;
}



/**
 *  返回boundary
 */
+(NSString *)boundary{
    return boundary;
}

@end
