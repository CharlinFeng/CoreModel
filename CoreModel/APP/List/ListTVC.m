//
//  ListTableView.m
//  CoreModel
//
//  Created by 冯成林 on 15/9/9.
//  Copyright (c) 2015年 冯成林. All rights reserved.
//

#import "ListTVC.h"
#import "Test2VC.h"
#import "Test3VC.h"
#import "Test4VC.h"
#import "Test5VC.h"
#import "Test6VC.h"
#import "Test7VC.h"
#import "Test8VC.h"
#import "Test9VC.h"
#import "Test10VC.h"
#import "Test11VC.h"
#import "Test12VC.h"
#import "Test13VC.h"
#import "Test14VC.h"
#import "Test15VC.h"
#import "Test16VC.h"
#import "Test17VC.h"





@interface ListTVC ()

@property (nonatomic,strong) NSArray *dataList;


@end

@implementation ListTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"成都时点软件原创出品";
    
    self.dataList = @[
                      
                      @[[Test2VC class],@"子线程全自动创表"],
                      @[[Test3VC class],@"无hostID自动处理"],
                      @[[Test4VC class],@"基本模型 + 单条数据插入"],
                      @[[Test5VC class],@"基本模型 + 批量数据插入"],
                      @[[Test6VC class],@"基本模型 + 单条数据修改"],
                      @[[Test7VC class],@"基本模型 + 批量数据修改"],
                      @[[Test8VC class],@"基本模型 + 单条/批量/模糊保存"],
                      @[[Test9VC class],@"基本模型 + 条件删除"],
                      @[[Test10VC class],@"基本模型 + 条件查询"],
                      @[[Test11VC class],@"基本模型 + 清空所有表记录"],
                      @[[Test12VC class],@"NSData的支持"],
                      @[[Test13VC class],@"属性为单模型级联：数据插入"],
                      @[[Test14VC class],@"数组支持：基本类型数组"],
                      @[[Test15VC class],@"数组支持：NSData类型数组"],
                      @[[Test16VC class],@"数组支持：自定义模型数组"],
                      @[[Test17VC class],@"大数量调整并发"],
                    ];
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataList.count;
    
    
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *ListTVCRid = @"ListTVC";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ListTVCRid];
    
    if(cell == nil) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ListTVCRid];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@. %@",@(indexPath.row+1),((NSArray *)self.dataList[indexPath.row])[1]];
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    Class Cls = ((NSArray *)self.dataList[indexPath.row])[0];
    
    UIViewController *vc = [[Cls alloc] init];
    vc.title = ((NSArray *)self.dataList[indexPath.row])[1];
    
    [self.navigationController pushViewController:vc animated:YES];
}









@end
