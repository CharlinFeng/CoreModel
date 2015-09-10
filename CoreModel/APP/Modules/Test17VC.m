//
//  Test17VC.m
//  CoreModel
//
//  Created by 冯成林 on 15/9/9.
//  Copyright (c) 2015年 冯成林. All rights reserved.
//

#import "Test17VC.h"
#import "CoreHttp.h"
#import "NSObject+MJKeyValue.h"

@interface Test17VC ()

@end

@implementation Test17VC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *url = @"http://211.149.151.92/mytest/Test/test3";
    
    CoreSVPLoading(@"加载中", YES)
    
    [CoreHttp getUrl:url params:nil success:^(NSDictionary *dict) {
        
        Person *p = [Person objectWithKeyValues:dict[@"data"][@"dataData"][@"person"]];
        
        [Person save:p resBlock:^(BOOL res) {
            
            [self show:res];
        }];
        
    } errorBlock:nil];
}



@end
