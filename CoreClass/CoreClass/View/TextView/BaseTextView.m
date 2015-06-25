//
//  BaseTextView.m
//  CoreClass
//
//  Created by 冯成林 on 15/6/25.
//  Copyright (c) 2015年 muxi. All rights reserved.
//

#import "BaseTextView.h"

@implementation BaseTextView

-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if(self){
        
        //视图准备
        [self viewPrepare];
    }
    
    return self;
}


-(id)initWithCoder:(NSCoder *)aDecoder{
    
    self=[super initWithCoder:aDecoder];
    
    if(self){
        
        //视图准备
        [self viewPrepare];
    }
    
    return self;
}



/*
 *  视图准备
 */
-(void)viewPrepare{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setNeedsDisplay) name:UITextViewTextDidChangeNotification object:self];
    
}



-(void)drawRect:(CGRect)rect{
    
    if(self.hasText) return;
    if(self.placeholder == nil) return;
    
    CGFloat marginX = 5;
    CGFloat marginY = 7;
    
    CGFloat width = rect.size.width - marginX * 2;
    CGFloat height = rect.size.height - 2 * marginY;
    
    UIFont *font = self.font?self.font:[UIFont systemFontOfSize:14];
    
    NSDictionary * attr = @{NSFontAttributeName:font,NSForegroundColorAttributeName:[UIColor lightGrayColor]};
    
    [self.placeholder drawInRect:CGRectMake(marginX, marginY, width, height) withAttributes:attr];
    
}





-(void)setPlaceholder:(NSString *)placeholder{
    
    _placeholder = placeholder;
    
    [self setNeedsDisplay];
}

-(void)setFont:(UIFont *)font{
    
    [super setFont:font];
    
    [self setNeedsDisplay];
}


-(void)setText:(NSString *)text{
    
    [super setText:text];
    
    [self setNeedsDisplay];
}




@end
