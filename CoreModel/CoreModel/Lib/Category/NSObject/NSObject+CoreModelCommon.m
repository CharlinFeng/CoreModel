//
//  NSObject+CoreModelCommon.m
//  CoreModel
//
//  Created by muxi on 15/3/30.
//  Copyright (c) 2015年 muxi. All rights reserved.
//

#import "NSObject+CoreModelCommon.h"
#import "CoreModelConst.h"
#import "CoreFMDB.h"
#import "NSObject+Runtime.h"


@implementation NSObject (CoreModelCommon)


+(NSString *)fieldSql:(CoreProperty *)ivar{

    NSString *fieldName = ivar.name;
    
    NSString *fieldType = ivar.code;

    NSString *sqliteTye=[self sqliteType:fieldType];

    if([ivar.typeString isEqualToString:CoreNSArray]){
        
        if([self isBasicTypeInNSArray:[self statementForNSArrayProperties][ivar.name]]){
            sqliteTye = TEXT_TYPE;
        }
    }
    
    if([sqliteTye isEqualToString:EmptyString]){

        return EmptyString;
    }

    NSString *fieldSql=[NSString stringWithFormat:@"%@ %@,",fieldName,sqliteTye];

    return fieldSql;
}


+(BOOL)skipField:(CoreProperty *)ivar{

    NSArray *ignoredPropertyNames = nil;
    if ([[self class] respondsToSelector:@selector(ignoredPropertyNamesForSqlTransform)]) {
        ignoredPropertyNames = [[self class] ignoredPropertyNamesForSqlTransform];
    }
    BOOL skip=ignoredPropertyNames!=nil && [ignoredPropertyNames containsObject:ivar.name];
    
    return skip;
}


+ (NSArray *)ignoredPropertyNamesForSqlTransform{return @[@"hash",@"superclass",@"description",@"debugDescription"];}


+(NSString *)sqliteType:(NSString *)fieldType{

    NSDictionary *map=@{
                        INTEGER_TYPE:@[CoreNSInteger,CoreNSUInteger,CoreEnum_int,CoreBOOL],
                        TEXT_TYPE:@[CoreNSString],
                        REAL_TYPE:@[CoreCGFloat],
                        BLOB_TYPE:@[CoreNSData]
                        };

    __block NSString *sqliteType=EmptyString;

    [map enumerateKeysAndObjectsUsingBlock:^(NSString *blockSqliteType, NSArray *blockFieldTypes, BOOL *stop) {

        [blockFieldTypes enumerateObjectsUsingBlock:^(NSString *typeStringConst, NSUInteger idx, BOOL *stop) {
            
            NSRange range = [typeStringConst rangeOfString:fieldType];
            
            if(range.length>0){
                sqliteType = blockSqliteType;
            }
        }];
    }];
    
    return sqliteType;
}


+(BOOL)checkTableExists{
    
    NSString *alias=@"tableCount";
    
    NSString *sql=[NSString stringWithFormat:@"SELECT COUNT(*) %@ FROM sqlite_master WHERE type='table' AND name='%@';",alias,[self modelName]];
    
    __block BOOL res=NO;
    
    [CoreFMDB executeQuery:sql queryResBlock:^(FMResultSet *set) {
        
        while ([set next]) {
            
            NSUInteger count = [[set stringForColumn:alias] integerValue];

            res=count==1;
        }
    }];

    return res;
}


+(void)checkUsage:(id)model{
    NSAssert([NSStringFromClass(self) isEqualToString:NSStringFromClass([model class])], @"错误：请使用模型%@所属类（而不是%@类）的静态方法来执行您的操作",NSStringFromClass([model class]),NSStringFromClass(self));
}


+(NSString *)deleteLastChar:(NSString *)str{
    if(str.length == 0) return @"";
    return [str substringToIndex:str.length - 1];
}


+(BOOL)isBasicTypeInNSArray:(NSString *)statement{
    
    return [NSArrayNorlMalTypes containsObject:statement];
}



+(NSString *)modelName{
    return [NSStringFromClass(self) componentsSeparatedByString:@"."].lastObject;
}


+(NSDictionary *)statementForNSArrayProperties{return nil;}


//-(NSString *)description{
//    
//    NSMutableString *strM = [NSMutableString stringWithString:[NSString stringWithFormat:@"[%@]<%p>: \r",NSStringFromClass([self class]), self]];
//    
//    [[self class] enumNSObjectProperties:^(CoreProperty *property, BOOL *stop) {
//        BOOL skip=[[self class] skipField:property];
//
//        if(!skip){
//            [strM appendFormat:@"      %@: %@, \r",property.name, [self valueForKeyPath:property.name]];
//        }
//    }];
//    
//    return [strM copy];
//}


/** 封装 */

+(void)enumNSObjectProperties:(void(^)(CoreProperty *property, BOOL *stop))properties{
    [self enumeratePropertiesUsingBlock:^(CoreProperty *p) {
        
        properties(p,NO);

    }];
}

@end
