//
//  CoreModel+Compare.m
//  CoreList
//
//  Created by 冯成林 on 15/9/18.
//  Copyright (c) 2015年 muxi. All rights reserved.
//

#import "CoreModel+Compare.h"
#import "NSArray+CoreModel.h"
#import "NSObject+MJKeyValue.h"

@implementation CoreModel (Compare)

+(void)compareArr1:(NSArray *)arr1 arr2:(NSArray *)arr2 resBlock:(void(^)(BOOL res))resBlock{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        if(arr1==nil && arr2==nil) {resBlock(YES);return;};
        if(arr1.count==0 && arr2.count==0) {resBlock(YES);return;};
        if(arr1==nil && arr2 != nil) {resBlock(NO);return;};
        if(arr1!=nil && arr2 == nil) {resBlock(NO);return;};
        if(arr1.count != arr2.count) {resBlock(NO);return;};
        
        if(![[[arr1.descSortedArray valueForKeyPath:@"hostID"] toString] isEqualToString:[[arr2.descSortedArray valueForKeyPath:@"hostID"] toString]]) resBlock(NO);return;
        
        __block BOOL res = YES;
        
        
        [arr1 enumerateObjectsUsingBlock:^(CoreModel *m1, NSUInteger idx, BOOL *stop1) {
            
            [arr2 enumerateObjectsUsingBlock:^(CoreModel *m2, NSUInteger idx, BOOL *stop2) {
                
                if(m1.hostID == m2.hostID){
                    
                    NSDictionary *dict1=[m1 keyValues];
                    NSDictionary *dict2=[m2 keyValues];
                    
                    BOOL compareRes = [dict1 isEqualToDictionary:dict2];
                    
                    if(!compareRes) {res = NO; *stop2=YES;*stop1=YES;};
                }
            }];
        }];
        
        resBlock(res);
    });
    
}

@end
