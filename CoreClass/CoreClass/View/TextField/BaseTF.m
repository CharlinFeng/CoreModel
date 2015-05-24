//
//  BaseTF.m
//  CoreClass
//
//  Created by 成林 on 15/5/24.
//  Copyright (c) 2015年 muxi. All rights reserved.
//

#import "BaseTF.h"

@interface BaseTF ()<UITextFieldDelegate>

@end

@implementation BaseTF

-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if(self){
        
        //视图初始化
        [self viewPrepare];
    }
    
    return self;
}



-(id)initWithCoder:(NSCoder *)aDecoder{
    
    self=[super initWithCoder:aDecoder];
    
    if(self){
        
        //视图初始化
        [self viewPrepare];
    }
    
    return self;
}


/*
 *  视图初始化
 */
-(void)viewPrepare{
    
    //显示删除按钮
    self.clearButtonMode=UITextFieldViewModeWhileEditing;
    
    //设置模式
    self.leftViewMode = UITextFieldViewModeAlways;
}



-(void)setLeftPadding:(CGFloat)leftPadding{
    
    if(_leftPadding == leftPadding) return;
    
    _leftPadding = leftPadding;
    
    if(leftPadding <= 0 ) return;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, leftPadding, 0)];
        
        self.leftView = leftView;
    });
}



-(void)setMaxCountNum:(NSUInteger)maxCountNum{
    
    if(_maxCountNum == maxCountNum) return;
    
    _maxCountNum = maxCountNum;
    
    if(self.delegate != nil) return;
    
    self.delegate = self;
}


/** 代理方法区 */
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    return textField.text.length < self.maxCountNum;
}





@end
