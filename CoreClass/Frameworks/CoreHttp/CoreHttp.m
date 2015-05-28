//
//  ToolConnection.m
//
//  Created by muxi on 14/10/22.
//  Copyright (c) 2014年 muxi. All rights reserved.


#import "CoreHttp.h"
#import "NSString+CoreHttp.h"
#import "CoreStatus.h"
#import "NSData+Param.h"
#import <UIKit/UIKit.h>

//定义APP的POST请求是否以标准的JSON格式通讯
const BOOL kURLConnectionMutualUseJson = NO;

@implementation CoreHttp

#pragma mark  请求前统一处理：如果是没有网络，则不论是GET请求还是POST请求，均无需继续处理
+(BOOL)requestBeforeCheckNetWorkWithErrorBlock:(ErrorBlock)errorBlock{
    
    BOOL isNETWORKEnable=[CoreStatus isNETWORKEnable];
    
    if(!isNETWORKEnable){//无网络
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if(errorBlock!=nil) errorBlock(CoreHttpErrorTypeNoNetWork);
        });
    }else{//有网络
        
        //状态栏数据指示器打开
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
        });
    }
    
    return isNETWORKEnable;
}


#pragma mark  GET
+(void)getUrl:(NSString *)urlString params:(NSDictionary *)params success:(SuccessBlock)successBlock errorBlock:(ErrorBlock)errorBlock{
    
    __block NSString *urlStr=urlString;
    
    //GET请求放入子线程中处理
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        //请求前网络检查
        if(![self requestBeforeCheckNetWorkWithErrorBlock:errorBlock]) return;
        
        if(params !=nil){
            
            //含有参数
            NSMutableString *paraTempString=[NSMutableString string];
            
            //拼接数据
            [params enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                [paraTempString appendFormat:@"%@=%@&",key,obj];
            }];
            
            //去除最后一个字符
            NSString *paramsStr=[paraTempString substringToIndex:paraTempString.length-1];
            
            //取出key
            NSRange range=[urlStr rangeOfString:@"?"];
            
            BOOL paramsAlreadyAppend=range.length>0;
            
            NSString *symbol=paramsAlreadyAppend?@"&":@"?";
            
            urlStr=[NSString stringWithFormat:@"%@%@%@",urlStr,symbol,paramsStr];
        }
        
        //urlStr格式化
        urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

        //定义URL
        NSURL *url=[NSURL URLWithString:urlStr];
        
        //定义请求:设置缓存策略，超时时长
        NSURLRequest *request=[NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0f];
        
        //异步请求
        [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            
            //请求结束，统一处理
            [self disposeUrlString:(NSString *)urlStr response:response data:data error:connectionError success:successBlock error:errorBlock];
        }];

    });
}



#pragma mark  POST:
+(void)postUrl:(NSString *)urlString params:(NSDictionary *)params success:(SuccessBlock)successBlock errorBlock:(ErrorBlock)errorBlock{
    
    __block NSString *urlStr=urlString;
    
    //POST请求放入子线程中处理
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //请求前网络检查
        if(![self requestBeforeCheckNetWorkWithErrorBlock:errorBlock]) return;
        
        //urlStr格式化
        urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        //定义URL
        NSURL *url=[NSURL URLWithString:urlStr];
        
        //定义请求:设置缓存策略，超时时长
        NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0f];
        
        //指定请求方式
        request.HTTPMethod=@"POST";
        
        NSData *data=nil;;
        
        //如果是标准的JSON交互，需要指明头信息：
        if(kURLConnectionMutualUseJson){
            //JSON交互
            //设置请求头：JSON格式的请求头信息
            [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            
            //将字典转为json数据格式的字符串：
            NSError *dict2JsonError=nil;
            data=[NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:&dict2JsonError];
            
            if(dict2JsonError != nil){//使用苹果自带的dict转json出错
                NSLog(@"网络请求错误日志（code=0）：POST传递json数据时出现错误，数据体为：%@\n 请求URL=%@",params,urlString);
                return;
            }
            
            
        }else{
            
            if(params!=nil){
                //非JSON，直接请求
                NSMutableString *paraTempString=[NSMutableString string];
                
                //拼接数据
                [params enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                    [paraTempString appendFormat:@"%@=%@&",key,obj];
                }];
                
                //去除最后一个字符
                NSString *paramsStr=[paraTempString substringToIndex:paraTempString.length-1];
                
                data=[paramsStr dataUsingEncoding:NSUTF8StringEncoding];
            }
        }
        
        //设置数据体
        request.HTTPBody=data;
        
        //POST请求
        [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            
            //请求结束，统一处理
            [self disposeUrlString:urlStr response:response data:data error:connectionError success:successBlock error:errorBlock];
            
        }];

    });
    
}




#pragma mark - 统一处理网络请求数据结果：
+(void)disposeUrlString:(NSString *)urlString response:(NSURLResponse *)response data:(NSData *)data error:(NSError *)connectionError success:(SuccessBlock)successBlock error:(ErrorBlock)errorBlock {

    //网络请求结束
    //状态栏数据指示器关闭:主线程中操作
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
    });
    
    if(connectionError!=nil){

        //这个error有值，说明一定有错，URL地址有错，要么服务器没有响应。总之连接就有错
        errorBlock(CoreHttpErrorTypeURLConnectionError);NSLog(@"网络请求错误日志（code=1）：URL地址有错，要么服务器没有响应。总之连接就有错。\n 请求URL=%@",urlString);
        return;
    }else{
        //如果connectionError为nil，只能说url连接成功，但是url地址不一定正确，如服务器返回404状态码，表明页面找不到
        NSHTTPURLResponse *responseReal=(NSHTTPURLResponse *)response;
        NSInteger statusCode=responseReal.statusCode;
        if(statusCode!=200){

            //即页面请求正确，但是状态码不正确，即页面请求失败
            errorBlock(CoreHttpErrorTypeStatusCodeError);NSLog(@"网络请求错误日志（code=2）：服务器响应状态码不正确,当前状态码为：%@。 \n 请求URL=%@",@(statusCode),urlString);
            return;
        }
    }
    
    //返回为空
    if(data == nil){
        
        //如果一切返回正常，但是服务器返回空数据，一样视为失败的一次请求，什么数据都没有请求到。
        errorBlock(CoreHttpErrorTypeDataNilError);NSLog(@"网络请求错误日志（code=3.1）：服务器返回空数据，一样视为失败的一次请求，什么数据都没有请求到。\n 请求URL=%@",urlString);
        return;
    }
    
    //定义Error
    NSError *error=nil;
    
    //准备开始解析
    //有的JSON数据格式不是很规范，格式里面包含了回车，换行以及TAB等制表符，我们应该先清除一下这些制表符再进行反序列化。
    
    NSString * dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

    dataString = [dataString deleteSpecialCode];
    NSData *correctStringData=[dataString dataUsingEncoding:NSUTF8StringEncoding];
  
    //实践证明，如果dataString=@""空字符串，是没有任何问题的
    //但是如果是dataString=nil，会引发correctStringData=nil，json解析传入参数为nil，直接抛出异常而导致程序崩溃。
    if(dataString==nil || correctStringData==nil){

        //同样是DataNilError：前面是返回的处理前的Data=nil，这里是处理后的correctStringData=nil
        errorBlock(CoreHttpErrorTypeDataNilError);NSLog(@"网络请求错误日志（code=3.2）：服务器返回的Data处理后为nil，相当于还是得到了无效的空数据。\n 请求URL=%@",urlString);
        return;
    }
    
    //数据解析:结果为一定是数组或者字典。其中是字典的可能性非常大。
    id obj=[NSJSONSerialization JSONObjectWithData:correctStringData options:NSJSONReadingAllowFragments error:&error];
    
    //判断解析是否出错
    if(error != nil){
        
        errorBlock(CoreHttpErrorTypeDataSerializationError);NSLog(@"网络请求错误日志（code=6）：JSON数据解析时出错。\n 请求URL=%@",urlString);
        return;
    }

    if(obj==nil){

        //解析之后数据为nil：
        errorBlock(CoreHttpErrorTypeDataSerializationError);NSLog(@"网络请求错误日志（code=4）：解析之后数据为nil。\n 请求URL=%@",urlString);
        return;
    }
    
    //处理成功
    successBlock(obj);
}





#pragma mark  文件上传
+(void)uploadUrl:(NSString *)uploadUrl params:(NSDictionary *)params files:(NSArray *)files success:(SuccessBlock)successBlock errorBlock:(ErrorBlock)errorBlock{
    
    __block NSString *urlStr=uploadUrl;
    
    //POST请求放入子线程中处理
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        //请求前网络检查
        if(![self requestBeforeCheckNetWorkWithErrorBlock:errorBlock]) return;
        
        //urlStr格式化
        urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        //定义URL
        NSURL *url=[NSURL URLWithString:urlStr];
        
        //定义请求:设置缓存策略，超时时长
        NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:180.0f];

        //指定请求方式
        request.HTTPMethod=@"POST";
        
        NSMutableData *data=[NSMutableData data];
        
        //如果有普通参数才需要拼接
        if(params!=nil){
            //拼接普通参数数据
            NSData *uploadNormalParamsData=[NSData uploadParameterForNormalParams:params];
            //拼接
            [data appendData:uploadNormalParamsData];
        }

        //如果有文件参数才需要拼接
        if(files !=nil || files.count!=0){
            
            //拼接文件参数数据
            NSData *uploadFileParamsData=[NSData uploadParameterForFiles:files];
            //拼接
            [data appendData:uploadFileParamsData];
        }
        
        //禁用什么都不传：既没有传普通参数，又没有传文件参数
        if(data.length==0){
            
            //解析之后数据为nil：
            errorBlock(CoreHttpErrorTypeUploadDataNil);NSLog(@"网络请求错误日志（code=6）：POST数据全部为空，没有普通参数，没有文件。\n 请求URL=%@",urlStr);
            return;
        }
        
        //添加结尾参数
        NSData *uploadEndData = [NSData uploadParameterForEnd];
        //拼接
        [data appendData:uploadEndData];
        
        //设置数据体
        request.HTTPBody=data;
        
        // 4.设置请求头(告诉服务器这次传给你的是文件数据，告诉服务器现在发送的是一个文件上传请求)

        [request setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@", [NSData boundary]] forHTTPHeaderField:@"Content-Type"];
        // 请求体的长度
        [request setValue:[NSString stringWithFormat:@"%zd", data.length] forHTTPHeaderField:@"Content-Length"];
        
        //POST请求
        [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {

            //请求结束，统一处理
            [self disposeUrlString:urlStr response:response data:data error:connectionError success:successBlock error:errorBlock];
        }];
    });
}






@end
