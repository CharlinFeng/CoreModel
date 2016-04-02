//
//  Test4VC.m
//  CoreModel
//
//  Created by 冯成林 on 15/9/9.
//  Copyright (c) 2015年 冯成林. All rights reserved.
//

#import "Test4VC.h"

@interface Test4VC ()

@end

@implementation Test4VC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    Person *person = [[Person alloc] init];
    person.hostID = 12;
    person.name = @"冯成林";
    person.age = 28;
    person.height = 174.0;
    
    /** Insert */
    [Person insert:person resBlock:^(BOOL res) {

        [self show:res];
    }];
    
}


@end
