//
//  BaseCollectionViewCell.h
//  CoreList
//
//  Created by 成林 on 15/6/7.
//  Copyright (c) 2015年 muxi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseCellProtocol.h"

@interface BaseCollectionViewCell : UICollectionViewCell<BaseCellProtocol>

/** 模型 */
@property (nonatomic,strong) BaseModel *baseModel;


/** 为指定的collectionView从Nib注册cell */
+(void)registerNibForCollectionView:(UICollectionView *)collectionView;

/** 取出利用cell */
+(instancetype)dequeueReusableCellWithCollectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath*)indexPath;



@end
