//
//  BaseCollectionViewCell.m
//  CoreList
//
//  Created by 成林 on 15/6/7.
//  Copyright (c) 2015年 muxi. All rights reserved.
//

#import "BaseCollectionViewCell.h"
#import "NSObject+BaseModelCommon.h"

NSString * _CollectionViewCellRid;

@implementation BaseCollectionViewCell

/** 为指定的collectionView从Nib注册cell */
+(void)registerNibForCollectionView:(UICollectionView *)collectionView;{
    [collectionView registerNib:[UINib nibWithNibName:[self CollectionViewCellRid] bundle:nil] forCellWithReuseIdentifier:_CollectionViewCellRid];
}



/** 取出利用cell */
+(instancetype)dequeueReusableCellWithCollectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath*)indexPath{
    BaseCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[self CollectionViewCellRid] forIndexPath:indexPath];
    
    return cell;
}



-(void)setBaseModel:(BaseModel *)baseModel{
    
    _baseModel = baseModel;
    
    [self dataFill:baseModel];
}




+(NSString *)CollectionViewCellRid{
    
    if(_CollectionViewCellRid == nil){
        _CollectionViewCellRid =[self modelName];
    }
    
    return _CollectionViewCellRid;
}

@end
