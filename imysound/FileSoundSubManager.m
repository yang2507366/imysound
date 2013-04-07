//
//  FileSoundSubManager.m
//  imysound
//
//  Created by yangzexin on 13-4-7.
//
//

#import "FileSoundSubManager.h"

@interface FileSoundSubManager ()

@property(nonatomic, copy)NSString *soundFilePath;
@property(nonatomic, copy)NSString *soundSubDictionaryPath;
@property(nonatomic, retain)NSMutableDictionary *keyValue;

@end

@implementation FileSoundSubManager

- (void)dealloc
{
    self.soundFilePath = nil;
    self.keyValue = nil;
    [super dealloc];
}

- (id)initWithSoundFilePath:(NSString *)soundFilePath
{
    self = [super init];
    
    self.soundFilePath = soundFilePath;
    NSString *soundFileName = [soundFilePath lastPathComponent];
    NSString *parentDirectoryPath = [soundFilePath stringByDeletingLastPathComponent];
    self.soundSubDictionaryPath = [NSString stringWithFormat:@"%@/%@.xml", parentDirectoryPath, soundFileName];
    self.keyValue = [NSMutableDictionary dictionaryWithContentsOfFile:self.soundSubDictionaryPath];
    if(!self.keyValue){
        self.keyValue = [NSMutableDictionary dictionary];
        [self save];
    }
    return self;
}

- (void)save
{
    [self.keyValue writeToFile:self.soundSubDictionaryPath atomically:NO];
}

- (void)setValue:(NSString *)value forKey:(NSString *)key
{
    [self.keyValue setObject:value forKey:key];
    [self save];
}

- (NSString *)valueForKey:(NSString *)key
{
    return [self.keyValue valueForKey:key];
}

- (void)removeValueForKey:(NSString *)key
{
    [self.keyValue removeObjectForKey:key];
    [self save];
}

- (void)clear
{
    [self.keyValue removeAllObjects];
    [self save];
}

- (NSArray *)allKeys
{
    return [self.keyValue allKeys];
}

- (NSArray *)keyListAtIndex:(NSInteger)index size:(NSInteger)size
{
    NSMutableArray *arr = [NSMutableArray array];
    NSArray *allKeys = [self allKeys];
    NSInteger endIndex = index + size > allKeys.count ? allKeys.count : index + size;
    for(NSInteger i = index; i < endIndex; ++i){
        [arr addObject:[allKeys objectAtIndex:i]];
    }
    return arr;
}

@end
