//
//  NSObject+Contrast.h
//  CoreModel
//
//  Created by muxi on 15/3/31.
//  Copyright (c) 2015年 muxi. All rights reserved.
//

#import <Foundation/Foundation.h>


@class CoreModel;
@interface NSObject (Contrast)


+(BOOL)contrastModel1:(CoreModel *)model1 model2:(CoreModel *)model2;

+(BOOL)contrastModels1:(NSArray *)models1 models2:(NSArray *)models2;

@end
