//
//  Test14VC.m
//  CoreModel
//
//  Created by 冯成林 on 15/9/9.
//  Copyright (c) 2015年 冯成林. All rights reserved.
//

#import "Test14VC.h"

@interface Test14VC ()

@end

@implementation Test14VC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    Person *p = [[Person alloc] init];
    p.hostID=6;
    p.name = @"冯成林";
    p.tags = @[@"工作狂",@"电影迷",@"成都范",@"梦想青年"];
    
    [Person insert:p resBlock:^(BOOL res) {
        [self show:res];
    }];
    
}



@end
