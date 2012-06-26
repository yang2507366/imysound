//
//  DBKeyValueCache.h
//  imyvoa
//
//  Created by yzx on 12-5-30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KeyValueCache.h"
#import "sqlite3.h"

@interface DBKeyValueCache : NSObject <KeyValueCache> {
    NSString *_cacheName;
    NSString *_dbFilePath;
    
    sqlite3 *_db;
}

- (id)initWithCacheName:(NSString *)cacheName;
- (id)initWithCacheName:(NSString *)cacheName atFilePath:(NSString *)filePath;

@end
