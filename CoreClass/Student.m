//
//  Student.m
//  CoreClass
//
//  Created by 冯成林 on 15/7/2.
//  Copyright (c) 2015年 muxi. All rights reserved.
//

#import "Student.h"

@implementation Student

//@property (nonatomic,copy) NSString *name;
//
//@property (nonatomic,assign) NSInteger childNum;
//
//@property (nonatomic,assign) float height;
//
//@property (nonatomic,assign) double earn;
//
//@property (nonatomic,assign) BOOL isMan;
//
//@property (nonatomic,assign) StudentType type;
//
//@property (nonatomic,assign) NSUInteger age;
//
//@property (nonatomic,strong) Pen *pen;
//
//@property (nonatomic,assign) int count;
//
//@property (nonatomic,assign) CGFloat money;

-(NSString *)description{
    return [NSString stringWithFormat:@"name=%@,childNum=%@,height=%@,earn=%@,isMan=%@,type=%@,age=%@,\r\r\r pen=%@ \r\r\r\r,count=%@,money=%@,",self.name,@(self.childNum),@(self.height),@(self.earn),@(self.isMan),@(self.type),@(self.age),self.pen,@(self.count),@(self.money)];
}

@end
