//
//  ViewController.m
//  CoreClass
//
//  Created by muxi on 15/3/18.
//  Copyright (c) 2015年 muxi. All rights reserved.
//

#import "ViewController.h"
#import "Student.h"
#import "NSObject+BaseModelCommon.h"
#import "MJProperty.h"
#import "MJType.h"



@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

//    [Student enumerateProperties:^(MJProperty *property, BOOL *stop) {
//        NSLog(@"%@-%@",property.name,property.type.code);
//    }];

    Pen *pen = [[Pen alloc] init];
    pen.hostID=1;
    pen.price = 10;
    
    Student *stu = [[Student alloc] init];
    stu.hostID=1;
    stu.name = @"张三";
    stu.pen = pen;
    
    [Student insert:stu];
}








@end
