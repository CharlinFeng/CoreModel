//
//  CoreProperty.m
//  test
//
//  Created by 冯成林 on 16/3/31.
//  Copyright © 2016年 冯成林. All rights reserved.
//

#import "CoreProperty.h"


@interface CoreProperty ()

@property (nonatomic,strong) NSArray *typeNames;

@end




@implementation CoreProperty

-(void)setCode:(NSString *)code{

    //去除@
    code = [code stringByReplacingOccurrencesOfString:@"@" withString:@""];
    //去除"
    code = [code stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    
    //记录code
    _code = code;
    
    /** Unknown */
    self.type = CorePropertyTypeUnknown;
    
    /** Bool */
    if ([code isEqualToString:@"c"] || [code isEqualToString:@"B"]) {
        
        self.type = CorePropertyTypeBool; return;
    }
    
    /** Int */
    if ([code isEqualToString:@"i"] || [code isEqualToString:@"q"] || [code isEqualToString:@"Q"] || [code isEqualToString:@"I"]) {
        
        self.type = CorePropertyTypeNSInteger; return;
    }
    
    /** CGFloat */
    if ([code isEqualToString:@"f"]) {
        
        self.type = CorePropertyTypeCGFloat; return;
    }
    
    
    /** double */
    if ([code isEqualToString:@"d"]) {
        
        self.type = CorePropertyTypeDouble; return;
    }
    
    
    /** NSString */
    if ([code isEqualToString:@"NSString"]) {
        
        self.type = CorePropertyTypeNSString; return;
    }
    
    
    /** NSArray */
    if ([code isEqualToString:@"NSArray"]) {
        
        self.type = CorePropertyTypeNSArray; return;
    }
    
    
    /** NSDictionary */
    if ([code isEqualToString:@"NSDictionary"]) {
        
        self.type = CorePropertyTypeNSDictionary; return;
    }
    
    /** UIImage */
    if ([code isEqualToString:@"UIImage"]) {
        
        self.type = CorePropertyTypeUIImage; return;
    }
    
    /** NSData */
    if ([code isEqualToString:@"NSData"]) {
        
        self.type = CorePropertyTypeNSData; return;
    }
    
    /** CustomObj */
    Class cls = NSClassFromString(code);
    
    if(cls == nil) {return;}
    
    if(![[cls new] isKindOfClass:[NSObject class]]) {return;}
    
    self.type = CorePropertyTypeCustomObj;
    
}


-(NSArray *)typeNames{
    
    if(_typeNames == nil){
        
        
        _typeNames = @[@"Unknown",@"Bool",@"Int",@"CGFloat",@"double",@"NSString",@"NSArray",@"NSDictionary",@"UIImage",@"NSData",@"CustomObj"];
    }
    
    return _typeNames;
}


-(NSString *)typeString{
    
    if(_typeString == nil){
        
        _typeString = self.typeNames[self.type];
    }
    
    return _typeString;
}

@end
