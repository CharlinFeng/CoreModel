//
//  ToolStatus.h
//  网络
//
//  Created by muxi on 14-10-11.
//  Copyright (c) 2014年 沐汐. All rights reserved.
//
//


#import <Foundation/Foundation.h>
#import "Reachability.h"

@interface CoreStatus : NSObject

/**
 *  获取当前网络状态
 */
+(NetworkStatus)status;



/**
 *  是否处于WIFI环境中：
 */
+(BOOL)isWIFIEnable;

/**
 *  是否有网络数据连接：含2G/3G/WIFI
 */
+(BOOL)isNETWORKEnable;



@end
