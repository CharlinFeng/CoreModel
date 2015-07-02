//
//  Student.h
//  CoreClass
//
//  Created by 冯成林 on 15/7/2.
//  Copyright (c) 2015年 muxi. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "BaseModel.h"
#import "Pen.h"

typedef enum{
    
    StudentTypeGood=0,
    
    StudentTypeBad
    
}StudentType;


@interface Student : BaseModel

@property (nonatomic,copy) NSString *name;

@property (nonatomic,assign) NSInteger childNum;

@property (nonatomic,assign) float height;

@property (nonatomic,assign) double earn;

@property (nonatomic,assign) BOOL isMan;

@property (nonatomic,assign) StudentType type;

@property (nonatomic,assign) NSUInteger age;

@property (nonatomic,strong) Pen *pen;

@property (nonatomic,assign) int count;

@property (nonatomic,assign) CGFloat money;


@end
