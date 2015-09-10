//
//  Person.h
//  CoreModel
//
//  Created by 冯成林 on 15/9/9.
//  Copyright (c) 2015年 冯成林. All rights reserved.
//

#import "CoreModel.h"
#import "City.h"
#import <UIKit/UIKit.h>

@interface Person : CoreModel

@property (nonatomic,copy) NSString *name;

@property (nonatomic,assign) NSInteger age;

@property (nonatomic,assign) CGFloat height;

@property (nonatomic,strong) NSData *photoData;

@property (nonatomic,strong) City *city;

@property (nonatomic,strong) Person *teacher;

@end
