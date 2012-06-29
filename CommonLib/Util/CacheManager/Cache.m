//
//  Cache.m
//  imysound
//
//  Created by gewara on 12-6-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Cache.h"

@implementation Cache

@synthesize key;
@synthesize content;
@synthesize date;

- (void)dealloc
{
    [key release];
    [content release];
    [date release];
    [super dealloc];
}

@end
