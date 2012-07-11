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

@property(nonatomic, retain)UIBarButtonItem *playBtn;
@property(nonatomic, retain)UIBarButtonItem *pauseBtn;

@property(nonatomic, retain)NSArray *playingToolbarItemList;
@property(nonatomic, retain)NSArray *pausedToolbarItemList;

- (UIBarButtonItem *)createFlexibleSpaceBarButtonItem;

@end

@implementation PlayerControlView

@synthesize delegate = _delegate;

@synthesize toolbar = _toolbar;

@synthesize playBtn = _playBtn;
@synthesize pauseBtn = _pauseBtn;

@synthesize playingToolbarItemList = _playingToolbarItemList;
@synthesize pausedToolbarItemList = _pausedToolbarItemList;

- (void)dealloc
{
    [_toolbar release];
    
    [_playBtn release];
    [_pauseBtn release];

    [_playingToolbarItemList release];
    [_pausedToolbarItemList release];
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
    self.toolbar.barStyle = UIBarStyleBlack;
    
    self.playBtn = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay 
                                                                 target:self 
                                                                 action:@selector(onPlayBtnTapped)] autorelease];
    self.pauseBtn = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPause 
                                                                  target:self 
                                                                  action:@selector(onPauseBtnTapped)] autorelease];
    
    NSMutableArray *playingToolbarItemList = [NSMutableArray array];
    self.playingToolbarItemList = playingToolbarItemList;
    [playingToolbarItemList addObject:[self createFlexibleSpaceBarButtonItem]];
    [playingToolbarItemList addObject:self.pauseBtn];
    [playingToolbarItemList addObject:[self createFlexibleSpaceBarButtonItem]];
    
    NSMutableArray *pauseToolbarItemList = [NSMutableArray array];
    self.pausedToolbarItemList = pauseToolbarItemList;
    [pauseToolbarItemList addObject:[self createFlexibleSpaceBarButtonItem]];
    [pauseToolbarItemList addObject:self.playBtn];
    [pauseToolbarItemList addObject:[self createFlexibleSpaceBarButtonItem]];
    
    self.toolbar.items = pauseToolbarItemList;
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.toolbar.frame = self.bounds;
}

#pragma mark - events
- (void)onPlayBtnTapped
{
    if([self.delegate respondsToSelector:@selector(playerControlView:didUpdatePlayStatus:)]){
        [self.delegate playerControlView:self didUpdatePlayStatus:YES];
    }
}

- (void)onPauseBtnTapped
{
    if([self.delegate respondsToSelector:@selector(playerControlView:didUpdatePlayStatus:)]){
        [self.delegate playerControlView:self didUpdatePlayStatus:NO];
    }
}

#pragma mark - private methods
- (UIBarButtonItem *)createFlexibleSpaceBarButtonItem
{
    return [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace 
                                                          target:nil 
                                                          action:nil] autorelease];
}

#pragma mark - instance methods
- (void)setPlaying:(BOOL)playing
{
    self.toolbar.items = playing ? self.playingToolbarItemList : self.pausedToolbarItemList;
}

@end
