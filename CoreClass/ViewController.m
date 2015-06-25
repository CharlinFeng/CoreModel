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
#import "BaseTextView.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    BaseTextView *textView = [[BaseTextView alloc] initWithFrame:CGRectMake(0, 64, 320, 100)];
    
    textView.placeholder = @"请输入您的意见...";
    
    textView.font = [UIFont systemFontOfSize:18];
    textView.layer.borderWidth = 1;
    
    [self.view addSubview:textView];

}


- (IBAction)pageVC:(id)sender {
    
}






@end
