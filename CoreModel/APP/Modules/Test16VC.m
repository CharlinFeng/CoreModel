//
//  Test16VC.m
//  CoreModel
//
//  Created by 冯成林 on 15/9/9.
//  Copyright (c) 2015年 冯成林. All rights reserved.
//

#import "Test16VC.h"

@interface Test16VC ()

@end

@implementation Test16VC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    Pen *pen1=[[Pen alloc] init];
    pen1.hostID=1;
    pen1.color = @"red";
    pen1.price = 12.5;
    Pen *pen2=[[Pen alloc] init];
    pen2.hostID=2;
    pen2.color = @"blue";
    pen2.price = 9.8;
    Person *p = [[Person alloc] init];
    p.hostID = 8;
    p.name = @"静香";
    p.pens=@[pen1,pen2];
    
    
    [Person save:p resBlock:^(BOOL res) {
        [self show:res];
    }];
}


@end
