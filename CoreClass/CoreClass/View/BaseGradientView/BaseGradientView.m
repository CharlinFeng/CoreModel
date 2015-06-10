//
//  GradientView.m
//  网络
//
//  Created by 沐汐 on 14-10-8.
//  Copyright (c) 2014年 沐汐. All rights reserved.
//

#import "BaseGradientView.h"

@interface BaseGradientView ()


@property (nonatomic,strong) UIColor *beginColor;                                       //起点颜色

@property (nonatomic,strong) UIColor *endColor;                                         //终点颜色

@property (nonatomic,assign) CGPoint startPoint;                                        //渐变起点

@property (nonatomic,assign) CGPoint endPoint;                                          //渐变终点


@end


@implementation BaseGradientView

-(void)drawRect:(CGRect)rect{
    
    [super drawRect:rect];
    
    if(self.beginColor==nil || self.endColor==nil) return;
    
    //获取上下文
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    
    //保存当前状态
    CGContextSaveGState(currentContext);
    
    //获取绘图空间
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    //开始颜色
    CGFloat *startColorComponents =(CGFloat *)CGColorGetComponents([self.beginColor CGColor]);
    
    //结束颜色
    CGFloat *endColorComponents =(CGFloat *)CGColorGetComponents([self.endColor CGColor]);
    
    CGFloat colorComponents[8] = {startColorComponents[0], startColorComponents[1],
        startColorComponents[2], startColorComponents[3],
        endColorComponents[0], endColorComponents[1],
        endColorComponents[2], endColorComponents[3]};
    CGFloat colorIndices[2] = {
        0.0f,//对应起点颜色位置
        1.0f,//对应终点颜色位置
    };
    
    CGGradientRef gradient = CGGradientCreateWithColorComponents (colorSpace,(const CGFloat *)&colorComponents, (const CGFloat *)&colorIndices,2);
    
    CGColorSpaceRelease(colorSpace);
    
    CGPoint startPoint, endPoint;
    //颜色沿着两点确定的直线变化
    startPoint = self.startPoint;
    endPoint = self.endPoint;
    
    CGContextDrawLinearGradient (currentContext, gradient,startPoint,endPoint, kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    CGGradientRelease(gradient);
    CGContextRestoreGState(currentContext);
    
}




#pragma mark  设置渐变色
-(void)setGradientWithType:(GradientViewType)type beginColor:(UIColor *)beginColor endColor:(UIColor *)endColor{
    
    CGRect frame=self.frame;
    
    //记录渐变方向
    if(type==GradientViewTypeHorizontal){       //水平方向
        
        //确定起点
        self.startPoint=CGPointMake(0,frame.size.height * 0.5f);
        
        //确定终点
        self.endPoint=CGPointMake(frame.size.width, frame.size.height * 0.5f);
        
    }else{
        
        //确定起点
        self.startPoint=CGPointMake(frame.size.width*0.5f,0);
        
        //确定终点
        self.endPoint=CGPointMake(frame.size.width*0.5f, frame.size.height);
        
    }
    
    //记录渐变颜色
    //记录起点颜色
    self.beginColor=beginColor;
    
    //记录终点颜色
    self.endColor=endColor;
    
    //强制重绘
    [self setNeedsDisplay];
}



@end
