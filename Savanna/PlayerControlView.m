//
//  PlayerControlView.m
//  imysound
//
//  Created by gewara on 12-7-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PlayerControlView.h"

@interface PlayerControlView ()

@property(nonatomic, retain)UIToolbar *toolbar;

@end

@implementation PlayerControlView

@synthesize toolbar = _toolbar;

- (void)dealloc
{
    [_toolbar release];
    [super dealloc];
}

- (id)init
{
    self = [self initWithFrame:CGRectZero];
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    self.toolbar = [[[UIToolbar alloc] init] autorelease];
    [self addSubview:self.toolbar];
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.toolbar.frame = self.bounds;
}

@end
