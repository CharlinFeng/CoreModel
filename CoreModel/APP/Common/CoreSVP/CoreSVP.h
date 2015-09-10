//
//  CoreSVP.h
//
//  Created by muxi on 14/10/22.
//  Copyright (c) 2014年 muxi. All rights reserved.
//  提示工具类



#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SVProgressHUD.h"

#define CoreSVPSuccess(msg) [CoreSVP showSVPWithType:CoreSVPTypeSuccess Msg:msg duration:1.5 allowEdit:NO beginBlock:nil completeBlock:nil];
#define CoreSVPError(msg) [CoreSVP showSVPWithType:CoreSVPTypeError Msg:msg duration:2.0 allowEdit:NO beginBlock:nil completeBlock:nil];
#define CoreSVPLoading(msg,allow) [CoreSVP showSVPWithType:CoreSVPTypeLoadingInterface Msg:msg duration:0 allowEdit:allow beginBlock:nil completeBlock:nil];





typedef enum {
    
    CoreSVPTypeNone = 0,                                                                    //默认无状态
    
    CoreSVPTypeCenterMsg,                                                                   //无图片普通提示，显示在屏幕正中间
    
    CoreSVPTypeBottomMsg,                                                                   //无图片普通提示，显示在屏幕下方，tabbar之上
    
    CoreSVPTypeInfo,                                                                        //Info
    
    CoreSVPTypeLoadingInterface,                                                            //Progress,可以互
    
    CoreSVPTypeError,                                                                       //error
    
    CoreSVPTypeSuccess                                                                      //success

}CoreSVPType;





@interface CoreSVP : NSObject




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
+(void)showSVPWithType:(CoreSVPType)type Msg:(NSString *)msg duration:(CGFloat)duration allowEdit:(BOOL)allowEdit beginBlock:(void(^)())beginBlock completeBlock:(void(^)())completeBlock;


/*
 *  进度
 */
+(void)showProgess:(CGFloat)progress Msg:(NSString *)msg maskType:(SVProgressHUDMaskType)maskType;




/**
 *  隐藏提示框
 */
+(void)dismiss;


@end







