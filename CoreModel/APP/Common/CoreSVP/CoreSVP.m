//
//  CoreSVP.m
//  新浪微博2014MJ版
//
//  Created by muxi on 14/10/22.
//  Copyright (c) 2014年 muxi. All rights reserved.
//

#import "CoreSVP.h"

static CoreSVPType SVPtype = CoreSVPTypeNone;

#define rgba(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]

@interface CoreSVP ()



@end



@implementation CoreSVP


/**
 *  展示提示框
 *
 *  @param type          类型
 *  @param msg           文字
 *  @param duration      时间（当type=CoreSVPTypeLoadingInterface时无效）
 *  @param allowEdit     否允许编辑
 *  @param beginBlock    提示开始时的回调
 *  @param completeBlock 提示结束时的回调
 */
+(void)showSVPWithType:(CoreSVPType)type Msg:(NSString *)msg duration:(CGFloat)duration allowEdit:(BOOL)allowEdit beginBlock:(void(^)())beginBlock completeBlock:(void(^)())completeBlock{
    
    if(CoreSVPTypeLoadingInterface != type && CoreSVPTypeLoadingInterface == SVPtype){
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.8f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            SVPtype = type;
            
            [self showSVPWithType:type Msg:msg duration:duration allowEdit:allowEdit beginBlock:beginBlock completeBlock:completeBlock];
        });
        
        return;
    }
    
    //记录状态
    SVPtype = type;

    
    //无状态直接返回
    if (CoreSVPTypeNone == type) return;
    
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        //基本配置
        [self hudSetting];

        if(CoreSVPTypeBottomMsg == type) [SVProgressHUD setOffsetFromCenter:UIOffsetMake(0, [UIScreen mainScreen].applicationFrame.size.height * .5f-49.0f)];
        
        
        //设置时间
        [SVProgressHUD setDuration:duration];
        
        //错误图片
        [SVProgressHUD setErrorImage:[UIImage imageNamed:@"SVP.bundle/red"]];
        
        //成功图片
        [SVProgressHUD setSuccessImage:[UIImage imageNamed:@"SVP.bundle/green"]];
        
        //警告图片
        [SVProgressHUD setInfoImage:[UIImage imageNamed:@"SVP.bundle/yellow"]];
        
        SVProgressHUDMaskType maskType=allowEdit?SVProgressHUDMaskTypeNone:SVProgressHUDMaskTypeClear;
        [SVProgressHUD setDefaultMaskType:maskType];
        
        //开始回调
        if(beginBlock != nil) beginBlock();
        
        if(CoreSVPTypeLoadingInterface != type) [SVProgressHUD setCompleteBlock:completeBlock];

        switch (type) {
                
            case CoreSVPTypeCenterMsg:
            case CoreSVPTypeBottomMsg:
                [SVProgressHUD showImage:nil status:msg];
                break;
                
            case CoreSVPTypeInfo:
                [SVProgressHUD showInfoWithStatus:msg];
                break;
                
            case CoreSVPTypeLoadingInterface:
                [SVProgressHUD showWithStatus:msg];
                break;
                
            case CoreSVPTypeError:
                [SVProgressHUD showErrorWithStatus:msg];
                break;
                
            case CoreSVPTypeSuccess:
                [SVProgressHUD showSuccessWithStatus:msg];
                break;
                
            default:
                break;
        }
       
    });
}


/*
 *  进度
 */
+(void)showProgess:(CGFloat)progress Msg:(NSString *)msg maskType:(SVProgressHUDMaskType)maskType{
    
    if (progress<=0) progress = 0;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        //基本配置
        [self hudSetting];
        
        [SVProgressHUD showProgress:progress status:msg maskType:maskType];
        
        if(progress>=1) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self dismiss];
            });
        }
    });
}


/*
 *  基本配置
 */
+(void)hudSetting{
    
    //设置背景色
    [SVProgressHUD setBackgroundColor:rgba(92,93,94,1)];
    
    //文字颜色
    [SVProgressHUD setForegroundColor:rgba(241, 241, 241, 1)];
    
    //字体大小
    [SVProgressHUD setFont:[UIFont systemFontOfSize:16.0f]];
    
    //设置线宽
    [SVProgressHUD setRingThickness:2.f];
    
    //边角
    [SVProgressHUD setCornerRadius:2.0f];
}


/**
 *  隐藏提示框
 */
+(void)dismiss{

    dispatch_async(dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}

@end
