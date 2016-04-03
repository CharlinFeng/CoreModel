//
//  Test17VC.m
//  CoreModel
//
//  Created by 冯成林 on 16/4/3.
//  Copyright © 2016年 冯成林. All rights reserved.
//

#import "Test17VC.h"

@implementation Test17VC



- (void)viewDidLoad {
    [super viewDidLoad];
    
    Person *person = [[Person alloc] init];
    person.name = @"冯成林";
    person.age = 28;
    person.height = 174.0;
    person.hostID = 100;
    
    __block NSInteger num = 0;
    
    for (NSUInteger i = 0; i< 100; i++) {
        
        [Person insert:person resBlock:^(BOOL res) {
            
            num++;
        }];
    }
    
}



@end
