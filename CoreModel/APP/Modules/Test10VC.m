//
//  Test10VC.m
//  CoreModel
//
//  Created by 冯成林 on 15/9/9.
//  Copyright (c) 2015年 冯成林. All rights reserved.
//

#import "Test10VC.h"

@interface Test10VC ()

@end

@implementation Test10VC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [Person selectWhere:nil groupBy:nil orderBy:nil limit:nil selectResultsBlock:^(NSArray *selectResults) {
        
        NSString *msg = [NSString stringWithFormat:@"查到%@条记录",@(selectResults.count)];
        
        CoreSVPSuccess(msg)
        
        NSLog(@"%@",selectResults);
    }];
    
    
    
}


@end
