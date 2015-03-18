//
//  BaseNavigationComtroller.m
//  通用框架
//
//  Created by muxi on 14-9-12.
//  Copyright (c) 2014年 muxi. All rights reserved.
//

#import "BaseNav.h"
#import "ToolNetWorkView.h"
#import "ToolNetWorkSolveVC.h"
#import "CoreStatus.h"
#import "UIBarButtonItem+Appearance.h"


@interface BaseNav ()

@property (nonatomic,strong) Reachability *readchability;

@property (nonatomic,strong) NSArray *hideNetworkBarControllerArrayFull;                                //这个是最终的读取数组

@end

@implementation BaseNav


-(void)viewDidLoad{
    
    [super viewDidLoad];
    
    //监听网络状态
    [self beginReachabilityNoti];
    
    //背景白色
    self.view.backgroundColor=[UIColor whiteColor];
}


#pragma mark  监听网络状态
-(void)beginReachabilityNoti{
    
    Reachability *readchability=[Reachability reachabilityForInternetConnection];
    
    //记录
    self.readchability=readchability;
    
    //开始通知
    [readchability startNotifier];
    
    //监听通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netWorkStatusChange) name:kReachabilityChangedNotification object:readchability];

}



-(void)netWorkStatusChange{
    
    if([self needHideNetWorkBarWithVC:self.topViewController]){
        
        //这里dismiss的原因在于可能由其他页面pop回来的时候，如果直接return会导致bar显示出来。
        [self dismissNetWorkBar];
        return;
    }
    
    if([CoreStatus isNETWORKEnable]){

        [self dismissNetWorkBar];
    }else{

        [self showNetWorkBar];
    }
}


-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}




-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    

    viewController.navigationItem.leftBarButtonItem=[UIBarButtonItem itemWithTarget:self action:@selector(popAction) image:@"NetWork.bundle/navBack" highImage:@"NetWork.bundle/navBackHL"];
    
    [super pushViewController:viewController animated:animated];

    [self netWorkStatusChange];
}


-(UIViewController *)popViewControllerAnimated:(BOOL)animated{

    UIViewController *vc = [super popViewControllerAnimated:animated];
    
    //再次检查当前控制器是否需要显示网络状态提示视图
    [self netWorkStatusChange];

    return vc;
}

-(void)popAction{
    [self popViewControllerAnimated:YES];
}



#pragma mark  屏幕旋转
-(NSUInteger)supportedInterfaceOrientations{
    return self.topViewController.supportedInterfaceOrientations;
}


-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];

    [self netWorkStatusChange];
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];

    [self netWorkStatusChange];
}


#pragma mark  显示网络状态提示条
-(void)showNetWorkBar{
    
    CGFloat y = self.navigationBar.frame.size.height + 20.0f;
    
    [ToolNetWorkView showNetWordNotiInViewController:self y:y];
}

#pragma mark  隐藏网络状态提示条
-(void)dismissNetWorkBar{
    [ToolNetWorkView dismissNetWordNotiInViewController:self];
}



-(BOOL)needHideNetWorkBarWithVC:(UIViewController *)vc{
    NSString *vcStr=NSStringFromClass(vc.class);
    BOOL res = [self.hideNetworkBarControllerArrayFull containsObject:vcStr];

    return res;
}

-(NSArray *)hideNetworkBarControllerArrayFull{
    
    if(!_hideNetworkBarControllerArrayFull){
        NSMutableArray *arrayM=[NSMutableArray arrayWithArray:self.hideNetworkBarControllerArray];
        [arrayM addObject:NSStringFromClass([ToolNetWorkSolveVC class])];
        _hideNetworkBarControllerArrayFull=[arrayM copy];
    }
    return _hideNetworkBarControllerArrayFull;
}


@end
