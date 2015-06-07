//
//  HomeVC.m
//  CoreClass
//
//  Created by 冯成林 on 15/5/28.
//  Copyright (c) 2015年 muxi. All rights reserved.
//

#import "HomeVC.h"
#import "MeauModel.h"


@interface HomeVC ()

@property (nonatomic,strong) NSArray *meauModels;

@end

@implementation HomeVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //菜单数据请求
    [self meauPrepare];
}



/** 菜单数据请求 */
-(void)meauPrepare{
    
    NSDictionary *params = @{@"location":@"Home"};
    
    [MeauModel selectWithParams:params userInfo:nil beginBlock:^(BOOL isNetWorkRequest,BOOL needHUD) {
        if(needHUD){
            NSLog(@"需要HUD");
        }else{
            NSLog(@"不需要HUD");
        }
    } successBlock:^(NSArray *models, BaseModelDataSourceType source,NSDictionary *userInfo) {

        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            self.meauModels = models;
            
            [self.tableView reloadData];
            
        });
        
        NSLog(@"请求成功");
        
    } errorBlock:^(NSString *errorResult,NSDictionary *userInfo) {
        
        NSLog(@"请求出错");
    }];
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.meauModels.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *rid = @"rid";
    
    UITableViewCell * cell =[tableView dequeueReusableCellWithIdentifier:rid];
    
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:rid];
    }
    
    //取出模型
    MeauModel *meauModel = self.meauModels[indexPath.row];
    
    cell.textLabel.text = meauModel.name;
    cell.detailTextLabel.text = meauModel.image;
    
    return cell;
}





@end
