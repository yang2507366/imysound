//
//  SoundSubManager.m
//  imysound
//
//  Created by yzx on 12-7-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SoundSubManager.h"
#import "DBKeyValueManager.h"
#import "CodeUtils.h"
#import "CommonUtils.h"

@interface SoundSubManager ()

@property(nonatomic, retain)id<KeyValueManager> keyValueMgr;

@end

@implementation SoundSubManager

@synthesize keyValueMgr = _keyValueMgr;

+ (id)sharedManager
{
    static id instance = nil;
    
    @synchronized(instance){
        if(instance == nil){
            instance = [[self.class alloc] init];
        }
    }
    
    return instance;
}

- (void)dealloc
{
    [_keyValueMgr release];
    [super dealloc];
}

- (id)init
{
    self = [super init];
    
    NSString *filePath = [[CommonUtils libraryPath] stringByAppendingPathComponent:@"sound_sub"];
    self.keyValueMgr = [[[DBKeyValueManager alloc] initWithDBName:@"sound_sub_" atFilePath:filePath] autorelease];
    
    return self;
}

- (void)setSubListWithArray:(NSArray *)subList forIdentifier:(NSString *)identifier
{
    NSData *subListData = [NSKeyedArchiver archivedDataWithRootObject:subList];
    NSString *subListDataString = [CodeUtils encodeWithData:subListData];
    [self.keyValueMgr setValue:subListDataString forKey:identifier];
}

- (NSArray *)subListForIdentifier:(NSString *)identifier
{
    NSString *subListDataString = [self.keyValueMgr valueForKey:identifier];
    if(subListDataString){
        NSData *subListData = [CodeUtils dataDecodedWithString:subListDataString];
        NSArray *subList = [NSKeyedUnarchiver unarchiveObjectWithData:subListData];
        return subList;
    }
    
    return nil;
}

@end
