/*
 
 BaseModel使用说明：
 
 一、概述：
 
 1.不需要存数据，只需要直接读数据。因为读取数据内部自动封装了网络请求，已经将保存、修改数据封装在内部。
 
 
 
 
 二、使用说明：
 
 1.如果是分页请求模型数据，params参数里面需要带上当前的page信息，
 
    例如 NSDictionary *params = @{[BaseModel baseModel_PageKey]:@(currentPage)};
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 */