//
//  BaseModel.h
//  4s
//
//  Created by muxi on 15/3/11.
//  Copyright (c) 2015年 muxi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModelProtocol.h"
#import "BasePageModelProtocol.h"
#import "NSObject+Insert.h"
#import "NSObject+Save.h"
#import "NSObject+Delete.h"
#import "NSObject+Update.h"
#import "NSObject+Select.h"

@interface BaseModel : NSObject<BaseModelProtocol,BasePageModelProtocol>


/** 服务器数据的ID */
@property (nonatomic,assign) NSInteger hostID;


/** 父级模型名称：此属性用于完成级联添加以及查询，框架将自动处理，请不要手动修改！ */
@property (nonatomic,copy,readonly) NSString *pModel;


/** 父模型的hostID：此属性用于完成级联添加以及查询，框架将自动处理，请不要手动修改！ */
@property (nonatomic,assign,readonly) NSInteger pid;


/** 模型对比时需要忽略的字段 */
+(NSArray *)constrastIgnorFields;


/** 读取 */
/** 目前是不考虑上拉下拉刷新 */
/** 不论是本地查询还是网络请求，均是延时操作，返回block均在子线程中 */
+(void)selectWithParams:(NSDictionary *)params userInfo:(NSDictionary *)userInfo beginBlock:(void(^)(BOOL isNetWorkRequest,BOOL needHUD))beginBlock successBlock:(void(^)(NSArray *models,BaseModelDataSourceType sourceType,NSDictionary *userInfo))successBlock errorBlock:(void(^)(NSString *errorResult,NSDictionary *userInfo))errorBlock;





@end
