//
//  BaseNavigationComtroller.h
//  通用框架
//
//  Created by muxi on 14-9-12.
//  Copyright (c) 2014年 muxi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreNavigationController.h"



@interface BaseNav : CoreNavigationController

@property (nonatomic,strong) NSArray *hideNetworkBarControllerArray;                        //此数组内的控制器（名）不会显示无网络提示框


@end
