//
//  CoreModelConst.h
//  CoreModel
//
//  Created by muxi on 15/3/27.
//  Copyright (c) 2015年 muxi. All rights reserved.
//

#ifndef _BaseMoelConst_H_
#define _BaseMoelConst_H_

/** Debug */
#define CoreModelDeBug 1



#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define NSArrayNorlMalTypes @[@"NSString",@"NSData"]

#define ThreadShow(msg) if(CoreModelDeBug){NSLog(@"%@所在线程：%@",@#msg,[NSThread currentThread]);};
#define TriggerBlock(block,res) if(block != nil ) block(res);
#define AutoMsg @"框架正在全自动创表，并稍后自动重新执行您的操作，请放心！"
#define AutoTry 0.1


/**
 *  NSString
 */
UIKIT_EXTERN NSString *const CoreNSString;



/**
 *  NSInteger
 */
UIKIT_EXTERN NSString *const CoreNSInteger;



/**
 *  NSUInteger
 */
UIKIT_EXTERN NSString *const CoreNSUInteger;



/**
 *  CGFloat
 */
UIKIT_EXTERN NSString *const CoreCGFloat;



/**
 *  Enum、int
 */
UIKIT_EXTERN NSString *const CoreEnum_int;



/**
 *  BOOL:BOOL类型的变量对应sqlite中的integer方便扩展
 */
UIKIT_EXTERN NSString *const CoreBOOL;




/**
 *  NSData
 */
UIKIT_EXTERN NSString *const CoreNSData;



/**
 *  NSArray
 */
UIKIT_EXTERN NSString *const CoreNSArray;






/**
 *  SQL语句Const
 */

/**
 *  INTEGER
 */
UIKIT_EXTERN NSString *const INTEGER_TYPE;


/**
 *  TEXT
 */
UIKIT_EXTERN NSString *const TEXT_TYPE;


/**
 *  REAL
 */
UIKIT_EXTERN NSString *const REAL_TYPE;


/**
 *  BLOB
 */
UIKIT_EXTERN NSString *const BLOB_TYPE;







/**
 *  其他定义
 */

/**
 *  空字符串
 */
UIKIT_EXTERN NSString *const EmptyString;


/**
 *  标识字符串
 */
UIKIT_EXTERN NSString *const SymbolString;


#endif
