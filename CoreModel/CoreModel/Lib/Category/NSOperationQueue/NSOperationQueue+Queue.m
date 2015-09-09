//
//  NSOperationQueue+Queue.m
//  CoreClass
//
//  Created by 成林 on 15/8/30.
//  Copyright (c) 2015年 muxi. All rights reserved.
//

#import "NSOperationQueue+Queue.h"

@implementation NSOperationQueue (Queue)

+(instancetype)queue{
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    queue.maxConcurrentOperationCount = 3;
    return queue;
}

@end
