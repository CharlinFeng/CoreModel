//
//  NSObject+Contrast.m
//  CoreModel
//
//  Created by muxi on 15/3/31.
//  Copyright (c) 2015年 muxi. All rights reserved.
//

#import "NSObject+Contrast.h"
#import "CoreModel.h"
#import "NSObject+MJProperty.h"
#import "MJProperty.h"
#import "MJType.h"
#import "CoreModelConst.h"
#import "NSObject+CoreModelCommon.h"

@implementation NSObject (Contrast)


+(BOOL)contrastModel1:(CoreModel *)model1 model2:(CoreModel *)model2{
  
    Class CoreModelClass = [CoreModel class];
   
    BOOL isMember1 = [NSStringFromClass(model1.class) isEqualToString:NSStringFromClass(CoreModelClass)];
    
    BOOL isMember2 = [NSStringFromClass(model1.class) isEqualToString:NSStringFromClass(CoreModelClass)];
    
    if(!isMember1 || !isMember2) return YES;
    
    BOOL res1= [model1.class isSubclassOfClass:CoreModelClass];
    
    BOOL res2= [model2.class isSubclassOfClass:CoreModelClass];
    
    if(!res1 || !res2){
        
        if(CoreModelDeBug) NSLog(@"错误：请传入标准的CoreModel模型或其子类，您当前传入的模型为：%@，%@",NSStringFromClass(model1.class),NSStringFromClass(model2.class));
        return NO;
    }
    
    if(![NSStringFromClass(model1.class) isEqualToString:NSStringFromClass(model2.class)]){
        
        if(CoreModelDeBug) NSLog(@"错误：模型类型不一致。model1:%@,model2:%@",NSStringFromClass(model1.class),NSStringFromClass(model2.class));
        return NO;
    }
    
    if(![NSStringFromClass(model1.class) isEqualToString:[self modelName]]){
        
        if(CoreModelDeBug) NSLog(@"错误：方法调用错误，您当前是%@模型，请调用%@的类方法进入对比。",NSStringFromClass(model1.class),NSStringFromClass(model1.class));
        return NO;
    }
    
    if(model1.hostID != model2.hostID){
        
        if(CoreModelDeBug) NSLog(@"错误：模型hostID不一致。model1.hostID=%@,model1.hostID=%@",@(model1.hostID),@(model2.hostID));
        return NO;
    }
    
    __block BOOL contrastRes = YES;

    [model1.class enumerateProperties:^(MJProperty *property, BOOL *stop) {
        
        NSString *propertyName = property.name;
        
        if(![[CoreModel constrastIgnorFields] containsObject:propertyName]){
            
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
            
            if([CoreNSString isEqualToString:code]){
                
                NSString *str1=(NSString *)value1;
                NSString *str2=(NSString *)value2;
                
                if(str1==nil && str2 != nil){
                    res = NO;
                    if(CoreModelDeBug) NSLog(@"NSString不一样：%@的%@属性为空，而%@的%@属性有值",NSStringFromClass(model1.class),propertyName,NSStringFromClass(model2.class),propertyName);
                }else if (str1!=nil && str2 == nil){
                    res = NO;
                    if(CoreModelDeBug) NSLog(@"NSString不一样：%@的%@属性有值，而%@的%@属性为空",NSStringFromClass(model1.class),propertyName,NSStringFromClass(model2.class),propertyName);
                }else if(str1 != nil && str2 != nil){
                    res =[str1 isEqualToString:str2];
                    if(CoreModelDeBug) {if(!res) NSLog(@"NSString不一样：%@.%@=%@,%@.%@=%@",NSStringFromClass(model1.class),propertyName,str1,NSStringFromClass(model2.class),propertyName,str2);};
                }
            }else if (isIntegerS){
                
                NSInteger integer1=[value1 integerValue];
                NSInteger integer2=[value1 integerValue];
                res = integer1==integer2;
                if(CoreModelDeBug) {if(!res) NSLog(@"NSInteger不一样：%@.%@=%@,%@.%@=%@",NSStringFromClass(model1.class),propertyName,@(integer1),NSStringFromClass(model2.class),propertyName,@(integer2));};
            }else if ([CoreBOOL isEqualToString:code]){
                
                BOOL b1=[value1 boolValue];
                BOOL b2=[value2 boolValue];
                res = b1 == b2;
                if(CoreModelDeBug) {if(!res) NSLog(@"BOOL不一样：%@.%@=%@,%@.%@=%@",NSStringFromClass(model1.class),propertyName,@(b1),NSStringFromClass(model2.class),propertyName,@(b2));};
            }else if ([CoreCGFloat isEqualToString:code]){
                
                CGFloat f1=[value1 floatValue];
                CGFloat f2=[value2 floatValue];
                res = f1 == f2;
                if(CoreModelDeBug) {if(!res) NSLog(@"CGFloat不一样：%@.%@=%@,%@.%@=%@",NSStringFromClass(model1.class),propertyName,@(f1),NSStringFromClass(model2.class),propertyName,@(f2));};
            }else{
                
                CoreModel *childModel1 = value1;
                CoreModel *childModel2 = value2;
                
                if(childModel1==nil && childModel2!=nil){
                    res=NO;
                    if(CoreModelDeBug) NSLog(@"模型字段不一样：%@模型的%@属性为空，而%@模型的%@属性为有值",NSStringFromClass(model1.class),propertyName,NSStringFromClass(model2.class),propertyName);
                }else if (childModel1!=nil && childModel2==nil){
                    res=NO;
                    if(CoreModelDeBug) NSLog(@"模型字段不一样：%@模型的%@属性有值，而%@模型的%@属性为空",NSStringFromClass(model1.class),propertyName,NSStringFromClass(model2.class),propertyName);
                }else if(childModel1!=nil && childModel2!=nil){
                    res = [childModel1.class contrastModel1:childModel1 model2:childModel2];
                    if(CoreModelDeBug) if(!res) NSLog(@"模型字段不一样：%@模型的%@属性不一样",NSStringFromClass(model1.class),propertyName);
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



+(BOOL)contrastModels1:(NSArray *)models1 models2:(NSArray *)models2{
    
    if(models1==nil || models1.count==0 || models2==nil || models2.count==0){
        
        if(CoreModelDeBug) NSLog(@"错误：数组为空，对比无效。");
        return NO;
    }
    
    if(models1.count != models2.count){
        
        if(CoreModelDeBug) NSLog(@"错误：数组长度不一致。");
        return NO;
    }
    
    BOOL checkRes1 = [self check:models1];
    if(!checkRes1){
        
        if(CoreModelDeBug) NSLog(@"错误：您传入的数组1成员对象不符合要求:%@",models1);
        return NO;
    }
    
    BOOL checkRes2 = [self check:models2];
    if(!checkRes2){
        
        if(CoreModelDeBug) NSLog(@"错误：您传入的数组2成员对象不符合要求:%@",models2);
        return NO;
    }
    
    BOOL arrayContrastRes = YES;

    NSArray *sortedArray1=[self sortCoreModelArray:models1];
    NSArray *sortedArray2=[self sortCoreModelArray:models2];
    
    for (NSInteger i=0; i<sortedArray1.count; i++) {
        
        CoreModel *memberModel1=sortedArray1[i];
        CoreModel *memberModel2=sortedArray2[i];
        BOOL memberContrastRes = [self contrastModel1:memberModel1 model2:memberModel2];
        
        if(memberContrastRes) continue;
        
        arrayContrastRes=NO;
        
        break;
    }
    
    return arrayContrastRes;
}

+(NSArray *)sortCoreModelArray:(NSArray *)array{

    if(array==nil || array.count==0) return nil;
    
    NSArray *sortedArray = [array sortedArrayUsingComparator:^NSComparisonResult(CoreModel *CoreModelOne, CoreModel *CoreModelAnother) {
        
        if(CoreModelOne.hostID<CoreModelAnother.hostID) return NSOrderedAscending;
        if(CoreModelOne.hostID>CoreModelAnother.hostID) return NSOrderedDescending;
        return NSOrderedSame;
    }];
    
    return sortedArray;
}


+(BOOL)check:(NSArray *)models{
    
    __block BOOL checkRes = YES;
    
    [models enumerateObjectsUsingBlock:^(NSObject *obj, NSUInteger idx, BOOL *stop) {
        
        if(![obj isKindOfClass:self]){
            
            checkRes = NO;
            if(CoreModelDeBug) NSLog(@"错误：请传入%@模型或者子类的对象",[self modelName]);
            *stop = YES;
        }
    }];
    
    return checkRes;
}


@end
