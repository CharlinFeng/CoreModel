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
#import "FBShimmeringView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //纯展示，非框架
    [self show];
    
    //测试用户模型
    [self studentTest];

}


/** 测试用户模型 */
-(void)userTest{
    
//    User *user = [[User alloc] init];
//    
//    //模拟服务器数据变更
//    user.hostID = 1;
//    user.userName = @"张三";
//    user.level = 30;
//    user.accountMoney = 80.0f;
//    user.isVip = NO;
//    
//    [User save:user];
    
//    NSArray *users = [User selectWhere:@"userName='张三'" groupBy:nil orderBy:nil limit:nil];
//    
//        NSArray *users2 = [User selectWhere:@"hostID<10'" groupBy:@"userName" orderBy:@"id" limit:@"0,5"];
//    
//    NSLog(@"%@",users);
//    
    
    
    
    
}


-(void)studentTest{
    

//    Pen *pen = [[Pen alloc] init];
//    pen.hostID=1;
//    pen.price = 10;
//    pen.usageYear = 3;
//    pen.brandName = @"国产好铅笔";
//    
//    Student *stu = [[Student alloc] init];
//    stu.hostID=1;
//    stu.name = @"冯成林";
//    stu.pen = pen;
//    stu.money = 8866;
//    
//    [Student save:stu];
    
    
    //查询
    NSArray *students = [Student selectWhere:nil groupBy:nil orderBy:nil limit:nil];
    
    NSLog(@"%@",students);
    
}




-(void)show{
    
    CGFloat wh = 136;
    
    CGFloat x = (320 - wh) * .5f;
    CGFloat y =100;
    
    FBShimmeringView *sv = [[FBShimmeringView alloc] initWithFrame:CGRectMake(x, y, wh, wh)];
    
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:sv.bounds];
    imageV.image = [UIImage imageNamed:@"mj"];
    sv.contentView = imageV;
    sv.shimmering = YES;
    [self.view addSubview:sv];
    
    
}


@end
