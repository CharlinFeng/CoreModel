//
//  ViewController.m
//  CoreClass
//
//  Created by muxi on 15/3/18.
//  Copyright (c) 2015年 muxi. All rights reserved.
//

#import "ViewController.h"
#import "NSObject+MJProperty.h"
#import "MeauModel.h"
#import "MJProperty.h"
#import "NewsVC.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [MeauModel enumeratePropertiesWithBlock:^(MJProperty *property, BOOL *stop) {
        NSLog(@"%@",property.name);
    }];

    
}


- (IBAction)pageVC:(id)sender {
    
    NewsVC *newsVC = [[NewsVC alloc] init];
    
    [self.navigationController pushViewController:newsVC animated:YES];
}






@end
