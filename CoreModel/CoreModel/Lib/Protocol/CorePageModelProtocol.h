//
//  BasePageModelProtocol.h
//  CoreClass
//
//  Created by 冯成林 on 15/6/5.
//  Copyright (c) 2015年 muxi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreModelType.h"






@protocol CorePageModelProtocol <NSObject>

@required


/**
 *  是否为分页数据
 *
 *  @return 如果为分页模型请返回YES，否则返回NO
 */
+(BOOL)CoreModel_isPageEnable;


/** page字段 */
+(NSString *)CoreModel_PageKey;


/** pagesize字段 */
+(NSString *)CoreModel_PageSizeKey;


/** 页码起点 */
+(NSUInteger)CoreModel_StartPage;


/** 每页数据量 */
+(NSUInteger)CoreModel_PageSize;




















@end