//
//  CommonVC.m
//  CoreModel
//
//  Created by 冯成林 on 15/9/9.
//  Copyright (c) 2015年 冯成林. All rights reserved.
//

#import "CommonVC.h"

@interface CommonVC ()

@end

@implementation CommonVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    
}



-(void)show:(BOOL)res{
    
    if(res){
        
        CoreSVPSuccess(@"操作成功")
        
    }else{
        
        CoreSVPError(@"操作失败")
    }
 
}

@end
