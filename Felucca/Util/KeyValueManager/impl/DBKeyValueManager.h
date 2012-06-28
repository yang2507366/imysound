//
//  DBKeyValueCache.h
//  imyvoa
//
//  Created by yzx on 12-5-30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KeyValueManager.h"
#import "sqlite3.h"

@interface DBKeyValueManager : NSObject <KeyValueManager> {
    NSString *_cacheName;
    NSString *_dbFilePath;
    
    sqlite3 *_db;
}

- (id)initWithDBName:(NSString *)cacheName;
- (id)initWithDBName:(NSString *)cacheName atFilePath:(NSString *)filePath;

@end
