//
//  PlayQueueControlFactory.m
//  imysound
//
//  Created by yzx on 12-7-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PlayQueueControlFactory.h"
#import "PlayQueueControlNormal.h"

@implementation PlayQueueControlFactory

+ (id<PlayQueueControl>)createNormalPlayQueueControl
{
    return [[[PlayQueueControlNormal alloc] init] autorelease];
}

+ (id<PlayQueueControl>)createSingleLoopPlayQueueControl
{
    return [[[PlayQueueControlNormal alloc] init] autorelease];
}

+ (id<PlayQueueControl>)createLoopPlayQueueControl
{
    return [[[PlayQueueControlNormal alloc] init] autorelease];
}

@end
