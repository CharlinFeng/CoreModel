//
//  NSObject+Delete.m
//  BaseModel
//
//  Created by muxi on 15/3/30.
//  Copyright (c) 2015年 muxi. All rights reserved.
//

#import "NSObject+Delete.h"
#import "NSObject+BaseModelCommon.h"
#import "CoreFMDB.h"
#import "NSObject+Select.h"
#import "BaseModel.h"
#import "NSObject+MJProperty.h"
#import "MJProperty.h"
#import "MJType.h"
#import "BaseMoelConst.h"

@implementation NSObject (Delete)




/**
 *  条件删除
 *
 *  @param where   where
 *
 *  @return 执行结果
 */
+(BOOL)deleteWhere:(NSString *)where{
    
    if(![NSThread isMainThread]){
        NSLog(@"错误：为了数据安全，数据删除API必须在主线程中执行！");
        return NO;
    }

    //检查表是否存在，如果不存在，直接返回
    if(![self checkTableExists]){
        
        NSLog(@"错误：你操作的模型%@在数据库中没有对应的数据表！",[self modelName]);
        return NO;
    }
    
    NSString *sql=[NSString stringWithFormat:@"DELETE FROM %@",[self modelName]];
    
    if(where != nil) sql = [NSString stringWithFormat:@"%@ WHERE %@",sql,where];
    
    //添加结束的分号
    sql = [NSString stringWithFormat:@"%@;",sql];
    
    //删除之前需要把这些数据查询出来，获取对应的hostID，完成级联操作
    NSArray *deleteModels=[self selectWhere:where groupBy:nil orderBy:nil limit:nil];
    
    if(deleteModels==nil || deleteModels.count==0){//说明将要删除的数据为空，则可直接返回
        return YES;
    }
    
    //遍历模型对象
    for (BaseModel *baseModle in deleteModels) {
        
        [baseModle.class enumerateProperties:^(MJProperty *property, BOOL *stop) {
            //如果是过滤字段，直接跳过
            BOOL skip=[self skipField:property];
            
            if(!skip){
                
                NSString *sqliteTye=[self sqliteType:property.type.code];
                
                //                id value =[baseModle valueForKeyPath:ivar.propertyName];
                
                if([sqliteTye isEqualToString:EmptyString]){//模型字段
                    
                    //级联删除
                    Class ModelClass=NSClassFromString(property.type.code);
                    
                    NSString *where=[NSString stringWithFormat:@"pModel='%@' AND pid=%@",NSStringFromClass(baseModle.class),@(baseModle.hostID)];
                    
                    [ModelClass deleteWhere:where];
                }
            }
        }];

    }
    
    //执行
    BOOL res =  [CoreFMDB executeUpdate:sql];

    if(!res) NSLog(@"错误：执行删除失败，sql语句为：%@",sql);
    
    return res;
}






/**
 *  根据hostID快速删除一条记录
 *
 *  @param hostID hostID
 *
 *  @return 执行结果
 */
+(BOOL)delete:(NSUInteger)hostID{
    
    NSString *where=[NSString stringWithFormat:@"hostID=%@",@(hostID)];
    
    return [self deleteWhere:where];
}




@end
