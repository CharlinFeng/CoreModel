//
//  NSObject+Insert.h
//  CoreModel
//
//  Created by muxi on 15/3/30.
//  Copyright (c) 2015年 muxi. All rights reserved.


#import <Foundation/Foundation.h>

@interface NSObject (Insert)


+(void)insert:(id)model resBlock:(void(^)(BOOL res))resBlock;


+(void)inserts:(NSArray *)models resBlock:(void(^)(BOOL res))resBlock;



@end
