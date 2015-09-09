//
//  CoreModelType.h
//  CoreClass
//
//  Created by 冯成林 on 15/5/28.
//  Copyright (c) 2015年 muxi. All rights reserved.
//

#ifndef CoreClass_CoreModelType_h
#define CoreClass_CoreModelType_h


/** 请求方式 */
typedef enum{
    
    //GET
    CoreModelHttpTypeGET=0,
    
    //POST
    CoreModelHttpTypePOST
    
}CoreModelHttpType;



/** 返回数据格式 */
typedef enum{
    
    //模型：单个
    CoreModelHostDataTypeModelSingle=0,
    
    //数组：数组
    CoreModelHostDataTypeModelArray
    
}CoreModelHostDataType;



/** 模型数据来源 */
typedef enum{
    
    //默认值：无来源
    CoreModelDataSourceTypeNone,
    
    //本地数据库
    CoreModelDataSourceTypeSqlite,
    
    //服务器数据，且本地数据库无数据
    CoreModelDataSourceHostType_Sqlite_Nil,
    
    //服务器数据，本地数据库有数据，但本地数据过期
    CoreModelDataSourceHostType_Sqlite_Deprecated,
    
}CoreModelDataSourceType;










#endif
