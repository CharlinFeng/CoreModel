//
//  BaseCell.m
//  4s
//
//  Created by muxi on 15/3/11.
//  Copyright (c) 2015年 muxi. All rights reserved.
//

#import "BaseCell.h"

@implementation BaseCell





/**
 *  cell实例
 *
 *  @param tableView tableView
 *
 *  @return 实例
 */
+(instancetype)cellFromTableView:(UITableView *)tableView{
    
    NSString *rid=NSStringFromClass(self);
    
    BaseCell *cell=[tableView dequeueReusableCellWithIdentifier:rid];
    
    if(cell==nil){
        cell=[[[NSBundle mainBundle] loadNibNamed:rid owner:nil options:nil] firstObject];
    }
    
    return cell;
}


-(void)setModel:(BaseModel *)model{
    
    _model=model;
    [self dataFillUseModel];
}

/**
 *  子类实现此方法
 */
-(void)dataFillUseModel{}






@end
