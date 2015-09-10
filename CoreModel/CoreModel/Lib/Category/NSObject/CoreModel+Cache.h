//
//  NSObject+Cache.h
//  CoreModel
//
//  Created by 冯成林 on 15/9/10.
//  Copyright (c) 2015年 冯成林. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreModel.h"
#import "CoreModelType.h"

@interface CoreModel (Cache)

/** 此方法是第四季与第五季内容，并且是框架内部的系统级方法，你用不到 */
/** 读取 */
/** 目前是不考虑上拉下拉刷新 */
/** 不论是本地查询还是网络请求，均是延时操作，返回block均在子线程中 */
+(void)selectWithParams:(NSDictionary *)params userInfo:(NSDictionary *)userInfo beginBlock:(void(^)(BOOL isNetWorkRequest,BOOL needHUD))beginBlock successBlock:(void(^)(NSArray *models,CoreModelDataSourceType sourceType,NSDictionary *userInfo))successBlock errorBlock:(void(^)(NSString *errorResult,NSDictionary *userInfo))errorBlock;


@end
