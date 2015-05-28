//
//  NSObject+Contrast.h
//  BaseModel
//
//  Created by muxi on 15/3/31.
//  Copyright (c) 2015年 muxi. All rights reserved.
//

#import <Foundation/Foundation.h>


@class BaseModel;
@interface NSObject (Contrast)


/**
 *  扩展功能1：模型对比，检查两个模型从数据内容来讲是否是同是一样的，此功能是列表缓存更新的基础（级联对比）
 *
 *  @param model1 模型1：此模型必须是BaseModel或其子类
 *  @param model2 模型2：此模型必须是BaseModel或其子类
 *
 *  @return 对比结果
 */
+(BOOL)contrastModel1:(BaseModel *)model1 model2:(BaseModel *)model2;



/**
 *  扩展功能2：模型数组对比，检查两个数组内部所有模型从数据内容来讲是否是同是一样的，此功能是列表缓存更新的基础（级联对比）
 *
 *  @param models1 模型数据1
 *  @param models2 模型数组2
 *
 *  @return 对比结果
 */
+(BOOL)contrastModels1:(NSArray *)models1 models2:(NSArray *)models2;

@end
