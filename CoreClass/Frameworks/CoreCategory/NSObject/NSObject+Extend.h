//
//  NSObject+Address.h
//  网易彩票2014MJ版
//
//  Created by muxi on 14-9-23.
//  Copyright (c) 2014年 沐汐. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

//动态Get方法
#define categoryPropertyGet(property) return objc_getAssociatedObject(self,@#property);
//动态Set方法
#define categoryPropertySet(property) objc_setAssociatedObject(self,@#property, property, OBJC_ASSOCIATION_RETAIN_NONATOMIC);



@interface NSObject (Extend)










@end
