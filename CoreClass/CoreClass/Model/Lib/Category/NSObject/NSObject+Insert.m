//
//  NSObject+Insert.m
//  BaseModel
//
//  Created by muxi on 15/3/30.
//  Copyright (c) 2015年 muxi. All rights reserved.
//

#import "NSObject+Insert.h"
#import "BaseModel.h"
#import "MJProperty.h"
#import "MJType.h"
#import "NSObject+BaseModelCommon.h"
#import "BaseMoelConst.h"
#import "CoreFMDB.h"
#import "NSObject+Select.h"

@implementation NSObject (Insert)


/**
 *  插入数据（单个）
 *
 *  @param model 模型数据
 *
 *  @return 插入数据的执行结果
 */
+(BOOL)insert:(id)model{
    
    //检查表是否存在，如果不存在，直接返回
    if(![self checkTableExists]){
        
        NSLog(@"错误：你操作的模型%@在数据库中没有对应的数据表！",[self modelName]);
        return NO;
    }

    if(![NSThread isMainThread]){
        NSLog(@"错误：为了数据安全，数据插入API必须在主线程中执行！");
        return NO;
    }

    if(![model isKindOfClass:[self class]]){
        NSLog(@"错误：插入数据请使用%@模型类对象，您使用的是%@类型",[self modelName],[model class]);
        return NO;
    }
    
    BaseModel *baseModel=(BaseModel *)model;

    //无hostID的数据插入都是耍流氓
    if(baseModel.hostID==0){
        NSLog(@"错误：数据插入失败，你必须设置模型的模型hostID!");
        return NO;
    }
    NSLog(@"数据插入开始%@",[NSThread currentThread]);
#warning 插入数据之前是需要查询一次，是否已经插入此条数据了，这里先没有做
    //注意点：插入数据的属性需要考虑：普通属性直接添加，不能添加自定义的过滤字段，模型字段需要单独添加到对应的模型表中。
    //如果待插入的数据，本地数据库已经存在（判断依据是待插入数据hostID在数据库中是否已经存在），作为insert方法，需要直接返回NO，不能执行更新操作，更新操作请使用save:方法
    BaseModel *dbModel=[self find:baseModel.hostID];
    
    if(dbModel!=nil){
        NSLog(@"%@的数据已经存在",@(baseModel.hostID));
        return NO;
    }
    
    NSMutableString *fields=[NSMutableString string];
    NSMutableString *values=[NSMutableString string];

    //遍历成员属性
    [self enumerateProperties:^(MJProperty *property, BOOL *stop) {
        
        //如果是过滤字段，直接跳过
        BOOL skip=[self skipField:property];
        
        if(!skip){
            
            NSString *sqliteTye=[self sqliteType:property.type.code];
            
            id value =[model valueForKeyPath:property.name];
            
            if(![sqliteTye isEqualToString:EmptyString]){
                
                //拼接属性名
                [fields appendFormat:@"%@,",property.name];
                
                //拼接属性值
                //字符串需要再处理
                
                if([property.type.code isEqualToString:CoreNSString]){
                    
                    if(value == nil) value=@"";
                    
                    //添加引号表明字符串
                    value=[NSString stringWithFormat:@"'%@'",value];
                }
                [values appendFormat:@"%@,",value];
                
            }else{
                
                //此属性是模型，且已经动态生成模型字段对应的数据表
                if(property.name!=nil && value!=nil){
                    
                    BaseModel *childModel=(BaseModel *)value;
                    
                    //自动处理pModel:KVO
                    [childModel setValue:NSStringFromClass(baseModel.class) forKey:@"pModel"];
                    
                    //自动处理pid:KVO
                    [childModel setValue:@(baseModel.hostID) forKey:@"pid"];
                    
                    //级联保存数据
                    BOOL childInsertRes = [NSClassFromString(property.type.code) insert:value];
                    
                    if(!childInsertRes) NSLog(@"错误：级联保存数据失败！级联父类：%@，子属性为：%@",NSStringFromClass(baseModel.class),value);
                }
            }
        }
    }];


    //删除最后的字符
    NSString *fields_sub=[self deleteLastChar:fields];
    NSString *values_sub=[self deleteLastChar:values];

    //得到最终的sql
    NSString *sql=[NSString stringWithFormat:@"INSERT INTO %@ (%@) VALUES (%@);",[self modelName],fields_sub,values_sub];
    
    //执行添加
    BOOL insertRes = [CoreFMDB executeUpdate:sql];
    
    if(!insertRes) NSLog(@"错误：添加对象失败%@",baseModel);
    NSLog(@"数据插入结束%@",[NSThread currentThread]);
    return insertRes;
}




/**
 *  插入数据（批量）
 *
 *  @param models 模型数组
 *
 *  @return 批量插入数据的执行结果
 */
+(BOOL)inserts:(NSArray *)models{
    
    //检查表是否存在，如果不存在，直接返回
    if(![self checkTableExists]){
        NSLog(@"错误：你操作的模型%@在数据库中没有对应的数据表！",[self modelName]);
        return NO;
    }
    
    BOOL insertsRes=YES;
    NSLog(@"批量插入开始%@",[NSThread currentThread]);
    for (BaseModel *baseModel in models) {
        
        BOOL insertRes = [self insert:baseModel];
        
        //如果有一个出错，则认为整个数据批量插入失败
        if(!insertRes) insertsRes=NO;
    }
    NSLog(@"批量插入结束%@",[NSThread currentThread]);
    return insertsRes;
}

@end
