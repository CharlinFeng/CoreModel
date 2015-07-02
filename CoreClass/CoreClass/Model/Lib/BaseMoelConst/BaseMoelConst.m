//
//  BaseModelConst.m
//  BaseModel
//
//  Created by muxi on 15/3/27.
//  Copyright (c) 2015年 muxi. All rights reserved.
//

#ifndef _BaseMoelConst_M_
#define _BaseMoelConst_M_


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>




/**
 *  字符串
 */
NSString *const CoreNSString = @"NSString";




/**
 *  NSInteger
 */
NSString *const CoreNSInteger = @"q,i";



/**
 *  NSUInteger
 */
NSString *const CoreNSUInteger = @"Q,I";




/**
 *  CGFloat
 */
NSString *const CoreCGFloat = @"d,f";



/**
 *  float
 */
NSString *const Corefloat = @"f";



/**
 *  double
 */
NSString *const Coredouble = @"d";



/**
 *  Enum、int
 */
NSString *const CoreEnum_int = @"i";



/**
 *  BOOL
 */
NSString *const CoreBOOL = @"B,c";






/**
 *  SQL语句Const
 */

/**
 *  INTEGER
 */
NSString *const INTEGER_TYPE = @"INTEGER NOT NULL DEFAULT 0";


/**
 *  TEXT
 */
NSString *const TEXT_TYPE = @"TEXT NOT NULL DEFAULT ''";


/**
 *  REAL
 */
NSString *const REAL_TYPE = @"REAL NOT NULL DEFAULT 0.0";




/**
 *  其他定义
 */

/**
 *  空字符串
 */
NSString *const EmptyString = @"";


/**
 *  创建重试时间
 */
CGFloat const RetryTimeForTableCreate = 2.0f;


/**
 *  读表字段的重试时间
 */
CGFloat const RetryTimeForFieldRead = 1.0f;




/*
 *  文字定义
 */

/** 提示文字 */
NSString *const HTTP_REQUEST_ERROR_MSG = @"稍后再试";

#endif
