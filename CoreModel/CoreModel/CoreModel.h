//
//  CoreModel.h
//  4s
//
//  Created by muxi on 15/3/11.
//  Copyright (c) 2015年 muxi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreModelProtocol.h"
#import "CorePageModelProtocol.h"
#import "NSObject+Insert.h"
#import "NSObject+Save.h"
#import "NSObject+Delete.h"
#import "NSObject+Update.h"
#import "NSObject+Select.h"
#import "NSObject+CoreModelCommon.h"


@interface CoreModel : NSObject<CoreModelProtocol,CorePageModelProtocol>


/** 服务器数据的ID：字符串化 */
@property (nonatomic,assign) NSInteger hostID;


/** 父级模型名称：此属性用于完成级联添加以及查询，框架将自动处理，请不要手动修改！ */
@property (nonatomic,copy,readonly) NSString *pModel;


/** 父模型的hostID：此属性用于完成级联添加以及查询，框架将自动处理，请不要手动修改！ */
@property (nonatomic,assign,readonly) NSInteger pid;






@end
