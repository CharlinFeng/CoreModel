//
//  BaseModelType.h
//  CoreClass
//
//  Created by 冯成林 on 15/5/28.
//  Copyright (c) 2015年 muxi. All rights reserved.
//

#ifndef CoreClass_BaseModelType_h
#define CoreClass_BaseModelType_h


/** 请求方式 */
typedef enum{
    
    //GET
    BaseModelHttpTypeGET=0,
    
    //POST
    BaseModelHttpTypePOST
    
}BaseModelHttpType;



/** 返回数据格式 */
typedef enum{
    
    //模型：单个
    BaseModelHostDataTypeModelSingle=0,
    
    //数组：数组
    BaseModelHostDataTypeModelArray
    
}BaseModelHostDataType;



/** 模型数据来源 */
typedef enum{
    
    //本地数据库
    BaseModelDataSourceSqlite=0,
    
    //服务器
    BaseModelDataSourceHost
    
}BaseModelDataSource;










#endif
