//
//  NSObject+Contrast.m
//  BaseModel
//
//  Created by muxi on 15/3/31.
//  Copyright (c) 2015年 muxi. All rights reserved.
//

#import "NSObject+Contrast.h"
#import "BaseModel.h"
#import "NSObject+MJProperty.h"
#import "MJProperty.h"
#import "MJType.h"
#import "BaseMoelConst.h"
#import "NSObject+BaseModelCommon.h"

@implementation NSObject (Contrast)


/**
 *  扩展功能1：模型对比，检查两个模型从数据内容来讲是否是同是一样的，此功能是列表缓存更新的基础（级联对比）
 *
 *  @param model1 模型1：此模型必须是BaseModel或其子类
 *  @param model2 模型2：此模型必须是BaseModel或其子类
 *
 *  @return 对比结果
 */
+(BOOL)contrastModel1:(BaseModel *)model1 model2:(BaseModel *)model2{
  
    Class BaseModelClass = [BaseModel class];
   
    //经过实践证明，如果是BaseModel本尊子类，对比会导致崩溃
    BOOL isMember1 = [NSStringFromClass(model1.class) isEqualToString:NSStringFromClass(BaseModelClass)];
    
    BOOL isMember2 = [NSStringFromClass(model1.class) isEqualToString:NSStringFromClass(BaseModelClass)];
    
    if(!isMember1 || !isMember2) return YES;
    
    BOOL res1= [model1.class isSubclassOfClass:BaseModelClass];
    
    BOOL res2= [model2.class isSubclassOfClass:BaseModelClass];
    
    if(!res1 || !res2){
        
        NSLog(@"错误：请传入标准的BaseModel模型或其子类，您当前传入的模型为：%@，%@",NSStringFromClass(model1.class),NSStringFromClass(model2.class));
        return NO;
    }
    
    if(![NSStringFromClass(model1.class) isEqualToString:NSStringFromClass(model2.class)]){
        
        NSLog(@"错误：模型类型不一致。model1:%@,model2:%@",NSStringFromClass(model1.class),NSStringFromClass(model2.class));
        return NO;
    }
    
    if(![NSStringFromClass(model1.class) isEqualToString:[self modelName]]){
        
        NSLog(@"错误：方法调用错误，您当前是%@模型，请调用%@的类方法进入对比。",NSStringFromClass(model1.class),NSStringFromClass(model1.class));
        return NO;
    }
    
    
    //正式对比
    if(model1.hostID != model2.hostID){
        
        NSLog(@"错误：模型hostID不一致。model1.hostID=%@,model1.hostID=%@",@(model1.hostID),@(model2.hostID));
        return NO;
    }
    
    __block BOOL contrastRes = YES;
    
    //遍历成员属性
    [model1.class enumerateProperties:^(MJProperty *property, BOOL *stop) {
        
        NSString *propertyName = property.name;
        
        if(![[BaseModel constrastIgnorFields] containsObject:propertyName]){
            
            id value1 = [model1 valueForKeyPath:propertyName];
            id value2 = [model2 valueForKeyPath:propertyName];
            
            NSString *code=property.type.code;
            BOOL res = YES;
            
            NSArray *integerConstStrings = @[CoreNSInteger,CoreNSUInteger,CoreEnum_int];
            
            __block BOOL isIntegerS =NO;
            
            [integerConstStrings enumerateObjectsUsingBlock:^(NSString *typeStringConst, NSUInteger idx, BOOL *stop) {
                
                NSRange range = [typeStringConst rangeOfString:code];
                
                if(range.length>0){
                    isIntegerS =YES;
                }
            }];
            
            if([CoreNSString isEqualToString:code]){//NSString
                
                NSString *str1=(NSString *)value1;
                NSString *str2=(NSString *)value2;
                
                if(str1==nil && str2 != nil){
                    res = NO;
                    NSLog(@"NSString不一样：%@的%@属性为空，而%@的%@属性有值",NSStringFromClass(model1.class),propertyName,NSStringFromClass(model2.class),propertyName);
                }else if (str1!=nil && str2 == nil){
                    res = NO;
                    NSLog(@"NSString不一样：%@的%@属性有值，而%@的%@属性为空",NSStringFromClass(model1.class),propertyName,NSStringFromClass(model2.class),propertyName);
                }else if(str1 != nil && str2 != nil){
                    res =[str1 isEqualToString:str2];
                    if(!res) NSLog(@"NSString不一样：%@.%@=%@,%@.%@=%@",NSStringFromClass(model1.class),propertyName,str1,NSStringFromClass(model2.class),propertyName,str2);
                }
            }else if (isIntegerS){//NSInteger、NSUInteger、CoreEnum_int
                
                NSInteger integer1=[value1 integerValue];
                NSInteger integer2=[value1 integerValue];
                res = integer1==integer2;
                if(!res) NSLog(@"NSInteger不一样：%@.%@=%@,%@.%@=%@",NSStringFromClass(model1.class),propertyName,@(integer1),NSStringFromClass(model2.class),propertyName,@(integer2));
            }else if ([CoreBOOL isEqualToString:code]){//BOOL
                
                BOOL b1=[value1 boolValue];
                BOOL b2=[value2 boolValue];
                res = b1 == b2;
                if(!res) NSLog(@"BOOL不一样：%@.%@=%@,%@.%@=%@",NSStringFromClass(model1.class),propertyName,@(b1),NSStringFromClass(model2.class),propertyName,@(b2));
            }else if ([CoreCGFloat isEqualToString:code]){//CGFloat
                
                CGFloat f1=[value1 floatValue];
                CGFloat f2=[value2 floatValue];
                res = f1 == f2;
                if(!res) NSLog(@"CGFloat不一样：%@.%@=%@,%@.%@=%@",NSStringFromClass(model1.class),propertyName,@(f1),NSStringFromClass(model2.class),propertyName,@(f2));
            }else{//模型字段
                
                BaseModel *childModel1 = value1;
                BaseModel *childModel2 = value2;
                
                if(childModel1==nil && childModel2!=nil){
                    res=NO;
                    NSLog(@"模型字段不一样：%@模型的%@属性为空，而%@模型的%@属性为有值",NSStringFromClass(model1.class),propertyName,NSStringFromClass(model2.class),propertyName);
                }else if (childModel1!=nil && childModel2==nil){
                    res=NO;
                    NSLog(@"模型字段不一样：%@模型的%@属性有值，而%@模型的%@属性为空",NSStringFromClass(model1.class),propertyName,NSStringFromClass(model2.class),propertyName);
                }else if(childModel1!=nil && childModel2!=nil){
                    res = [childModel1.class contrastModel1:childModel1 model2:childModel2];
                    if(!res) NSLog(@"模型字段不一样：%@模型的%@属性不一样",NSStringFromClass(model1.class),propertyName);
                }
            }
            
            if(!res){
                
                contrastRes = NO;
                *stop=YES;
            }
            
        }

    }];

    return contrastRes;
}








/**
 *  扩展功能2：模型数组对比，检查两个数组内部所有模型从数据内容来讲是否是同是一样的，此功能是列表缓存更新的基础（级联对比）
 *
 *  @param models1 模型数据1
 *  @param models2 模型数组2
 *
 *  @return 对比结果
 */
+(BOOL)contrastModels1:(NSArray *)models1 models2:(NSArray *)models2{
    
    //如果为空，直接返回
    if(models1==nil || models1.count==0 || models2==nil || models2.count==0){
        
        NSLog(@"错误：数组为空，对比无效。");
        return NO;
    }
    
    //长度检查
    if(models1.count != models2.count){
        
        NSLog(@"错误：数组长度不一致。");
        return NO;
    }
    
    //数组成员对象严格检查
    BOOL checkRes1 = [self check:models1];
    if(!checkRes1){
        
        NSLog(@"错误：您传入的数组1成员对象不符合要求:%@",models1);
        return NO;
    }
    
    BOOL checkRes2 = [self check:models2];
    if(!checkRes2){
        
        NSLog(@"错误：您传入的数组2成员对象不符合要求:%@",models2);
        return NO;
    }
    
    //正式对比
    BOOL arrayContrastRes = YES;
    
    
    //排序
    NSArray *sortedArray1=[self sortBaseModelArray:models1];
    NSArray *sortedArray2=[self sortBaseModelArray:models2];
    
    //遍历
    for (NSInteger i=0; i<sortedArray1.count; i++) {
        
        //取出对应的成员对象
        BaseModel *memberModel1=sortedArray1[i];
        BaseModel *memberModel2=sortedArray2[i];
        BOOL memberContrastRes = [self contrastModel1:memberModel1 model2:memberModel2];
        
        if(memberContrastRes) continue;
        
        arrayContrastRes=NO;
        
        break;
    }
    
    return arrayContrastRes;
}


/**
 *  模型数组排序：（此处默认升序处理）
 */
+(NSArray *)sortBaseModelArray:(NSArray *)array{
    
    //异常处理
    if(array==nil || array.count==0) return nil;
    
    NSArray *sortedArray = [array sortedArrayUsingComparator:^NSComparisonResult(BaseModel *baseModelOne, BaseModel *baseModelAnother) {
        
        if(baseModelOne.hostID<baseModelAnother.hostID) return NSOrderedAscending;
        if(baseModelOne.hostID>baseModelAnother.hostID) return NSOrderedDescending;
        return NSOrderedSame;
    }];
    
    return sortedArray;
}




/**
 *  数组成员对象严格检查
 */
+(BOOL)check:(NSArray *)models{
    
    __block BOOL checkRes = YES;
    
    [models enumerateObjectsUsingBlock:^(NSObject *obj, NSUInteger idx, BOOL *stop) {
        
        if(![obj isKindOfClass:self]){
            
            checkRes = NO;
            NSLog(@"错误：请传入%@模型或者子类的对象",[self modelName]);
            *stop = YES;
        }
    }];
    
    return checkRes;
}


@end
