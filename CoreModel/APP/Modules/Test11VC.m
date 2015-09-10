//
//  Test11VC.m
//  CoreModel
//
//  Created by 冯成林 on 15/9/9.
//  Copyright (c) 2015年 冯成林. All rights reserved.
//

#import "Test11VC.h"

@interface Test11VC ()

@end

@implementation Test11VC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [Person truncateTable:^(BOOL res) {
        [self show:res];
    }];
    
    
}

@end
