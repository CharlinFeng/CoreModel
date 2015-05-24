//
//  ViewController.m
//  CoreClass
//
//  Created by muxi on 15/3/18.
//  Copyright (c) 2015年 muxi. All rights reserved.
//

#import "ViewController.h"
#import "BaseTF.h"

@interface ViewController ()<UITextFieldDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    BaseTF *tf = [[BaseTF alloc] initWithFrame:CGRectMake(0, 20, 200, 30)];
    tf.borderStyle = UITextBorderStyleLine;
   
    tf.leftPadding = 20;
    
    tf.maxCountNum =5;
    
//    tf.delegate = self;
    
    [self.view addSubview:tf];
    
}


-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSLog(@"来了");
    return YES;
}

@end
