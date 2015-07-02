//
//  ToolNetWorkView.m
//  Car
//
//  Created by muxi on 15/2/2.
//  Copyright (c) 2015年 muxi. All rights reserved.
//

#import "ToolNetWorkView.h"
#import "ToolNetWorkSolveVC.h"
#import "NSObject+BaseModelCommon.h"

@interface ToolNetWorkView ()

@property (nonatomic,strong) UIViewController *vc;

@end


@implementation ToolNetWorkView


+(instancetype)netWorkViewWithViewController:(UIViewController *)vc{
    
    ToolNetWorkView *toolNetWorkView = [[[NSBundle mainBundle] loadNibNamed:[self modelName] owner:nil options:nil] firstObject];
    toolNetWorkView.vc=vc;
    
    return toolNetWorkView;
}

- (IBAction)tap:(UITapGestureRecognizer *)sender {
    
    ToolNetWorkSolveVC *netWorkSolveVC=[[ToolNetWorkSolveVC alloc] init];
    UINavigationController *navVC=(UINavigationController *)self.vc;
    [navVC pushViewController:netWorkSolveVC animated:YES];
    
    
}

#pragma mark  显示一个网络状态提示框
+(void)showNetWordNotiInViewController:(UIViewController *)vc y:(CGFloat)y{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        CGRect frame=CGRectMake(0, y, vc.view.bounds.size.width, 44.0f);
        
        ToolNetWorkView *netWorkView=[self checkNetWorkInViewController:vc needRemove:NO];
        
        if(netWorkView){
            
            [UIView animateWithDuration:.1f animations:^{
                netWorkView.frame=frame;
            }];
            
            return;
        }
        
        netWorkView=[ToolNetWorkView netWorkViewWithViewController:vc];
        netWorkView.frame=frame;
        [vc.view addSubview:netWorkView];


        netWorkView.alpha=.0f;
        [UIView animateWithDuration:.25f animations:^{
            netWorkView.alpha=1.0f;
        }];
        
    });
}


#pragma mark  隐藏网络状态提示框
+(void)dismissNetWordNotiInViewController:(UIViewController *)vc{
    
    [self checkNetWorkInViewController:vc needRemove:YES];
}


+(ToolNetWorkView *)checkNetWorkInViewController:(UIViewController *)vc needRemove:(BOOL)needRemove{
    
    UIView *view=vc.view;
    
    ToolNetWorkView *netWorkView=nil;
    
    
    if(view==nil) return nil;
    if(view.subviews.count==0) return nil;
    
    for (UIView *v in view.subviews) {
        if([v isKindOfClass:self]){
            
            if(needRemove){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [UIView animateWithDuration:.25f animations:^{
                        v.alpha=.0f;
                    } completion:^(BOOL finished) {
                        [v removeFromSuperview];
                    }];
                });
            }else{
                netWorkView=(ToolNetWorkView *)v;
            }
           
            break;
        }
    }
    
    return netWorkView;
}

@end
