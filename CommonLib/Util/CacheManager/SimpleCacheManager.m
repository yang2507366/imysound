//
//  SimpleCacheManager.m
//  imysound
//
//  Created by gewara on 12-6-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SimpleCacheManager.h"

@interface SimpleCacheManager ()

@property(nonatomic, retain)NSMutableDictionary *cacheDictionary;

@end

@implementation SimpleCacheManager

@synthesize cacheDictionary = _cacheDictionary;

- (void)dealloc
{
    [_cacheDictionary release];
    [super dealloc];
}

- (id)init
{
    self = [super init];
    
    self.cacheDictionary = [NSMutableDictionary dictionary];
    
    return self;
}

- (void)addCacheForKey:(NSString *)key content:(NSString *)content
{
    [self.cacheDictionary setObject:content forKey:key];
}

- (NSString *)cacheContentForKey:(NSString *)key
{
    return [self.cacheDictionary objectForKey:key];
}

- (void)clearAllCache
{
    [self.cacheDictionary removeAllObjects];
}

@end
