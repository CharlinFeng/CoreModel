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
#import "User.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    //测试用户模型
    [self studentTest];

}


/** 测试用户模型 */
-(void)userTest{
    
    User *user = [[User alloc] init];
    
    //模拟服务器数据变更
    user.hostID = 1;
    user.userName = @"张三";
    user.level = 30;
    user.accountMoney = 80.0f;
    user.isVip = NO;
    
    
    

    
    
    
    
}


-(void)studentTest{
    

    Pen *pen = [[Pen alloc] init];
    pen.hostID=1;
    pen.price = 10;
    pen.usageYear = 3;
    pen.brandName = @"国产好铅笔";
    
    Student *stu = [[Student alloc] init];
    stu.hostID=1;
    stu.name = @"冯成林";
    stu.pen = pen;
    stu.money = 8866;
    
    
}







@end
