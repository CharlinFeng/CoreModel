//
//  Test5VC.m
//  CoreModel
//
//  Created by 冯成林 on 15/9/9.
//  Copyright (c) 2015年 冯成林. All rights reserved.
//

#import "Test5VC.h"

@interface Test5VC ()

@end

@implementation Test5VC



- (void)viewDidLoad {
    [super viewDidLoad];
    
    Person *p1 = [[Person alloc] init];
    p1.hostID = 2;
    p1.name = @"jack";
    p1.age = 25;
    p1.height = 180;
    
    Person *p2 = [[Person alloc] init];
    p2.hostID = 3;
    p2.name = @"jim";
    p2.age = 22;
    p2.height = 172;
    

    [Person inserts:@[p1,p2] resBlock:^(BOOL res) {
        [self show:res];
    }];
}


@end
