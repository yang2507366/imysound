//
//  Utils.m
//  VOA
//
//  Created by yangzexin on 12-3-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CommonUtils.h"

@implementation CommonUtils

+ (NSString *)formatTimeNumber:(NSInteger)n
{
    if (n < 10) {
        return [NSString stringWithFormat:@"0%d", n];
    }
    return [NSString stringWithFormat:@"%d", n];
}

+ (BOOL)singleCharIsChinese:(NSString *)str
{
    int firstChar = [str characterAtIndex:0];
    if(firstChar >= 0x4e00 && firstChar <= 0x9FA5){
        return YES;
    }
    return NO;
}

+ (BOOL)stringContainsChinese:(NSString *)str
{
    BOOL contains = NO;
    for(NSInteger i = 0; i < [str length]; ++i){
        NSString *sub = [str substringWithRange:NSMakeRange(i, 1)];
        if([CommonUtils singleCharIsChinese:sub]){
            contains = YES;
            break;
        }
    }
    return contains;
}

+ (NSString *)documentPath
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

+ (NSString *)randomString
{
    NSDate *date = [[[NSDate alloc] init] autorelease];
    NSString *randomString = [NSString stringWithFormat:@"%f", [date timeIntervalSinceReferenceDate]];
    
    return [randomString stringByReplacingOccurrencesOfString:@"." withString:@""];
}

+ (NSString *)tmpPath
{
    NSString *homeDirectory = NSHomeDirectory();
    
    return [NSString stringWithFormat:@"%@/tmp/", homeDirectory];
}

+ (NSString *)formatNumber:(NSUInteger)number
{
    if(number < 10){
        return [NSString stringWithFormat:@"0%d", number];
    }
    return [NSString stringWithFormat:@"%d", number];
}

+ (NSArray *)fileNameListInDocumentPath
{
    NSString *documentPath = [self documentPath];
    return [[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentPath error:nil];
}

@end
