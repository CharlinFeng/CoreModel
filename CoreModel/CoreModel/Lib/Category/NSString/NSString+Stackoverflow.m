//
//  NSString+Stackoverflow.m
//  CoreModel
//
//  Created by 成林 on 15/3/29.
//  Copyright (c) 2015年 muxi. All rights reserved.
//

#import "NSString+Stackoverflow.h"
#import "CoreModelConst.h"

@implementation NSString (Stackoverflow)


-(NSArray *)toArray:(BOOL)isString{
    
    NSString *seperator = @",";
    
    if(!isString) seperator = SymbolString;
    
    NSArray *arr = [self componentsSeparatedByString:seperator];
    
    if(isString) return arr;
    
    NSMutableArray *arrM = [NSMutableArray arrayWithCapacity:arr.count];

    if(arr == nil || arr.count == 0) return nil;
    
    [arr enumerateObjectsUsingBlock:^(NSString *str, NSUInteger idx, BOOL *stop) {
        
        NSData *data = [[NSData alloc] initWithBase64EncodedString:str options:NSDataBase64DecodingIgnoreUnknownCharacters];
        
        [arrM addObject:data];
    }];
    
    return arrM;
}





-(unsigned long long)unsignedLongLongValue{
    
    return self.longLongValue;
}


@end
