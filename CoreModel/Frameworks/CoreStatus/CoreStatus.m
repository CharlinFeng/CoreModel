//
//  ToolStatus.m
//  网络
//
//  Created by muxi on 14-10-11.
//  Copyright (c) 2014年 沐汐. All rights reserved.
//

#import "CoreStatus.h"

@implementation CoreStatus




/**
 *  获取当前网络状态
 */
+(NetworkStatus)status{
    return [[Reachability reachabilityForInternetConnection] currentReachabilityStatus];
}



/**
 *  是否处于WIFI环境中：
 */
+(BOOL)isWIFIEnable{
    return [self status]==ReachableViaWiFi;
}



/**
 *  是否有网络数据连接：含2G/3G/WIFI
 */
+(BOOL)isNETWORKEnable{
    return [self status] != NotReachable;
}






@end
