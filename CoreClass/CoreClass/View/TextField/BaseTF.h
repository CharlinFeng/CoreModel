//
//  BaseTF.h
//  CoreClass
//
//  Created by 成林 on 15/5/24.
//  Copyright (c) 2015年 muxi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseTF : UITextField



/** 左边距 */
@property (nonatomic,assign) CGFloat leftPadding;



/** 最大输入字符数 注：如果使用另设代理，本功能将失效。 */
@property (nonatomic,assign) NSUInteger maxCountNum;





@end
