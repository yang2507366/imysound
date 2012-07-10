//
//  Utils.h
//  VOA
//
//  Created by yangzexin on 12-3-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommonUtils : NSObject

+ (NSString *)formatTimeNumber:(NSInteger)n;

+ (BOOL)singleCharIsChinese:(NSString *)str;
+ (BOOL)stringContainsChinese:(NSString *)str;

+ (NSString *)documentPath;
+ (NSString *)randomString;
+ (NSString *)tmpPath;
+ (NSString *)formatNumber:(NSUInteger)number;

+ (NSArray *)fileNameListInDocumentPath;

@end
