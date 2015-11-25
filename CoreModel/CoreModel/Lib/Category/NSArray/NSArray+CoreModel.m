//
//  NSArray+CoreModel.m
//  CoreClass
//
//  Created by 成林 on 15/9/1.
//  Copyright (c) 2015年 muxi. All rights reserved.
//

#import "NSArray+CoreModel.h"
#import "CoreModelConst.h"
#import "CoreModel.h"

@implementation NSArray (CoreModel)

-(NSString *)toString{
    
    __block NSMutableString *strM = [NSMutableString string];
    
    __block NSInteger length = 0;
    
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        if([obj isKindOfClass:[NSString class]]){
            
            if(length == 0) length = 1;
            
            [strM appendFormat:@"%@,",obj];
            
        }else if ([obj isKindOfClass:[NSData class]]){
            
            if(length == 0) length = SymbolString.length;
            
            [strM appendFormat:@"%@%@",[(NSData *)obj base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength],SymbolString];
        }
        
        
        
    }];

    return [[strM substringToIndex:strM.length-length] copy];
}

-(NSArray *)descSortedArray{
    
    NSArray *sortedArray = [self sortedArrayUsingComparator:^NSComparisonResult(CoreModel *m1, CoreModel *m2) {
        
        if (m1.hostID<m2.hostID) return NSOrderedDescending;
        if (m1.hostID>m2.hostID) return NSOrderedAscending;
        return NSOrderedSame;
    }];
    
    return sortedArray;
}



@end
