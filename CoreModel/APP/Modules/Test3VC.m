//
//  Test3VC.m
//  CoreModel
//
//  Created by 冯成林 on 15/9/9.
//  Copyright (c) 2015年 冯成林. All rights reserved.
//

#import "Test3VC.h"

@interface Test3VC ()

@end

@implementation Test3VC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    Person *person = [[Person alloc] init];
    person.name = @"冯成林";
    person.age = 28;
    person.height = 174.0;
    
    [Person insert:person resBlock:^(BOOL res) {
        
        [self show:res];
    }];
    
}


@end
