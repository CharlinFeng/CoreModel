//
//  Test13VC.m
//  CoreModel
//
//  Created by 冯成林 on 15/9/9.
//  Copyright (c) 2015年 冯成林. All rights reserved.
//

#import "Test13VC.h"

@interface Test13VC ()

@end

@implementation Test13VC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    City *city = [[City alloc] init];
    city.hostID = 1;
    city.cityName = @"成都";
    city.spell = @"ChengDu";
    
    Person *p5 = [[Person alloc] init];
    p5.hostID=5;
    p5.name = @"张三";
    p5.city=city;
    [Person save:p5 resBlock:^(BOOL res) {

        [self show:res];
    }];
    
}




@end
