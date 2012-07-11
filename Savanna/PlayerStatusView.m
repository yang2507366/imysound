//
//  PlayerControlView.m
//  imysound
//
//  Created by gewara on 12-7-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PlayerControlView.h"

@interface PlayerControlView ()

@property(nonatomic, retain)UIView *topBlackBar;
@property(nonatomic, retain)UIView *bottomLine;
@property(nonatomic, retain)UILabel *currentTimeLabel;
@property(nonatomic, retain)UILabel *totalTimeLabel;
@property(nonatomic, retain)UISlider *positionSilder;

@property(nonatomic, assign)BOOL positionSilderTouching;

@end

@implementation PlayerControlView

@synthesize topBlackBar = _topBlackBar;
@synthesize bottomLine = _bottomLine;
@synthesize currentTimeLabel = _currentTimeLabel;
@synthesize totalTimeLabel = _totalTimeLabel;
@synthesize positionSilder = _positionSilder;

@synthesize positionSilderTouching = _positionSilderTouching;

- (void)dealloc
{
    [_topBlackBar release];
    [_bottomLine release];
    [_currentTimeLabel release];
    [_totalTimeLabel release];
    [_positionSilder release];
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
    
    // position slider
    self.topBlackBar = [[[UIView alloc] init] autorelease];
    [self addSubview:self.topBlackBar];
    self.topBlackBar.backgroundColor = [UIColor blackColor];
    self.topBlackBar.alpha = 0.52f;
    
    self.bottomLine = [[[UIView alloc] init] autorelease];
    [self addSubview:self.bottomLine];
    self.bottomLine.backgroundColor = [UIColor blackColor];
    self.bottomLine.alpha = 0.67f;
    
    self.positionSilder = [[[UISlider alloc] init] autorelease];
    [self.positionSilder addTarget:self 
                            action:@selector(onPositionSilderDragEnter) 
                  forControlEvents:UIControlEventTouchDown];
    [self.positionSilder addTarget:self 
                            action:@selector(onPositionSilderDragExit) 
                  forControlEvents:UIControlEventTouchUpInside];
    [self.positionSilder addTarget:self 
                            action:@selector(onPositionSilderDragExit) 
                  forControlEvents:UIControlEventTouchUpOutside];
    [self addSubview:self.positionSilder];
    
    // time labels
    UIFont *timeFont = [UIFont systemFontOfSize:12.0f];
    self.currentTimeLabel = [[[UILabel alloc] init] autorelease];
    [self addSubview:self.currentTimeLabel];
    self.currentTimeLabel.backgroundColor = [UIColor clearColor];
    self.currentTimeLabel.textColor = [UIColor whiteColor];
    self.currentTimeLabel.font = timeFont;
    self.currentTimeLabel.text = @"00:00";
    
    self.totalTimeLabel = [[[UILabel alloc] init] autorelease];
    [self addSubview:self.totalTimeLabel];
    self.totalTimeLabel.backgroundColor = [UIColor clearColor];
    self.totalTimeLabel.textColor = [UIColor whiteColor];
    self.totalTimeLabel.font = timeFont;
    self.totalTimeLabel.text = @"00:00";
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.topBlackBar.frame = self.bounds;
    self.bottomLine.frame = CGRectMake(0, self.bounds.size.height - 1, self.bounds.size.width, 1);
    
    CGRect frame;
    frame.origin.x = 47;
    frame.size.width = self.bounds.size.width - (frame.origin.x * 2);
    frame.size.height = 20.0f;
    frame.origin.y = (self.bounds.size.height - frame.size.height) / 2;
    self.positionSilder.frame = frame;
    
    frame.size.width = [@"00:00" sizeWithFont:self.currentTimeLabel.font].width;
    frame.origin.x = self.positionSilder.frame.origin.x - frame.size.width - 2;
    frame.origin.y = self.positionSilder.frame.origin.y;
    frame.size.height = self.positionSilder.frame.size.height;
    self.currentTimeLabel.frame = frame;
    
    frame = self.currentTimeLabel.frame;
    frame.origin.x = self.positionSilder.frame.origin.x + self.positionSilder.frame.size.width + 2;
    self.totalTimeLabel.frame = frame;
}

#pragma mark - events
- (void)onPositionSilderDragEnter
{
    self.positionSilderTouching = YES;
}

- (void)onPositionSilderDragExit
{
    self.positionSilderTouching = NO;
}

@end
