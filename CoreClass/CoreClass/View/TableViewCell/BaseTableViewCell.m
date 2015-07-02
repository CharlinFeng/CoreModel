//
//  BaseCell.m
//  4s
//
//  Created by muxi on 15/3/11.
//  Copyright (c) 2015年 muxi. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "NSObject+BaseModelCommon.h"

@implementation BaseTableViewCell





/**
 *  cell实例
 *
 *  @param tableView tableView
 *
 *  @return 实例
 */
+(instancetype)cellFromTableView:(UITableView *)tableView{
    
    NSString *rid=[self modelName];
    
    BaseTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:rid];
    
    if(cell==nil){
        cell=[[[NSBundle mainBundle] loadNibNamed:rid owner:nil options:nil] firstObject];
    }
    
    return cell;
}



-(void)setBaseModel:(BaseModel *)baseModel{
    
    _baseModel = baseModel;
    
    [self dataFill:baseModel];
}






@end
