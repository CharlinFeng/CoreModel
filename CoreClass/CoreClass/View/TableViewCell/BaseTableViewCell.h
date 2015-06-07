//
//  BaseCell.h
//  4s
//
//  Created by muxi on 15/3/11.
//  Copyright (c) 2015年 muxi. All rights reserved.
//  cell基类


#import <UIKit/UIKit.h>
#import "BaseCellProtocol.h"


@interface BaseTableViewCell : UITableViewCell<BaseCellProtocol>

/** indexPath */
@property (nonatomic,strong) NSIndexPath *indexPath;

/** 模型 */
@property (nonatomic,strong) BaseModel *baseModel;




/** cell实例：必须从xib创建 */
+(instancetype)cellFromTableView:(UITableView *)tableView;



@end
