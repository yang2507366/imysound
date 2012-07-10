//
//  SoundSubManager.h
//  imysound
//
//  Created by yzx on 12-7-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"
#import "KeyValueManager.h"

@interface SoundSubManager : Singleton {
    id<KeyValueManager> _keyValueMgr;
}

- (void)setSubListWithArray:(NSArray *)subList forIdentifier:(NSString *)identifier;
- (NSArray *)subListForIdentifier:(NSString *)identifier;

@end
