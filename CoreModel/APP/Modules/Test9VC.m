//
//  Test9VC.m
//  CoreModel
//
//  Created by 冯成林 on 15/9/9.
//  Copyright (c) 2015年 冯成林. All rights reserved.
//

#import "Test9VC.h"

@interface Test9VC ()

@end

@implementation Test9VC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [Person deleteWhere:@"age >= 40" resBlock:^(BOOL res) {
        [self show:res];
    }];
    
}



@end
