//
//  Test6VC.m
//  CoreModel
//
//  Created by 冯成林 on 15/9/9.
//  Copyright (c) 2015年 冯成林. All rights reserved.
//

#import "Test6VC.h"

@interface Test6VC ()

@end

@implementation Test6VC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    Person *person = [[Person alloc] init];
    person.hostID = 1;
    person.name = @"Charlin Feng";
    person.age = 28;
    person.height = 173.5;
    
    
    [Person update:person resBlock:^(BOOL res) {
        [self show:res];
    }];
    
    
    
}



@end
