//
//  PlayItem.m
//  imysound
//
//  Created by yzx on 12-7-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PlayItem.h"

@implementation PlayItem

@synthesize soundFilePath;
@synthesize beginTime;
@synthesize endTime;

- (void)dealloc
{
    [soundFilePath release];
    [super dealloc];
}

@end
