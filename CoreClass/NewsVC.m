//
//  NewsVC.m
//  CoreClass
//
//  Created by 冯成林 on 15/6/5.
//  Copyright (c) 2015年 muxi. All rights reserved.
//

#import "NewsVC.h"
#import "NewsModel.h"


@interface NewsVC ()

@end

@implementation NewsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
}


- (IBAction)page1:(id)sender {

    [self getDataListWithPage:1];
}


- (IBAction)page2:(id)sender {
    
    [self getDataListWithPage:2];
}


- (IBAction)page3:(id)sender {
    
    [self getDataListWithPage:3];
}


- (IBAction)page4:(id)sender {
    
    [self getDataListWithPage:4];
}


- (IBAction)page5:(id)sender {
    
    [self getDataListWithPage:5];
}



-(void)getDataListWithPage:(NSUInteger)currentPage{
    
    NSDictionary *params = @{[NewsModel baseModel_PageKey] : @(currentPage)};
    
    [NewsModel selectWithParams:params userInfo:nil beginBlock:nil successBlock:^(NSArray *models, BaseModelDataSourceType source,NSDictionary *userInfo) {
        
        NSLog(@"请求成功");
        
    } errorBlock:^(NSString *errorResult,NSDictionary *userInfo) {
        
        NSLog(@"请求失败");
        
    }];
}














@end
