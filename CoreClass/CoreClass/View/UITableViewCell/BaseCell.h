//
//  BaseCell.h
//  4s
//
//  Created by muxi on 15/3/11.
//  Copyright (c) 2015年 muxi. All rights reserved.
//  cell基类




#import <UIKit/UIKit.h>
#import "BaseModel.h"



@interface BaseCell : UITableViewCell






/**
 *  indexPath
 */
@property (nonatomic,strong) NSIndexPath *indexPath;



@property (nonatomic,strong) BaseModel *model;




/**
 *  cell实例：必须从xib创建
 *
 *  @param tableView tableView
 *
 *  @return 实例
 */
+(instancetype)cellFromTableView:(UITableView *)tableView;


/**
 *  填充数据
 */
-(void)dataFillUseModel;

@end
