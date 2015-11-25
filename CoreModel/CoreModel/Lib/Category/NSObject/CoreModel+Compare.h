//
//  CoreModel+Compare.h
//  CoreList
//
//  Created by 冯成林 on 15/9/18.
//  Copyright (c) 2015年 muxi. All rights reserved.
//

#import "CoreModel.h"

@interface CoreModel (Compare)

+(void)compareArr1:(NSArray *)arr1 arr2:(NSArray *)arr2 resBlock:(void(^)(BOOL res))resBlock;

@end
