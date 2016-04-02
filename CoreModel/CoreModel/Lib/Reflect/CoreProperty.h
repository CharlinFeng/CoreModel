//
//  CoreProperty.h
//  test
//
//  Created by 冯成林 on 16/3/31.
//  Copyright © 2016年 冯成林. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    
    /** Unknown */
    CorePropertyTypeUnknown = 0,
    
    /** Bool */
    CorePropertyTypeBool,
    
    /** Int */
    CorePropertyTypeNSInteger,
    
    /** CGFloat */
    CorePropertyTypeCGFloat,
    
    /** double */
    CorePropertyTypeDouble,
    
    /** NSString */
    CorePropertyTypeNSString,
    
    /** NSArray */
    CorePropertyTypeNSArray,
    
    /** NSDictionary */
    CorePropertyTypeNSDictionary,
    
    /** UIImage */
    CorePropertyTypeUIImage,
    
    /** NSData */
    CorePropertyTypeNSData,
    
    /** CustomObj */
    CorePropertyTypeCustomObj,
    
} CorePropertyType;






@interface CoreProperty : NSObject

@property (nonatomic,copy) NSString *name;

@property (nonatomic,copy) NSString *code;

@property (nonatomic,assign) CorePropertyType type;

@property (nonatomic,copy) NSString *typeString;


@end
