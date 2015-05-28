//
//  NSString+CoreFMDB.m
//  CoreFMDB
//
//  Created by muxi on 15/3/27.
//  Copyright (c) 2015年 muxi. All rights reserved.
//

#import "NSString+CoreFMDB.h"

@implementation NSString (CoreFMDB)



/**
 *  转为documents下的子文件夹
 */
-(NSString *)documentsSubFolder{
    
    NSString *documentFolder=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    return [NSString makeSubFolderInSuperFolder:documentFolder subFloder:self];
    
}



/**
 *  文件夹处理
 */
+(NSString *)makeSubFolderInSuperFolder:(NSString *)superFolder subFloder:(NSString *)subFloder{
    
    NSString *folder=[NSString stringWithFormat:@"%@/%@",superFolder,subFloder];
    
    BOOL isDir = NO;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    BOOL existed = [fileManager fileExistsAtPath:folder isDirectory:&isDir];
    
    if ( !(isDir == YES && existed == YES) )
    {
        [fileManager createDirectoryAtPath:folder withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    return folder;
}




























@end
